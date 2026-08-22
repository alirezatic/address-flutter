package com.example.address

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import com.google.android.gms.auth.api.phone.SmsRetriever
import com.google.android.gms.common.api.CommonStatusCodes
import com.google.android.gms.common.api.Status
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        private const val SMS_RETRIEVER_CHANNEL = "address/sms_retriever"
    }

    private var methodChannel: MethodChannel? = null
    private var smsReceiver: BroadcastReceiver? = null
    private var pendingSms: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            SMS_RETRIEVER_CHANNEL,
        )

        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "startSmsRetriever" -> startSmsRetriever(result)

                "takePendingSms" -> {
                    val message = pendingSms
                    pendingSms = null
                    result.success(message)
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun startSmsRetriever(result: MethodChannel.Result) {
        unregisterSmsReceiver()
        pendingSms = null

        val receiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                if (intent.action != SmsRetriever.SMS_RETRIEVED_ACTION) {
                    return
                }

                val status =
                    intent.extras?.get(SmsRetriever.EXTRA_STATUS) as? Status
                        ?: return

                when (status.statusCode) {
                    CommonStatusCodes.SUCCESS -> {
                        val message =
                            intent.extras?.getString(
                                SmsRetriever.EXTRA_SMS_MESSAGE,
                            )

                        if (!message.isNullOrBlank()) {
                            pendingSms = message
                            methodChannel?.invokeMethod(
                                "onSmsReceived",
                                message,
                            )
                        }

                        unregisterSmsReceiver()
                    }

                    else -> unregisterSmsReceiver()
                }
            }
        }

        smsReceiver = receiver

        val filter = IntentFilter(
            SmsRetriever.SMS_RETRIEVED_ACTION,
        )

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                registerReceiver(
                    receiver,
                    filter,
                    SmsRetriever.SEND_PERMISSION,
                    null,
                    Context.RECEIVER_EXPORTED,
                )
            } else {
                @Suppress("DEPRECATION")
                registerReceiver(
                    receiver,
                    filter,
                    SmsRetriever.SEND_PERMISSION,
                    null,
                )
            }
        } catch (error: Exception) {
            smsReceiver = null

            result.error(
                "SMS_RETRIEVER_REGISTER_FAILED",
                error.message,
                null,
            )
            return
        }

        SmsRetriever.getClient(this)
            .startSmsRetriever()
            .addOnSuccessListener {
                result.success(true)
            }
            .addOnFailureListener { error ->
                unregisterSmsReceiver()

                result.error(
                    "SMS_RETRIEVER_START_FAILED",
                    error.message,
                    null,
                )
            }
    }

    private fun unregisterSmsReceiver() {
        val receiver = smsReceiver ?: return

        try {
            unregisterReceiver(receiver)
        } catch (_: IllegalArgumentException) {
            // Receiver was already unregistered.
        }

        smsReceiver = null
    }

    override fun onDestroy() {
        unregisterSmsReceiver()
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
        super.onDestroy()
    }
}