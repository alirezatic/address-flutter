import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

import 'package:address/app/app.dart';
import 'package:address/core/localization/app_locale_controller.dart';
import 'package:address/core/network/api_client.dart';
import 'package:address/features/auth/application/auth_session_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await rive.RiveNative.init();
  await AppLocaleController.instance.load();

  final authSession = AuthSessionController.instance;
  await authSession.load();

  ApiClient.instance.configureAuthentication(
    readAccessToken: () => authSession.accessToken,
    refreshSession: authSession.refreshSession,
  );

  runApp(const AddressApp());
}
