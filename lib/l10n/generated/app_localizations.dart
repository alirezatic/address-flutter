import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fa'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In fa, this message translates to:
  /// **'سوپر اپ'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In fa, this message translates to:
  /// **'خانه'**
  String get home;

  /// No description provided for @phoneNumber.
  ///
  /// In fa, this message translates to:
  /// **'شماره موبایل'**
  String get phoneNumber;

  /// No description provided for @continueLabel.
  ///
  /// In fa, this message translates to:
  /// **'ادامه'**
  String get continueLabel;

  /// No description provided for @retry.
  ///
  /// In fa, this message translates to:
  /// **'تلاش مجدد'**
  String get retry;

  /// No description provided for @unknownError.
  ///
  /// In fa, this message translates to:
  /// **'خطای ناشناختهای رخ داد'**
  String get unknownError;

  /// No description provided for @getStarted.
  ///
  /// In fa, this message translates to:
  /// **'شروع'**
  String get getStarted;

  /// No description provided for @changeLanguage.
  ///
  /// In fa, this message translates to:
  /// **'تغییر زبان'**
  String get changeLanguage;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'رفتوآمد خرید توزیع و خدمات روزمره را سادهتر تجربه کنید.'**
  String get onboardingSubtitle;

  /// No description provided for @onboardingTitle.
  ///
  /// In fa, this message translates to:
  /// **'همه خدمات شهر در یک آدرس'**
  String get onboardingTitle;

  /// عنوان صفحه ورود
  ///
  /// In fa, this message translates to:
  /// **'ورود'**
  String get login;

  /// پیام خوش‌آمدگویی
  ///
  /// In fa, this message translates to:
  /// **'خوش آمدید'**
  String get welcome;

  /// راهنما برای وارد کردن شماره موبایل
  ///
  /// In fa, this message translates to:
  /// **'شماره موبایل خود را وارد کنید'**
  String get enteryourmobilenumber;

  /// برچسب فیلد شماره موبایل
  ///
  /// In fa, this message translates to:
  /// **'شماره موبایل'**
  String get mobileNumber;

  /// خطا زمانی که فیلد شماره موبایل خالی است
  ///
  /// In fa, this message translates to:
  /// **'لطفاً شماره موبایل خود را وارد کنید'**
  String get enterMobileError;

  /// خطا زمانی که شماره شامل کاراکتر غیر عددی است
  ///
  /// In fa, this message translates to:
  /// **'شماره موبایل باید فقط شامل اعداد باشد'**
  String get notDigits;

  /// خطا در صورتی که شماره موبایل با پیشوند مجاز شروع نشده باشد
  ///
  /// In fa, this message translates to:
  /// **'شماره موبایل باید با «09» یا «9» شروع شود'**
  String get invalidPrefix;

  /// خطا وقتی شماره با 0 شروع می‌شود اما طول اشتباه است
  ///
  /// In fa, this message translates to:
  /// **'شماره موبایل باید ۱۱ رقم باشد (با صفر در ابتدای آن)'**
  String get enterMobileErrorWithZero;

  /// خطا وقتی شماره بدون صفر شروع می‌شود اما طول اشتباه است
  ///
  /// In fa, this message translates to:
  /// **'شماره موبایل باید ۱۰ رقم باشد (بدون صفر در ابتدای آن)'**
  String get enterMobileErrorWithoutZero;

  /// خطا زمانی که شماره موبایل بسیار کوتاه است
  ///
  /// In fa, this message translates to:
  /// **'شماره واردشده خیلی کوتاه است'**
  String get tooShort;

  /// خطا در صورت وجود مشکل شبکه
  ///
  /// In fa, this message translates to:
  /// **'خطای شبکه، لطفاً اتصال خود را بررسی کنید'**
  String get networkError;

  /// راهنمای وارد کردن کد تأیید
  ///
  /// In fa, this message translates to:
  /// **'کد پنج‌رقمی ارسال‌شده به {phoneNumber} را وارد کنید'**
  String enterOtpCode(Object phoneNumber);

  /// متن برای عدم دریافت کد همراه با شمارش معکوس
  ///
  /// In fa, this message translates to:
  /// **'کد را دریافت نکردم (۰۰:{seconds})'**
  String didNotReceiveCode(Object seconds);

  /// برچسب دکمه ارسال دوباره کد
  ///
  /// In fa, this message translates to:
  /// **'ارسال مجدد کد'**
  String get resendCode;

  /// دکمه تغییر شماره موبایل
  ///
  /// In fa, this message translates to:
  /// **'تغییر شماره'**
  String get changeNumber;

  /// جداکننده بین گزینه‌ها
  ///
  /// In fa, this message translates to:
  /// **'یا'**
  String get or;

  /// برچسب فیلد ایمیل
  ///
  /// In fa, this message translates to:
  /// **'ایمیل'**
  String get email;

  /// Error shown when the entered OTP code is less than 5 digits
  ///
  /// In fa, this message translates to:
  /// **'لطفاً کد ۵ رقمی را کامل وارد کنید'**
  String get enterFullOtpCode;

  /// Message shown when OTP verification fails
  ///
  /// In fa, this message translates to:
  /// **'کد تأیید واردشده نادرست است'**
  String get invalidOtpCode;

  /// Message shown when OTP challenge is expired
  ///
  /// In fa, this message translates to:
  /// **'کد تأیید منقضی شده است؛ کد جدید دریافت کنید'**
  String get expiredOtpCode;

  /// Message shown when OTP resend cooldown is active
  ///
  /// In fa, this message translates to:
  /// **'لطفاً برای دریافت دوباره کد کمی صبر کنید'**
  String get otpRequestTooSoon;

  /// واژه برای زبان
  ///
  /// In fa, this message translates to:
  /// **'زبان'**
  String get language;

  /// گزینه خروج در منوی کناری
  ///
  /// In fa, this message translates to:
  /// **'خروج از حساب'**
  String get logOut;

  /// عنوان بخش خدمات
  ///
  /// In fa, this message translates to:
  /// **'خدمات'**
  String get services;

  /// برچسب فعالیت‌ها در منو
  ///
  /// In fa, this message translates to:
  /// **'فعالیت‌ها'**
  String get activity;

  /// گزینه پیام‌ها در منوی کناری
  ///
  /// In fa, this message translates to:
  /// **'پیام‌ها'**
  String get messages;

  /// گزینه تنظیمات در منوی کناری
  ///
  /// In fa, this message translates to:
  /// **'تنظیمات'**
  String get settings;

  /// گزینه هدیه در منوی کناری
  ///
  /// In fa, this message translates to:
  /// **'ارسال هدیه'**
  String get sendGift;

  /// گزینه مرکز کسب‌وکار در منو
  ///
  /// In fa, this message translates to:
  /// **'مرکز کسب‌وکار'**
  String get businessHub;

  /// گزینه مدیریت حساب کاربری
  ///
  /// In fa, this message translates to:
  /// **'مدیریت حساب آدرس'**
  String get manageAddressAccount;

  /// عنوان سرویس سفر
  ///
  /// In fa, this message translates to:
  /// **'سفر'**
  String get ride;

  /// عنوان سرویس تحویل
  ///
  /// In fa, this message translates to:
  /// **'تحویل'**
  String get deliver;

  /// عنوان سرویس فرودگاهی
  ///
  /// In fa, this message translates to:
  /// **'فرودگاه'**
  String get airport;

  /// عنوان سرویس موتورسیکلت
  ///
  /// In fa, this message translates to:
  /// **'موتور'**
  String get bike;

  /// زیرنویس سرویس‌های حمل‌ونقل
  ///
  /// In fa, this message translates to:
  /// **'سفر ایمن'**
  String get safeYourTrip;

  /// زیرنویس سرویس شهری
  ///
  /// In fa, this message translates to:
  /// **'هرکجا در شهر'**
  String get anywhereCityTrip;

  /// زیرنویس سرویس فرودگاه
  ///
  /// In fa, this message translates to:
  /// **'سفر شهری یا بین‌شهری'**
  String get cityOrIntercityTrip;

  /// زیرنویس سرویس موتورسیکلت
  ///
  /// In fa, this message translates to:
  /// **'سریع و ایمن'**
  String get fastAndSafe;

  /// عنوان خدمات مسافرتی
  ///
  /// In fa, this message translates to:
  /// **' سفر'**
  String get passengerServices;

  /// عنوان خدمات باربری
  ///
  /// In fa, this message translates to:
  /// **'بارو کالا'**
  String get cargoServices;

  /// عنوان خدمات غذایی
  ///
  /// In fa, this message translates to:
  /// **'غذاوفروشگاه'**
  String get foodServices;

  /// عنوان خدمات عمومی
  ///
  /// In fa, this message translates to:
  /// **' عمومی'**
  String get generalServices;

  /// عنوان خدمات تعمیرات
  ///
  /// In fa, this message translates to:
  /// **'تعمیر و قطعات یدکی'**
  String get repairServices;

  /// عنوان خدمات بیمه‌ای
  ///
  /// In fa, this message translates to:
  /// **'همکاران آدرس'**
  String get insuranceServices;

  /// No description provided for @comingSoon.
  ///
  /// In fa, this message translates to:
  /// **'این بخش به‌زودی فعال می‌شود.'**
  String get comingSoon;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In fa, this message translates to:
  /// **'خروج از حساب'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In fa, this message translates to:
  /// **'آیا می‌خواهید از حساب کاربری خارج شوید؟'**
  String get logoutConfirmMessage;

  /// No description provided for @cancel.
  ///
  /// In fa, this message translates to:
  /// **'انصراف'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In fa, this message translates to:
  /// **'خروج'**
  String get confirm;

  /// No description provided for @addressUser.
  ///
  /// In fa, this message translates to:
  /// **'کاربر آدرس'**
  String get addressUser;

  /// No description provided for @distributionOrders.
  ///
  /// In fa, this message translates to:
  /// **'سفارش‌های توزیع'**
  String get distributionOrders;

  /// No description provided for @distributionOrderDetails.
  ///
  /// In fa, this message translates to:
  /// **'جزئیات سفارش'**
  String get distributionOrderDetails;

  /// No description provided for @allOrders.
  ///
  /// In fa, this message translates to:
  /// **'همه'**
  String get allOrders;

  /// No description provided for @confirmedOrders.
  ///
  /// In fa, this message translates to:
  /// **'تأییدشده'**
  String get confirmedOrders;

  /// No description provided for @receivedOrders.
  ///
  /// In fa, this message translates to:
  /// **'دریافت‌شده'**
  String get receivedOrders;

  /// No description provided for @filterByState.
  ///
  /// In fa, this message translates to:
  /// **'فیلتر وضعیت'**
  String get filterByState;

  /// No description provided for @clearFilters.
  ///
  /// In fa, this message translates to:
  /// **'پاک‌کردن فیلترها'**
  String get clearFilters;

  /// No description provided for @noDistributionOrders.
  ///
  /// In fa, this message translates to:
  /// **'سفارشی پیدا نشد'**
  String get noDistributionOrders;

  /// No description provided for @noDistributionOrdersDescription.
  ///
  /// In fa, this message translates to:
  /// **'در حال حاضر سفارشی با این فیلتر وجود ندارد.'**
  String get noDistributionOrdersDescription;

  /// No description provided for @distributionLoading.
  ///
  /// In fa, this message translates to:
  /// **'در حال دریافت سفارش‌ها...'**
  String get distributionLoading;

  /// No description provided for @distributionLoadError.
  ///
  /// In fa, this message translates to:
  /// **'دریافت سفارش‌ها ممکن نشد'**
  String get distributionLoadError;

  /// No description provided for @distributionNetworkError.
  ///
  /// In fa, this message translates to:
  /// **'ارتباط با سرور برقرار نشد. اتصال شبکه را بررسی کنید.'**
  String get distributionNetworkError;

  /// No description provided for @distributionServerError.
  ///
  /// In fa, this message translates to:
  /// **'سرویس توزیع موقتاً در دسترس نیست.'**
  String get distributionServerError;

  /// No description provided for @distributionInvalidResponse.
  ///
  /// In fa, this message translates to:
  /// **'پاسخ سرویس توزیع قابل پردازش نیست.'**
  String get distributionInvalidResponse;

  /// No description provided for @distributionOrderNotFound.
  ///
  /// In fa, this message translates to:
  /// **'سفارش موردنظر پیدا نشد.'**
  String get distributionOrderNotFound;

  /// No description provided for @orderNumber.
  ///
  /// In fa, this message translates to:
  /// **'شماره سفارش'**
  String get orderNumber;

  /// No description provided for @orderStatus.
  ///
  /// In fa, this message translates to:
  /// **'وضعیت سفارش'**
  String get orderStatus;

  /// No description provided for @walletStatus.
  ///
  /// In fa, this message translates to:
  /// **'وضعیت کیف پول'**
  String get walletStatus;

  /// No description provided for @deliveryStatus.
  ///
  /// In fa, this message translates to:
  /// **'وضعیت تحویل'**
  String get deliveryStatus;

  /// No description provided for @totalAmount.
  ///
  /// In fa, this message translates to:
  /// **'مبلغ کل'**
  String get totalAmount;

  /// No description provided for @plannedDelivery.
  ///
  /// In fa, this message translates to:
  /// **'تحویل برنامه‌ریزی‌شده'**
  String get plannedDelivery;

  /// No description provided for @createdDate.
  ///
  /// In fa, this message translates to:
  /// **'تاریخ ایجاد'**
  String get createdDate;

  /// No description provided for @deliveryDriver.
  ///
  /// In fa, this message translates to:
  /// **'راننده تحویل'**
  String get deliveryDriver;

  /// No description provided for @deliveryTrip.
  ///
  /// In fa, this message translates to:
  /// **'سفر تحویل'**
  String get deliveryTrip;

  /// No description provided for @deliveryConfirmed.
  ///
  /// In fa, this message translates to:
  /// **'تأیید تحویل'**
  String get deliveryConfirmed;

  /// No description provided for @deliveryProof.
  ///
  /// In fa, this message translates to:
  /// **'مدرک تحویل'**
  String get deliveryProof;

  /// No description provided for @orderProducts.
  ///
  /// In fa, this message translates to:
  /// **'اقلام سفارش'**
  String get orderProducts;

  /// No description provided for @quantity.
  ///
  /// In fa, this message translates to:
  /// **'تعداد'**
  String get quantity;

  /// No description provided for @unitPrice.
  ///
  /// In fa, this message translates to:
  /// **'قیمت واحد'**
  String get unitPrice;

  /// No description provided for @finalUnitPrice.
  ///
  /// In fa, this message translates to:
  /// **'قیمت نهایی'**
  String get finalUnitPrice;

  /// No description provided for @walletReservedAmount.
  ///
  /// In fa, this message translates to:
  /// **'مبلغ رزروشده'**
  String get walletReservedAmount;

  /// No description provided for @walletCapturedAmount.
  ///
  /// In fa, this message translates to:
  /// **'مبلغ پرداخت‌شده'**
  String get walletCapturedAmount;

  /// No description provided for @notAvailable.
  ///
  /// In fa, this message translates to:
  /// **'ثبت نشده'**
  String get notAvailable;

  /// No description provided for @viewDetails.
  ///
  /// In fa, this message translates to:
  /// **'مشاهده جزئیات'**
  String get viewDetails;

  /// No description provided for @stateDraft.
  ///
  /// In fa, this message translates to:
  /// **'پیش‌نویس'**
  String get stateDraft;

  /// No description provided for @stateConfirmed.
  ///
  /// In fa, this message translates to:
  /// **'تأییدشده'**
  String get stateConfirmed;

  /// No description provided for @stateReceived.
  ///
  /// In fa, this message translates to:
  /// **'دریافت‌شده'**
  String get stateReceived;

  /// No description provided for @stateCancelled.
  ///
  /// In fa, this message translates to:
  /// **'لغوشده'**
  String get stateCancelled;

  /// No description provided for @walletPaid.
  ///
  /// In fa, this message translates to:
  /// **'پرداخت‌شده'**
  String get walletPaid;

  /// No description provided for @walletReserved.
  ///
  /// In fa, this message translates to:
  /// **'رزروشده'**
  String get walletReserved;

  /// No description provided for @walletUnpaid.
  ///
  /// In fa, this message translates to:
  /// **'پرداخت‌نشده'**
  String get walletUnpaid;

  /// No description provided for @walletRefunded.
  ///
  /// In fa, this message translates to:
  /// **'بازپرداخت‌شده'**
  String get walletRefunded;

  /// No description provided for @deliveryDelivered.
  ///
  /// In fa, this message translates to:
  /// **'تحویل‌شده'**
  String get deliveryDelivered;

  /// No description provided for @deliveryNone.
  ///
  /// In fa, this message translates to:
  /// **'بدون ارسال'**
  String get deliveryNone;

  /// No description provided for @deliveryPending.
  ///
  /// In fa, this message translates to:
  /// **'در انتظار'**
  String get deliveryPending;

  /// No description provided for @deliveryAssigned.
  ///
  /// In fa, this message translates to:
  /// **'اختصاص‌یافته'**
  String get deliveryAssigned;

  /// No description provided for @deliveryInTransit.
  ///
  /// In fa, this message translates to:
  /// **'در مسیر'**
  String get deliveryInTransit;

  /// No description provided for @adminShopAccess.
  ///
  /// In fa, this message translates to:
  /// **'مدیریت دسترسی فروشگاه'**
  String get adminShopAccess;

  /// No description provided for @manageShopAccess.
  ///
  /// In fa, this message translates to:
  /// **'ثبت یا لغو دسترسی فروشگاه'**
  String get manageShopAccess;

  /// No description provided for @adminShopAccessPrivacyNote.
  ///
  /// In fa, this message translates to:
  /// **'شماره کامل فقط برای اجرای همین درخواست استفاده می‌شود و در فهرست به‌صورت ماسک‌شده نمایش داده می‌شود.'**
  String get adminShopAccessPrivacyNote;

  /// No description provided for @shopId.
  ///
  /// In fa, this message translates to:
  /// **'شناسه فروشگاه'**
  String get shopId;

  /// No description provided for @optionalShopId.
  ///
  /// In fa, this message translates to:
  /// **'شناسه فروشگاه (اختیاری)'**
  String get optionalShopId;

  /// No description provided for @invalidShopId.
  ///
  /// In fa, this message translates to:
  /// **'یک شناسه فروشگاه معتبر و مثبت وارد کنید'**
  String get invalidShopId;

  /// No description provided for @invalidAdminMobile.
  ///
  /// In fa, this message translates to:
  /// **'یک شماره موبایل معتبر ایران وارد کنید'**
  String get invalidAdminMobile;

  /// No description provided for @grantAccess.
  ///
  /// In fa, this message translates to:
  /// **'ثبت دسترسی'**
  String get grantAccess;

  /// No description provided for @revokeAccess.
  ///
  /// In fa, this message translates to:
  /// **'لغو دسترسی'**
  String get revokeAccess;

  /// No description provided for @adminAccessGranted.
  ///
  /// In fa, this message translates to:
  /// **'دسترسی ثبت شد'**
  String get adminAccessGranted;

  /// No description provided for @adminAccessRevoked.
  ///
  /// In fa, this message translates to:
  /// **'دسترسی لغو شد'**
  String get adminAccessRevoked;

  /// No description provided for @accessListFilters.
  ///
  /// In fa, this message translates to:
  /// **'فیلترهای فهرست دسترسی'**
  String get accessListFilters;

  /// No description provided for @applyFilters.
  ///
  /// In fa, this message translates to:
  /// **'اعمال'**
  String get applyFilters;

  /// No description provided for @includeInactiveAccess.
  ///
  /// In fa, this message translates to:
  /// **'نمایش دسترسی‌های غیرفعال'**
  String get includeInactiveAccess;

  /// No description provided for @activeAccess.
  ///
  /// In fa, this message translates to:
  /// **'فعال'**
  String get activeAccess;

  /// No description provided for @inactiveAccess.
  ///
  /// In fa, this message translates to:
  /// **'غیرفعال'**
  String get inactiveAccess;

  /// No description provided for @adminAccessLoading.
  ///
  /// In fa, this message translates to:
  /// **'در حال دریافت دسترسی‌های فروشگاه...'**
  String get adminAccessLoading;

  /// No description provided for @noAdminShopAccess.
  ///
  /// In fa, this message translates to:
  /// **'دسترسی‌ای پیدا نشد'**
  String get noAdminShopAccess;

  /// No description provided for @noAdminShopAccessDescription.
  ///
  /// In fa, this message translates to:
  /// **'هیچ نگاشت دسترسی با فیلترهای انتخاب‌شده وجود ندارد.'**
  String get noAdminShopAccessDescription;

  /// No description provided for @adminAccessForbiddenTitle.
  ///
  /// In fa, this message translates to:
  /// **'دسترسی مدیر لازم است'**
  String get adminAccessForbiddenTitle;

  /// No description provided for @adminAccessForbiddenMessage.
  ///
  /// In fa, this message translates to:
  /// **'این حساب اجازه مدیریت دسترسی فروشگاه‌ها را ندارد.'**
  String get adminAccessForbiddenMessage;

  /// No description provided for @adminAccessLoadError.
  ///
  /// In fa, this message translates to:
  /// **'دریافت دسترسی‌ها ممکن نشد'**
  String get adminAccessLoadError;

  /// No description provided for @adminAccessUnauthorized.
  ///
  /// In fa, this message translates to:
  /// **'نشست شما معتبر نیست. دوباره وارد حساب شوید.'**
  String get adminAccessUnauthorized;

  /// No description provided for @adminAccessValidationError.
  ///
  /// In fa, this message translates to:
  /// **'شماره موبایل یا شناسه فروشگاه معتبر نیست.'**
  String get adminAccessValidationError;

  /// No description provided for @adminAccessNetworkError.
  ///
  /// In fa, this message translates to:
  /// **'ارتباط با سرور برقرار نشد. اتصال شبکه را بررسی کنید.'**
  String get adminAccessNetworkError;

  /// No description provided for @adminAccessServerError.
  ///
  /// In fa, this message translates to:
  /// **'سرویس مدیریت دسترسی موقتاً در دسترس نیست.'**
  String get adminAccessServerError;

  /// No description provided for @adminAccessInvalidResponse.
  ///
  /// In fa, this message translates to:
  /// **'پاسخ سرویس مدیریت دسترسی قابل پردازش نیست.'**
  String get adminAccessInvalidResponse;

  /// No description provided for @shopIdVerificationNote.
  ///
  /// In fa, this message translates to:
  /// **'شناسه فروشگاه را از Odoo تأیید کنید؛ Gateway عمداً مجوز گسترده مشاهده فهرست فروشگاه‌ها را ندارد.'**
  String get shopIdVerificationNote;

  /// No description provided for @partnerShop.
  ///
  /// In fa, this message translates to:
  /// **'فروشگاه و سوپرمارکت'**
  String get partnerShop;

  /// No description provided for @addressPartnersIntro.
  ///
  /// In fa, this message translates to:
  /// **'نوع همکاری خود را انتخاب کنید. ثبت‌نام، بررسی مدارک و فعال‌سازی پنل اختصاصی در مراحل بعد انجام می‌شود.'**
  String get addressPartnersIntro;

  /// No description provided for @partnerDistributor.
  ///
  /// In fa, this message translates to:
  /// **'شرکت پخش'**
  String get partnerDistributor;

  /// No description provided for @partnerCarDriver.
  ///
  /// In fa, this message translates to:
  /// **'راننده خودرو'**
  String get partnerCarDriver;

  /// No description provided for @partnerFoodBusiness.
  ///
  /// In fa, this message translates to:
  /// **'رستوران، فست‌فود و کترینگ'**
  String get partnerFoodBusiness;

  /// No description provided for @partnerMotorcycleDriver.
  ///
  /// In fa, this message translates to:
  /// **'راننده موتور'**
  String get partnerMotorcycleDriver;

  /// No description provided for @companyPharmaMedical.
  ///
  /// In fa, this message translates to:
  /// **'محصولات دارویی و تجهیزات پزشکی'**
  String get companyPharmaMedical;

  /// No description provided for @storeBeautyHealth.
  ///
  /// In fa, this message translates to:
  /// **'فروشگاه آرایشی و بهداشتی'**
  String get storeBeautyHealth;

  /// No description provided for @foodBakeryDessert.
  ///
  /// In fa, this message translates to:
  /// **'نان، شیرینی و دسر'**
  String get foodBakeryDessert;

  /// No description provided for @storeBakeryPastry.
  ///
  /// In fa, this message translates to:
  /// **'نانوایی و شیرینی‌فروشی'**
  String get storeBakeryPastry;

  /// No description provided for @foodCatering.
  ///
  /// In fa, this message translates to:
  /// **'کترینگ و تهیه غذا'**
  String get foodCatering;

  /// No description provided for @otherHomeBuilding.
  ///
  /// In fa, this message translates to:
  /// **'خدمات منزل و ساختمان'**
  String get otherHomeBuilding;

  /// No description provided for @driverVan.
  ///
  /// In fa, this message translates to:
  /// **'ون'**
  String get driverVan;

  /// No description provided for @partnerCategoryDriver.
  ///
  /// In fa, this message translates to:
  /// **'راننده'**
  String get partnerCategoryDriver;

  /// No description provided for @driverPickup.
  ///
  /// In fa, this message translates to:
  /// **'وانت'**
  String get driverPickup;

  /// No description provided for @otherTechnicalRepair.
  ///
  /// In fa, this message translates to:
  /// **'خدمات فنی و تعمیرات'**
  String get otherTechnicalRepair;

  /// No description provided for @driverTractorTrailer.
  ///
  /// In fa, this message translates to:
  /// **'کشنده و تریلر'**
  String get driverTractorTrailer;

  /// No description provided for @companyBeautyHealth.
  ///
  /// In fa, this message translates to:
  /// **'محصولات آرایشی و بهداشتی'**
  String get companyBeautyHealth;

  /// No description provided for @foodIranian.
  ///
  /// In fa, this message translates to:
  /// **'رستوران ایرانی'**
  String get foodIranian;

  /// No description provided for @partnerCategoryOther.
  ///
  /// In fa, this message translates to:
  /// **'سایر'**
  String get partnerCategoryOther;

  /// No description provided for @driverLightTruck.
  ///
  /// In fa, this message translates to:
  /// **'کامیونت'**
  String get driverLightTruck;

  /// No description provided for @driverMotorcycle.
  ///
  /// In fa, this message translates to:
  /// **'موتورسیکلت'**
  String get driverMotorcycle;

  /// No description provided for @storeDairy.
  ///
  /// In fa, this message translates to:
  /// **'فروشگاه لبنیات'**
  String get storeDairy;

  /// No description provided for @companyMotorcycleParts.
  ///
  /// In fa, this message translates to:
  /// **'قطعات یدکی موتورسیکلت'**
  String get companyMotorcycleParts;

  /// No description provided for @companyHeavyVehicleParts.
  ///
  /// In fa, this message translates to:
  /// **'قطعات یدکی خودروهای سنگین'**
  String get companyHeavyVehicleParts;

  /// No description provided for @otherHospitality.
  ///
  /// In fa, this message translates to:
  /// **'هتل، اقامتگاه و خدمات گردشگری'**
  String get otherHospitality;

  /// No description provided for @partnersFormNextStage.
  ///
  /// In fa, this message translates to:
  /// **'در مرحله بعد فرم ثبت‌نام این گروه ساخته می‌شود.'**
  String get partnersFormNextStage;

  /// No description provided for @companyCleaning.
  ///
  /// In fa, this message translates to:
  /// **'شوینده‌ها و پاک‌کننده‌ها'**
  String get companyCleaning;

  /// No description provided for @storeProtein.
  ///
  /// In fa, this message translates to:
  /// **'فروشگاه پروتئینی و فرآورده‌های پروتئینی'**
  String get storeProtein;

  /// No description provided for @foodFastFood.
  ///
  /// In fa, this message translates to:
  /// **'فست‌فود'**
  String get foodFastFood;

  /// No description provided for @partnerCategoryCompany.
  ///
  /// In fa, this message translates to:
  /// **'شرکت'**
  String get partnerCategoryCompany;

  /// No description provided for @partnersChooseSubcategory.
  ///
  /// In fa, this message translates to:
  /// **'زمینه فعالیت'**
  String get partnersChooseSubcategory;

  /// No description provided for @foodCafe.
  ///
  /// In fa, this message translates to:
  /// **'کافه و کافی‌شاپ'**
  String get foodCafe;

  /// No description provided for @driverPassengerCar.
  ///
  /// In fa, this message translates to:
  /// **'خودروی سواری'**
  String get driverPassengerCar;

  /// No description provided for @storeFruitVegetable.
  ///
  /// In fa, this message translates to:
  /// **'میوه و سبزی‌فروشی'**
  String get storeFruitVegetable;

  /// No description provided for @partnersChooseCategory.
  ///
  /// In fa, this message translates to:
  /// **'نوع همکاری را انتخاب کنید'**
  String get partnersChooseCategory;

  /// No description provided for @partnersContinue.
  ///
  /// In fa, this message translates to:
  /// **'ادامه'**
  String get partnersContinue;

  /// No description provided for @companyRetailEquipment.
  ///
  /// In fa, this message translates to:
  /// **'تجهیزات و ملزومات فروشگاهی'**
  String get companyRetailEquipment;

  /// No description provided for @otherEvents.
  ///
  /// In fa, this message translates to:
  /// **'تشریفات و خدمات مجالس'**
  String get otherEvents;

  /// No description provided for @otherLaundry.
  ///
  /// In fa, this message translates to:
  /// **'خشکشویی و خدمات شست‌وشو'**
  String get otherLaundry;

  /// No description provided for @driverBus.
  ///
  /// In fa, this message translates to:
  /// **'اتوبوس'**
  String get driverBus;

  /// No description provided for @storeSupermarket.
  ///
  /// In fa, this message translates to:
  /// **'سوپرمارکت'**
  String get storeSupermarket;

  /// No description provided for @storeGrocery.
  ///
  /// In fa, this message translates to:
  /// **'خواربارفروشی'**
  String get storeGrocery;

  /// No description provided for @otherBeautyWellness.
  ///
  /// In fa, this message translates to:
  /// **'خدمات زیبایی و سلامت'**
  String get otherBeautyWellness;

  /// No description provided for @companyPackagingDisposable.
  ///
  /// In fa, this message translates to:
  /// **'محصولات بسته‌بندی و یک‌بارمصرف'**
  String get companyPackagingDisposable;

  /// No description provided for @driverTruck.
  ///
  /// In fa, this message translates to:
  /// **'کامیون'**
  String get driverTruck;

  /// No description provided for @companyLightVehicleParts.
  ///
  /// In fa, this message translates to:
  /// **'قطعات یدکی خودروهای سبک'**
  String get companyLightVehicleParts;

  /// No description provided for @companyFoodBeverage.
  ///
  /// In fa, this message translates to:
  /// **'محصولات غذایی و نوشیدنی'**
  String get companyFoodBeverage;

  /// No description provided for @partnersSingleSelection.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب یک گزینه'**
  String get partnersSingleSelection;

  /// No description provided for @partnerCategoryStore.
  ///
  /// In fa, this message translates to:
  /// **'فروشگاه'**
  String get partnerCategoryStore;

  /// No description provided for @foodHealthyDiet.
  ///
  /// In fa, this message translates to:
  /// **'غذای سالم و رژیمی'**
  String get foodHealthyDiet;

  /// No description provided for @partnerCategoryFood.
  ///
  /// In fa, this message translates to:
  /// **'غذا'**
  String get partnerCategoryFood;

  /// No description provided for @otherBusiness.
  ///
  /// In fa, this message translates to:
  /// **'سایر کسب‌وکارها'**
  String get otherBusiness;

  /// No description provided for @driverMinibus.
  ///
  /// In fa, this message translates to:
  /// **'مینی‌بوس'**
  String get driverMinibus;

  /// No description provided for @foodInternational.
  ///
  /// In fa, this message translates to:
  /// **'رستوران بین‌المللی'**
  String get foodInternational;

  /// No description provided for @partnersMultipleSelection.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب چندگانه'**
  String get partnersMultipleSelection;

  /// No description provided for @foodSeafood.
  ///
  /// In fa, this message translates to:
  /// **'رستوران دریایی'**
  String get foodSeafood;

  /// No description provided for @partnersStartOver.
  ///
  /// In fa, this message translates to:
  /// **'شروع دوباره'**
  String get partnersStartOver;

  /// No description provided for @partnersSelected.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب شد'**
  String get partnersSelected;

  /// No description provided for @partnersSecondaryActivities.
  ///
  /// In fa, this message translates to:
  /// **'فعالیت‌های جانبی'**
  String get partnersSecondaryActivities;

  /// No description provided for @partnersQuestionTitle.
  ///
  /// In fa, this message translates to:
  /// **'کسب‌وکار شما در کدام دسته است؟'**
  String get partnersQuestionTitle;

  /// No description provided for @storeSupermarketDescription.
  ///
  /// In fa, this message translates to:
  /// **'کالای متنوع روزمره'**
  String get storeSupermarketDescription;

  /// No description provided for @partnersSelect.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب'**
  String get partnersSelect;

  /// No description provided for @partnersSummaryReadyTitle.
  ///
  /// In fa, this message translates to:
  /// **'پروفایل کسب‌وکار آماده شد!'**
  String get partnersSummaryReadyTitle;

  /// No description provided for @storeDairyDescription.
  ///
  /// In fa, this message translates to:
  /// **'شیر و فرآورده‌های لبنی'**
  String get storeDairyDescription;

  /// No description provided for @partnersMainCategory.
  ///
  /// In fa, this message translates to:
  /// **'دسته اصلی'**
  String get partnersMainCategory;

  /// No description provided for @partnerGroupOtherSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'خدمات تخصصی و رفاهی'**
  String get partnerGroupOtherSubtitle;

  /// No description provided for @partnerGroupCompaniesSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'تأمین و پخش عمده کالا'**
  String get partnerGroupCompaniesSubtitle;

  /// No description provided for @partnersRegistrationNext.
  ///
  /// In fa, this message translates to:
  /// **'فرم ثبت‌نام و ارسال درخواست در مرحله بعد متصل می‌شود.'**
  String get partnersRegistrationNext;

  /// No description provided for @partnerGroupFoodSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'رستوران، کافه و تهیه غذا'**
  String get partnerGroupFoodSubtitle;

  /// No description provided for @foodCateringDescription.
  ///
  /// In fa, this message translates to:
  /// **'پذیرایی و سفارش'**
  String get foodCateringDescription;

  /// No description provided for @storeBakeryPastryDescription.
  ///
  /// In fa, this message translates to:
  /// **'نان و شیرینی'**
  String get storeBakeryPastryDescription;

  /// No description provided for @partnerGroupCompanies.
  ///
  /// In fa, this message translates to:
  /// **'شرکت‌ها و تأمین‌کنندگان'**
  String get partnerGroupCompanies;

  /// No description provided for @foodInternationalDescription.
  ///
  /// In fa, this message translates to:
  /// **'غذاهای بین‌المللی'**
  String get foodInternationalDescription;

  /// No description provided for @partnersBrandSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'ثبت‌نام و انتخاب دسته کسب‌وکار'**
  String get partnersBrandSubtitle;

  /// No description provided for @partnerGroupDrivers.
  ///
  /// In fa, this message translates to:
  /// **'رانندگان و ناوگان'**
  String get partnerGroupDrivers;

  /// No description provided for @partnersPrimaryBadge.
  ///
  /// In fa, this message translates to:
  /// **'اصلی'**
  String get partnersPrimaryBadge;

  /// No description provided for @partnersSubcategoryCount.
  ///
  /// In fa, this message translates to:
  /// **'{count} زیرمجموعه'**
  String partnersSubcategoryCount(int count);

  /// No description provided for @partnersNothingSelected.
  ///
  /// In fa, this message translates to:
  /// **'هنوز انتخابی نشده'**
  String get partnersNothingSelected;

  /// No description provided for @partnersCompleteRegistration.
  ///
  /// In fa, this message translates to:
  /// **'تکمیل فرم ثبت‌نام'**
  String get partnersCompleteRegistration;

  /// No description provided for @partnersPrimaryActivity.
  ///
  /// In fa, this message translates to:
  /// **'فعالیت اصلی'**
  String get partnersPrimaryActivity;

  /// No description provided for @partnersPrimarySummaryBadge.
  ///
  /// In fa, this message translates to:
  /// **'اصلی'**
  String get partnersPrimarySummaryBadge;

  /// No description provided for @partnerGroupStores.
  ///
  /// In fa, this message translates to:
  /// **'فروشگاه‌ها'**
  String get partnerGroupStores;

  /// No description provided for @storeFruitVegetableDescription.
  ///
  /// In fa, this message translates to:
  /// **'میوه و سبزیجات تازه'**
  String get storeFruitVegetableDescription;

  /// No description provided for @partnersStepConfirm.
  ///
  /// In fa, this message translates to:
  /// **'تأیید نهایی'**
  String get partnersStepConfirm;

  /// No description provided for @partnerGroupDriversSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'حمل‌ونقل و لجستیک'**
  String get partnerGroupDriversSubtitle;

  /// No description provided for @partnersSelectionCount.
  ///
  /// In fa, this message translates to:
  /// **'{count} مورد انتخاب شد'**
  String partnersSelectionCount(int count);

  /// No description provided for @partnersDriverCompany.
  ///
  /// In fa, this message translates to:
  /// **'شرکت حمل‌ونقل'**
  String get partnersDriverCompany;

  /// No description provided for @storeBeautyHealthDescription.
  ///
  /// In fa, this message translates to:
  /// **'لوازم آرایشی و بهداشتی'**
  String get storeBeautyHealthDescription;

  /// No description provided for @partnersVersionLabel.
  ///
  /// In fa, this message translates to:
  /// **'نسخه ۱.۰'**
  String get partnersVersionLabel;

  /// No description provided for @partnersViewSummary.
  ///
  /// In fa, this message translates to:
  /// **'مشاهده خلاصه'**
  String get partnersViewSummary;

  /// No description provided for @foodBakeryDessertDescription.
  ///
  /// In fa, this message translates to:
  /// **'دسر و شیرینی'**
  String get foodBakeryDessertDescription;

  /// No description provided for @foodSeafoodDescription.
  ///
  /// In fa, this message translates to:
  /// **'غذاهای دریایی'**
  String get foodSeafoodDescription;

  /// No description provided for @partnersHintDriverPersonal.
  ///
  /// In fa, this message translates to:
  /// **'به‌عنوان راننده شخصی، یک وسیله اصلی انتخاب کنید.'**
  String get partnersHintDriverPersonal;

  /// No description provided for @partnersOneItem.
  ///
  /// In fa, this message translates to:
  /// **'(یک مورد)'**
  String get partnersOneItem;

  /// No description provided for @partnersSelectedOptions.
  ///
  /// In fa, this message translates to:
  /// **'گزینه‌های انتخابی'**
  String get partnersSelectedOptions;

  /// No description provided for @partnersSummaryReadySubtitle.
  ///
  /// In fa, this message translates to:
  /// **'خلاصه انتخاب‌های شما در آدرس'**
  String get partnersSummaryReadySubtitle;

  /// No description provided for @partnersDriverPersonal.
  ///
  /// In fa, this message translates to:
  /// **'راننده شخصی'**
  String get partnersDriverPersonal;

  /// No description provided for @storeGroceryDescription.
  ///
  /// In fa, this message translates to:
  /// **'خواروبار و مواد اولیه'**
  String get storeGroceryDescription;

  /// No description provided for @foodCafeDescription.
  ///
  /// In fa, this message translates to:
  /// **'قهوه و نوشیدنی'**
  String get foodCafeDescription;

  /// No description provided for @partnersHintMultiple.
  ///
  /// In fa, this message translates to:
  /// **'می‌توانید چند گزینه را هم‌زمان انتخاب کنید.'**
  String get partnersHintMultiple;

  /// No description provided for @foodIranianDescription.
  ///
  /// In fa, this message translates to:
  /// **'غذاهای اصیل ایرانی'**
  String get foodIranianDescription;

  /// No description provided for @foodFastFoodDescription.
  ///
  /// In fa, this message translates to:
  /// **'غذای سریع'**
  String get foodFastFoodDescription;

  /// No description provided for @partnersQuestionSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'یکی از پنج گروه اصلی را انتخاب کنید تا زیرمجموعه‌های مرتبط نمایش داده شوند.'**
  String get partnersQuestionSubtitle;

  /// No description provided for @partnersMainVehicle.
  ///
  /// In fa, this message translates to:
  /// **'وسیله اصلی'**
  String get partnersMainVehicle;

  /// No description provided for @partnerGroupOther.
  ///
  /// In fa, this message translates to:
  /// **'سایر خدمات'**
  String get partnerGroupOther;

  /// No description provided for @partnersStepDetails.
  ///
  /// In fa, this message translates to:
  /// **'جزئیات فعالیت'**
  String get partnersStepDetails;

  /// No description provided for @foodHealthyDietDescription.
  ///
  /// In fa, this message translates to:
  /// **'غذای رژیمی و سالم'**
  String get foodHealthyDietDescription;

  /// No description provided for @partnerGroupStoresSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'فروش مستقیم کالا به مشتریان'**
  String get partnerGroupStoresSubtitle;

  /// No description provided for @partnersStepCategory.
  ///
  /// In fa, this message translates to:
  /// **'دسته اصلی'**
  String get partnersStepCategory;

  /// No description provided for @partnersHintDriverCompany.
  ///
  /// In fa, this message translates to:
  /// **'به‌عنوان شرکت حمل‌ونقل، می‌توانید چند نوع وسیله ثبت کنید.'**
  String get partnersHintDriverCompany;

  /// No description provided for @partnerGroupFood.
  ///
  /// In fa, this message translates to:
  /// **'غذا و پذیرایی'**
  String get partnerGroupFood;

  /// No description provided for @storeProteinDescription.
  ///
  /// In fa, this message translates to:
  /// **'گوشت و فرآورده‌های پروتئینی'**
  String get storeProteinDescription;

  /// No description provided for @partnersHintPrimarySecondary.
  ///
  /// In fa, this message translates to:
  /// **'یک فعالیت اصلی انتخاب کنید، سپس می‌توانید چند فعالیت جانبی اضافه کنید.'**
  String get partnersHintPrimarySecondary;

  /// No description provided for @partnersBack.
  ///
  /// In fa, this message translates to:
  /// **'بازگشت'**
  String get partnersBack;

  /// No description provided for @partnersBrandTitle.
  ///
  /// In fa, this message translates to:
  /// **'همکاران آدرس'**
  String get partnersBrandTitle;

  /// No description provided for @partnersFleetTypes.
  ///
  /// In fa, this message translates to:
  /// **'انواع ناوگان'**
  String get partnersFleetTypes;

  /// No description provided for @partnersSupport.
  ///
  /// In fa, this message translates to:
  /// **'پشتیبانی'**
  String get partnersSupport;

  /// No description provided for @partnersSupportSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'همیشه در کنار شما'**
  String get partnersSupportSubtitle;

  /// No description provided for @partnerRegistrationStart.
  ///
  /// In fa, this message translates to:
  /// **'شروع ثبت‌نام'**
  String get partnerRegistrationStart;

  /// No description provided for @partnerRegistrationContinue.
  ///
  /// In fa, this message translates to:
  /// **'ادامه'**
  String get partnerRegistrationContinue;

  /// No description provided for @partnerRegistrationApplicantTypeTitle.
  ///
  /// In fa, this message translates to:
  /// **'نوع متقاضی را انتخاب کنید'**
  String get partnerRegistrationApplicantTypeTitle;

  /// No description provided for @partnerRegistrationApplicantTypeSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'مشخص کنید درخواست به نام شخص یا شرکت ثبت می‌شود.'**
  String get partnerRegistrationApplicantTypeSubtitle;

  /// No description provided for @partnerRegistrationIndividual.
  ///
  /// In fa, this message translates to:
  /// **'شخص حقیقی'**
  String get partnerRegistrationIndividual;

  /// No description provided for @partnerRegistrationIndividualDescription.
  ///
  /// In fa, this message translates to:
  /// **'ثبت درخواست به نام یک فرد'**
  String get partnerRegistrationIndividualDescription;

  /// No description provided for @partnerRegistrationLegalEntity.
  ///
  /// In fa, this message translates to:
  /// **'شرکت یا کسب‌وکار حقوقی'**
  String get partnerRegistrationLegalEntity;

  /// No description provided for @partnerRegistrationLegalEntityDescription.
  ///
  /// In fa, this message translates to:
  /// **'ثبت درخواست با اطلاعات رسمی شرکت'**
  String get partnerRegistrationLegalEntityDescription;

  /// No description provided for @partnerRegistrationBasicInfoTitle.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات پایه'**
  String get partnerRegistrationBasicInfoTitle;

  /// No description provided for @partnerRegistrationBasicInfoSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات هویتی و راه ارتباطی متقاضی را وارد کنید.'**
  String get partnerRegistrationBasicInfoSubtitle;

  /// No description provided for @partnerRegistrationFullName.
  ///
  /// In fa, this message translates to:
  /// **'نام و نام خانوادگی'**
  String get partnerRegistrationFullName;

  /// No description provided for @partnerRegistrationCompanyName.
  ///
  /// In fa, this message translates to:
  /// **'نام رسمی شرکت یا کسب‌وکار'**
  String get partnerRegistrationCompanyName;

  /// No description provided for @partnerRegistrationRepresentativeName.
  ///
  /// In fa, this message translates to:
  /// **'نام نماینده مسئول'**
  String get partnerRegistrationRepresentativeName;

  /// No description provided for @partnerRegistrationNationalId.
  ///
  /// In fa, this message translates to:
  /// **'کد ملی'**
  String get partnerRegistrationNationalId;

  /// No description provided for @partnerRegistrationCompanyNationalId.
  ///
  /// In fa, this message translates to:
  /// **'شناسه ملی شرکت'**
  String get partnerRegistrationCompanyNationalId;

  /// No description provided for @partnerRegistrationMobile.
  ///
  /// In fa, this message translates to:
  /// **'شماره تلفن همراه'**
  String get partnerRegistrationMobile;

  /// No description provided for @partnerRegistrationEmailOptional.
  ///
  /// In fa, this message translates to:
  /// **'ایمیل (اختیاری)'**
  String get partnerRegistrationEmailOptional;

  /// No description provided for @partnerRegistrationRequiredField.
  ///
  /// In fa, this message translates to:
  /// **'تکمیل این فیلد الزامی است'**
  String get partnerRegistrationRequiredField;

  /// No description provided for @partnerRegistrationInvalidMobile.
  ///
  /// In fa, this message translates to:
  /// **'شماره تلفن همراه معتبر نیست'**
  String get partnerRegistrationInvalidMobile;

  /// No description provided for @partnerRegistrationBasicInfoSaved.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات پایه ذخیره شد؛ مرحله اطلاعات کسب‌وکار بعدی است.'**
  String get partnerRegistrationBasicInfoSaved;

  /// No description provided for @partnerRegistrationBusinessInfoTitle.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات کسب‌وکار'**
  String get partnerRegistrationBusinessInfoTitle;

  /// No description provided for @partnerRegistrationBusinessInfoSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'نام فعالیت، توضیح خدمات و سابقه کاری را ثبت کنید.'**
  String get partnerRegistrationBusinessInfoSubtitle;

  /// No description provided for @partnerRegistrationBusinessName.
  ///
  /// In fa, this message translates to:
  /// **'نام تجاری یا نام فعالیت'**
  String get partnerRegistrationBusinessName;

  /// No description provided for @partnerRegistrationBusinessDescription.
  ///
  /// In fa, this message translates to:
  /// **'توضیح کوتاه درباره محصولات یا خدمات'**
  String get partnerRegistrationBusinessDescription;

  /// No description provided for @partnerRegistrationExperienceYears.
  ///
  /// In fa, this message translates to:
  /// **'سابقه فعالیت به سال (اختیاری)'**
  String get partnerRegistrationExperienceYears;

  /// No description provided for @partnerRegistrationSaveBusinessInfo.
  ///
  /// In fa, this message translates to:
  /// **'ذخیره اطلاعات'**
  String get partnerRegistrationSaveBusinessInfo;

  /// No description provided for @partnerRegistrationBusinessInfoSaved.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات کسب‌وکار در پیش‌نویس ذخیره شد.'**
  String get partnerRegistrationBusinessInfoSaved;

  /// No description provided for @partnerRegistrationIndividualFormTitle.
  ///
  /// In fa, this message translates to:
  /// **'فرم ثبت‌نام شخص حقیقی'**
  String get partnerRegistrationIndividualFormTitle;

  /// No description provided for @partnerRegistrationLegalFormTitle.
  ///
  /// In fa, this message translates to:
  /// **'فرم ثبت‌نام شخص حقوقی'**
  String get partnerRegistrationLegalFormTitle;

  /// No description provided for @partnerRegistrationFormSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات هویتی و اطلاعات فعالیت را در همین فرم وارد کنید.'**
  String get partnerRegistrationFormSubtitle;

  /// No description provided for @partnerRegistrationSubmitApplication.
  ///
  /// In fa, this message translates to:
  /// **'ثبت درخواست'**
  String get partnerRegistrationSubmitApplication;

  /// No description provided for @partnerRegistrationDraftSaved.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات فرم با موفقیت در پیش‌نویس ثبت شد.'**
  String get partnerRegistrationDraftSaved;

  /// No description provided for @partnerRegistrationPersonalInformationTitle.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات فردی'**
  String get partnerRegistrationPersonalInformationTitle;

  /// No description provided for @partnerRegistrationCompanyInformationTitle.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات شرکت'**
  String get partnerRegistrationCompanyInformationTitle;

  /// No description provided for @partnerRegistrationPersonalInformationSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات هویتی و راه‌های تماس را وارد کنید.'**
  String get partnerRegistrationPersonalInformationSubtitle;

  /// No description provided for @partnerRegistrationRepresentativeNationalId.
  ///
  /// In fa, this message translates to:
  /// **'کد ملی نماینده شرکت'**
  String get partnerRegistrationRepresentativeNationalId;

  /// No description provided for @partnerRegistrationCompanyLandline.
  ///
  /// In fa, this message translates to:
  /// **'تلفن ثابت شرکت'**
  String get partnerRegistrationCompanyLandline;

  /// No description provided for @partnerRegistrationLandlineOptional.
  ///
  /// In fa, this message translates to:
  /// **'تلفن ثابت (اختیاری)'**
  String get partnerRegistrationLandlineOptional;

  /// No description provided for @partnerRegistrationInvalidNationalId.
  ///
  /// In fa, this message translates to:
  /// **'کد ملی باید ۱۰ رقم باشد.'**
  String get partnerRegistrationInvalidNationalId;

  /// No description provided for @partnerRegistrationInvalidCompanyNationalId.
  ///
  /// In fa, this message translates to:
  /// **'شناسه ملی شرکت باید ۱۱ رقم باشد.'**
  String get partnerRegistrationInvalidCompanyNationalId;

  /// No description provided for @partnerRegistrationInvalidIranianMobile.
  ///
  /// In fa, this message translates to:
  /// **'شماره همراه باید با ۰۹ شروع شود و ۱۱ رقم باشد.'**
  String get partnerRegistrationInvalidIranianMobile;

  /// No description provided for @partnerRegistrationInvalidLandline.
  ///
  /// In fa, this message translates to:
  /// **'تلفن ثابت را همراه کد شهر و در ۱۱ رقم وارد کنید.'**
  String get partnerRegistrationInvalidLandline;

  /// No description provided for @partnerRegistrationContinueToStore.
  ///
  /// In fa, this message translates to:
  /// **'ادامه و اطلاعات فروشگاه'**
  String get partnerRegistrationContinueToStore;

  /// No description provided for @partnerRegistrationStoreInformationTitle.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات فروشگاه'**
  String get partnerRegistrationStoreInformationTitle;

  /// No description provided for @partnerRegistrationStoreInformationSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'مشخصات محل فعالیت و تصاویر موردنیاز را ثبت کنید.'**
  String get partnerRegistrationStoreInformationSubtitle;

  /// No description provided for @partnerRegistrationStoreName.
  ///
  /// In fa, this message translates to:
  /// **'نام فروشگاه'**
  String get partnerRegistrationStoreName;

  /// No description provided for @partnerRegistrationStoreOwnership.
  ///
  /// In fa, this message translates to:
  /// **'نوع مالکیت فروشگاه'**
  String get partnerRegistrationStoreOwnership;

  /// No description provided for @partnerRegistrationOwnershipOwner.
  ///
  /// In fa, this message translates to:
  /// **'مالک'**
  String get partnerRegistrationOwnershipOwner;

  /// No description provided for @partnerRegistrationOwnershipTenant.
  ///
  /// In fa, this message translates to:
  /// **'مستأجر'**
  String get partnerRegistrationOwnershipTenant;

  /// No description provided for @partnerRegistrationOwnershipGoodwill.
  ///
  /// In fa, this message translates to:
  /// **'سرقفلی'**
  String get partnerRegistrationOwnershipGoodwill;

  /// No description provided for @partnerRegistrationOwnershipOther.
  ///
  /// In fa, this message translates to:
  /// **'سایر'**
  String get partnerRegistrationOwnershipOther;

  /// No description provided for @partnerRegistrationStorePhone.
  ///
  /// In fa, this message translates to:
  /// **'تلفن ثابت فروشگاه'**
  String get partnerRegistrationStorePhone;

  /// No description provided for @partnerRegistrationPostalCode.
  ///
  /// In fa, this message translates to:
  /// **'کد پستی'**
  String get partnerRegistrationPostalCode;

  /// No description provided for @partnerRegistrationStoreArea.
  ///
  /// In fa, this message translates to:
  /// **'متراژ فروشگاه (مترمربع)'**
  String get partnerRegistrationStoreArea;

  /// No description provided for @partnerRegistrationStoreAddress.
  ///
  /// In fa, this message translates to:
  /// **'نشانی کامل فروشگاه'**
  String get partnerRegistrationStoreAddress;

  /// No description provided for @partnerRegistrationBusinessDescriptionOptional.
  ///
  /// In fa, this message translates to:
  /// **'توضیح کوتاه درباره فعالیت (اختیاری)'**
  String get partnerRegistrationBusinessDescriptionOptional;

  /// No description provided for @partnerRegistrationLicenseImage.
  ///
  /// In fa, this message translates to:
  /// **'تصویر مجوز فعالیت'**
  String get partnerRegistrationLicenseImage;

  /// No description provided for @partnerRegistrationLicenseImageOptional.
  ///
  /// In fa, this message translates to:
  /// **'اختیاری؛ برای انتخاب تصویر لمس کنید.'**
  String get partnerRegistrationLicenseImageOptional;

  /// No description provided for @partnerRegistrationSignboardImage.
  ///
  /// In fa, this message translates to:
  /// **'تصویر تابلوی فروشگاه'**
  String get partnerRegistrationSignboardImage;

  /// No description provided for @partnerRegistrationSignboardImageRequired.
  ///
  /// In fa, this message translates to:
  /// **'اجباری؛ برای انتخاب تصویر لمس کنید.'**
  String get partnerRegistrationSignboardImageRequired;

  /// No description provided for @partnerRegistrationSignboardImageValidation.
  ///
  /// In fa, this message translates to:
  /// **'تصویر تابلوی فروشگاه الزامی است.'**
  String get partnerRegistrationSignboardImageValidation;

  /// No description provided for @partnerRegistrationInvalidPostalCode.
  ///
  /// In fa, this message translates to:
  /// **'کد پستی باید ۱۰ رقم باشد.'**
  String get partnerRegistrationInvalidPostalCode;

  /// No description provided for @partnerRegistrationInvalidStoreArea.
  ///
  /// In fa, this message translates to:
  /// **'متراژ فروشگاه باید عددی بیشتر از صفر باشد.'**
  String get partnerRegistrationInvalidStoreArea;

  /// No description provided for @partnerRegistrationDraftCompletedTitle.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات ثبت شد'**
  String get partnerRegistrationDraftCompletedTitle;

  /// No description provided for @partnerRegistrationDraftCompletedMessage.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات در پیش‌نویس نگهداری شد. اتصال ارسال نهایی به سرور در مرحله بعد انجام می‌شود.'**
  String get partnerRegistrationDraftCompletedMessage;

  /// No description provided for @partnerRegistrationDialogConfirm.
  ///
  /// In fa, this message translates to:
  /// **'متوجه شدم'**
  String get partnerRegistrationDialogConfirm;

  /// No description provided for @partnerVerificationOwnerTitle.
  ///
  /// In fa, this message translates to:
  /// **'احراز هویت صاحب کسب‌وکار'**
  String get partnerVerificationOwnerTitle;

  /// No description provided for @partnerVerificationLegalOwnerTitle.
  ///
  /// In fa, this message translates to:
  /// **'احراز هویت نماینده شرکت'**
  String get partnerVerificationLegalOwnerTitle;

  /// No description provided for @partnerVerificationOwnerSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'کد ملی و شماره همراهی را وارد کنید که به نام صاحب کسب‌وکار یا نماینده شرکت است.'**
  String get partnerVerificationOwnerSubtitle;

  /// No description provided for @partnerVerificationOwnerMobile.
  ///
  /// In fa, this message translates to:
  /// **'شماره همراه صاحب کسب‌وکار'**
  String get partnerVerificationOwnerMobile;

  /// No description provided for @partnerVerificationConsent.
  ///
  /// In fa, this message translates to:
  /// **'با استعلام و پردازش اطلاعات هویتی برای ثبت درخواست همکاری موافقم.'**
  String get partnerVerificationConsent;

  /// No description provided for @partnerVerificationConsentRequired.
  ///
  /// In fa, this message translates to:
  /// **'برای انجام استعلام، پذیرش رضایت‌نامه الزامی است.'**
  String get partnerVerificationConsentRequired;

  /// No description provided for @partnerVerificationLookupIdentity.
  ///
  /// In fa, this message translates to:
  /// **'استعلام اطلاعات هویتی'**
  String get partnerVerificationLookupIdentity;

  /// No description provided for @partnerVerificationIdentityResultTitle.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات دریافت‌شده'**
  String get partnerVerificationIdentityResultTitle;

  /// No description provided for @partnerVerificationMobileMatched.
  ///
  /// In fa, this message translates to:
  /// **'مالکیت شماره همراه با کد ملی تطبیق دارد.'**
  String get partnerVerificationMobileMatched;

  /// No description provided for @partnerVerificationMobileMismatch.
  ///
  /// In fa, this message translates to:
  /// **'شماره همراه واردشده متعلق به این کد ملی نیست.'**
  String get partnerVerificationMobileMismatch;

  /// No description provided for @partnerVerificationFatherName.
  ///
  /// In fa, this message translates to:
  /// **'نام پدر'**
  String get partnerVerificationFatherName;

  /// No description provided for @partnerVerificationBirthDate.
  ///
  /// In fa, this message translates to:
  /// **'تاریخ تولد'**
  String get partnerVerificationBirthDate;

  /// No description provided for @partnerVerificationConfirmAccuracy.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات نمایش‌داده‌شده صحیح است و آن را تأیید می‌کنم.'**
  String get partnerVerificationConfirmAccuracy;

  /// No description provided for @partnerVerificationAccuracyRequired.
  ///
  /// In fa, this message translates to:
  /// **'ابتدا صحت اطلاعات نمایش‌داده‌شده را تأیید کنید.'**
  String get partnerVerificationAccuracyRequired;

  /// No description provided for @partnerVerificationConfirmAndContinue.
  ///
  /// In fa, this message translates to:
  /// **'تأیید و ادامه'**
  String get partnerVerificationConfirmAndContinue;

  /// No description provided for @partnerVerificationPostalLookup.
  ///
  /// In fa, this message translates to:
  /// **'دریافت نشانی از کد پستی'**
  String get partnerVerificationPostalLookup;

  /// No description provided for @partnerVerificationPostalResultTitle.
  ///
  /// In fa, this message translates to:
  /// **'نشانی دریافت‌شده'**
  String get partnerVerificationPostalResultTitle;

  /// No description provided for @partnerVerificationMapConfirmationPending.
  ///
  /// In fa, this message translates to:
  /// **'در مرحله بعد، محل دقیق فروشگاه روی نقشه تأیید خواهد شد.'**
  String get partnerVerificationMapConfirmationPending;

  /// No description provided for @partnerVerificationPostalLookupRequired.
  ///
  /// In fa, this message translates to:
  /// **'ابتدا نشانی را از طریق کد پستی استعلام کنید.'**
  String get partnerVerificationPostalLookupRequired;

  /// No description provided for @partnerVerificationNextLivenessMessage.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات هویتی و پستی در پیش‌نویس ثبت شد. مرحله بعد، احراز هویت ویدیویی و تأیید محل فروشگاه روی نقشه خواهد بود.'**
  String get partnerVerificationNextLivenessMessage;

  /// No description provided for @partnerRegistrationFinalConfirm.
  ///
  /// In fa, this message translates to:
  /// **'تأیید'**
  String get partnerRegistrationFinalConfirm;

  /// No description provided for @partnerLivenessTitle.
  ///
  /// In fa, this message translates to:
  /// **'احراز هویت ویدیویی'**
  String get partnerLivenessTitle;

  /// No description provided for @partnerLivenessSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'پس از پذیرش رضایت‌نامه، دوربین جلو فعال می‌شود. متن نمایش‌داده‌شده را واضح بخوانید.'**
  String get partnerLivenessSubtitle;

  /// No description provided for @partnerLivenessPhraseTitle.
  ///
  /// In fa, this message translates to:
  /// **'متن اعتبارسنجی'**
  String get partnerLivenessPhraseTitle;

  /// No description provided for @partnerLivenessConsent.
  ///
  /// In fa, this message translates to:
  /// **'با ضبط و پردازش ویدئو برای احراز هویت صاحب کسب‌وکار موافقم.'**
  String get partnerLivenessConsent;

  /// No description provided for @partnerLivenessConsentRequired.
  ///
  /// In fa, this message translates to:
  /// **'برای فعال‌شدن دوربین، پذیرش رضایت‌نامه ویدیویی الزامی است.'**
  String get partnerLivenessConsentRequired;

  /// No description provided for @partnerLivenessCameraUnavailable.
  ///
  /// In fa, this message translates to:
  /// **'دوربین جلو در دسترس نیست یا مجوز دوربین و میکروفن صادر نشده است.'**
  String get partnerLivenessCameraUnavailable;

  /// No description provided for @partnerLivenessRecordInstruction.
  ///
  /// In fa, this message translates to:
  /// **'برای شروع ضبط، دکمه دوربین را بزنید و متن را واضح بخوانید.'**
  String get partnerLivenessRecordInstruction;

  /// No description provided for @partnerLivenessRecordingInstruction.
  ///
  /// In fa, this message translates to:
  /// **'در حال ضبط است؛ متن نمایش‌داده‌شده را واضح و کامل بخوانید.'**
  String get partnerLivenessRecordingInstruction;

  /// No description provided for @partnerLivenessStartRecording.
  ///
  /// In fa, this message translates to:
  /// **'شروع ضبط ویدئو'**
  String get partnerLivenessStartRecording;

  /// No description provided for @partnerLivenessStopRecording.
  ///
  /// In fa, this message translates to:
  /// **'پایان ضبط ویدئو'**
  String get partnerLivenessStopRecording;

  /// No description provided for @partnerLivenessRecordingFailed.
  ///
  /// In fa, this message translates to:
  /// **'ضبط ویدئو انجام نشد. دوباره تلاش کنید.'**
  String get partnerLivenessRecordingFailed;

  /// No description provided for @partnerLivenessPreviewTitle.
  ///
  /// In fa, this message translates to:
  /// **'پیش‌نمایش ویدئو'**
  String get partnerLivenessPreviewTitle;

  /// No description provided for @partnerLivenessRetake.
  ///
  /// In fa, this message translates to:
  /// **'ضبط مجدد'**
  String get partnerLivenessRetake;

  /// No description provided for @partnerLivenessVerificationFailed.
  ///
  /// In fa, this message translates to:
  /// **'احراز هویت ویدیویی تأیید نشد. ویدئو را دوباره ضبط کنید.'**
  String get partnerLivenessVerificationFailed;

  /// No description provided for @partnerMapConfirmationRequired.
  ///
  /// In fa, this message translates to:
  /// **'ابتدا موقعیت فروشگاه را روی نقشه تأیید کنید.'**
  String get partnerMapConfirmationRequired;

  /// No description provided for @partnerMapConfirmed.
  ///
  /// In fa, this message translates to:
  /// **'موقعیت فروشگاه تأیید شد'**
  String get partnerMapConfirmed;

  /// No description provided for @partnerMapOpen.
  ///
  /// In fa, this message translates to:
  /// **'تأیید موقعیت روی نقشه'**
  String get partnerMapOpen;

  /// No description provided for @partnerMapConfirmInstruction.
  ///
  /// In fa, this message translates to:
  /// **'برای ثبت موقعیت، دکمه فلش را بزنید.'**
  String get partnerMapConfirmInstruction;

  /// No description provided for @partnerMapHint.
  ///
  /// In fa, this message translates to:
  /// **'پین ثابت است؛ نقشه را زیر آن جابه‌جا کنید.'**
  String get partnerMapHint;

  /// No description provided for @partnerMapTitle.
  ///
  /// In fa, this message translates to:
  /// **'تأیید موقعیت فروشگاه'**
  String get partnerMapTitle;

  /// No description provided for @partnerMapSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'نقشه را حرکت دهید تا پین دقیقاً روی محل فروشگاه قرار گیرد.'**
  String get partnerMapSubtitle;

  /// No description provided for @partnerMapCoordinatesUnavailable.
  ///
  /// In fa, this message translates to:
  /// **'مختصات اولیه برای نمایش نقشه در دسترس نیست.'**
  String get partnerMapCoordinatesUnavailable;

  /// No description provided for @partnerRegistrationImageSourceGallery.
  ///
  /// In fa, this message translates to:
  /// **'گالری'**
  String get partnerRegistrationImageSourceGallery;

  /// No description provided for @partnerRegistrationImageSourceCamera.
  ///
  /// In fa, this message translates to:
  /// **'دوربین'**
  String get partnerRegistrationImageSourceCamera;

  /// No description provided for @partnerRegistrationImageSourceTitle.
  ///
  /// In fa, this message translates to:
  /// **'روش افزودن تصویر را انتخاب کنید'**
  String get partnerRegistrationImageSourceTitle;

  /// No description provided for @partnerIdentityResultPageTitle.
  ///
  /// In fa, this message translates to:
  /// **'نتیجه استعلام هویت'**
  String get partnerIdentityResultPageTitle;

  /// No description provided for @partnerIdentityResultMatchedSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات هویتی دریافت شد و مالکیت شماره همراه با کد ملی تطابق دارد.'**
  String get partnerIdentityResultMatchedSubtitle;

  /// No description provided for @partnerIdentityResultMismatchSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'شماره همراه با کد ملی تطابق ندارد. اطلاعات را ویرایش و دوباره استعلام کنید.'**
  String get partnerIdentityResultMismatchSubtitle;

  /// No description provided for @partnerIdentityEditInformation.
  ///
  /// In fa, this message translates to:
  /// **'ویرایش اطلاعات'**
  String get partnerIdentityEditInformation;

  /// No description provided for @partnerIdentityNationalCardImage.
  ///
  /// In fa, this message translates to:
  /// **'تصویر کارت ملی متقاضی'**
  String get partnerIdentityNationalCardImage;

  /// No description provided for @partnerIdentityNationalCardImageRequiredSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'الزامی؛ تصویر باید فقط با دوربین و به‌صورت زنده ثبت شود.'**
  String get partnerIdentityNationalCardImageRequiredSubtitle;

  /// No description provided for @partnerIdentityNationalCardImageValidation.
  ///
  /// In fa, this message translates to:
  /// **'ثبت زنده تصویر کارت ملی متقاضی الزامی است.'**
  String get partnerIdentityNationalCardImageValidation;

  /// No description provided for @partnerIdentityNationalCardCameraTitle.
  ///
  /// In fa, this message translates to:
  /// **'تصویربرداری کارت ملی'**
  String get partnerIdentityNationalCardCameraTitle;

  /// No description provided for @partnerIdentityNationalCardCameraInstruction.
  ///
  /// In fa, this message translates to:
  /// **'کارت ملی را کامل، صاف و خوانا داخل کادر قرار دهید.'**
  String get partnerIdentityNationalCardCameraInstruction;

  /// No description provided for @partnerDocumentCameraUnavailable.
  ///
  /// In fa, this message translates to:
  /// **'دوربین در دسترس نیست یا مجوز دوربین صادر نشده است.'**
  String get partnerDocumentCameraUnavailable;

  /// No description provided for @partnerDocumentCaptureFailed.
  ///
  /// In fa, this message translates to:
  /// **'تصویربرداری انجام نشد. دوباره تلاش کنید.'**
  String get partnerDocumentCaptureFailed;

  /// No description provided for @partnerLivenessProcessingVideo.
  ///
  /// In fa, this message translates to:
  /// **'در حال آماده‌سازی پیش‌نمایش ویدئو...'**
  String get partnerLivenessProcessingVideo;

  /// No description provided for @partnerOwnershipDocumentImage.
  ///
  /// In fa, this message translates to:
  /// **'تصویر سند مالکیت، اجاره‌نامه یا سرقفلی'**
  String get partnerOwnershipDocumentImage;

  /// No description provided for @partnerOwnershipDocumentImageRequired.
  ///
  /// In fa, this message translates to:
  /// **'اجباری؛ برای افزودن تصویر لمس کنید.'**
  String get partnerOwnershipDocumentImageRequired;

  /// No description provided for @partnerOwnershipDocumentImageValidation.
  ///
  /// In fa, this message translates to:
  /// **'تصویر سند مالکیت، اجاره‌نامه یا سرقفلی الزامی است.'**
  String get partnerOwnershipDocumentImageValidation;

  /// No description provided for @partnerSignboardCameraInstruction.
  ///
  /// In fa, this message translates to:
  /// **'تابلوی فروشگاه را کامل و واضح داخل کادر قرار دهید.'**
  String get partnerSignboardCameraInstruction;

  /// No description provided for @partnerLicenseCameraInstruction.
  ///
  /// In fa, this message translates to:
  /// **'مجوز فعالیت را کامل، صاف و خوانا داخل کادر قرار دهید.'**
  String get partnerLicenseCameraInstruction;

  /// No description provided for @partnerOwnershipDocumentCameraInstruction.
  ///
  /// In fa, this message translates to:
  /// **'صفحه اصلی سند مالکیت، اجاره‌نامه یا سرقفلی را کامل و خوانا داخل کادر قرار دهید.'**
  String get partnerOwnershipDocumentCameraInstruction;

  /// No description provided for @partnerApplicationSubmitFinal.
  ///
  /// In fa, this message translates to:
  /// **'ارسال نهایی درخواست'**
  String get partnerApplicationSubmitFinal;

  /// No description provided for @partnerApplicationReviewTitle.
  ///
  /// In fa, this message translates to:
  /// **'مرور نهایی درخواست همکاری'**
  String get partnerApplicationReviewTitle;

  /// No description provided for @partnerApplicationReviewSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'پیش از ارسال، اطلاعات زیر را بررسی کنید. پس از ثبت، شماره پیگیری صادر می‌شود.'**
  String get partnerApplicationReviewSubtitle;

  /// No description provided for @partnerApplicationActivitySection.
  ///
  /// In fa, this message translates to:
  /// **'نوع همکاری'**
  String get partnerApplicationActivitySection;

  /// No description provided for @partnerApplicationCategory.
  ///
  /// In fa, this message translates to:
  /// **'گروه فعالیت'**
  String get partnerApplicationCategory;

  /// No description provided for @partnerApplicationApplicantType.
  ///
  /// In fa, this message translates to:
  /// **'نوع متقاضی'**
  String get partnerApplicationApplicantType;

  /// No description provided for @partnerApplicationIdentitySection.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات هویتی'**
  String get partnerApplicationIdentitySection;

  /// No description provided for @partnerApplicationApplicantName.
  ///
  /// In fa, this message translates to:
  /// **'نام متقاضی'**
  String get partnerApplicationApplicantName;

  /// No description provided for @partnerApplicationStoreSection.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات محل فعالیت'**
  String get partnerApplicationStoreSection;

  /// No description provided for @partnerApplicationMapStatus.
  ///
  /// In fa, this message translates to:
  /// **'وضعیت موقعیت'**
  String get partnerApplicationMapStatus;

  /// No description provided for @partnerApplicationMapConfirmed.
  ///
  /// In fa, this message translates to:
  /// **'موقعیت روی نقشه تأیید شده است'**
  String get partnerApplicationMapConfirmed;

  /// No description provided for @partnerApplicationMapNotConfirmed.
  ///
  /// In fa, this message translates to:
  /// **'موقعیت روی نقشه تأیید نشده است'**
  String get partnerApplicationMapNotConfirmed;

  /// No description provided for @partnerApplicationDocumentsSection.
  ///
  /// In fa, this message translates to:
  /// **'احراز و مدارک'**
  String get partnerApplicationDocumentsSection;

  /// No description provided for @partnerApplicationVerified.
  ///
  /// In fa, this message translates to:
  /// **'تأیید شده'**
  String get partnerApplicationVerified;

  /// No description provided for @partnerApplicationSubmissionNotice.
  ///
  /// In fa, this message translates to:
  /// **'با ارسال درخواست، اطلاعات برای بررسی واحد همکاری آدرس ثبت می‌شود.'**
  String get partnerApplicationSubmissionNotice;

  /// No description provided for @partnerApplicationSuccessTitle.
  ///
  /// In fa, this message translates to:
  /// **'درخواست همکاری ثبت شد'**
  String get partnerApplicationSuccessTitle;

  /// No description provided for @partnerApplicationSuccessMessage.
  ///
  /// In fa, this message translates to:
  /// **'درخواست شما با موفقیت ثبت شد. برای پیگیری، شماره زیر را نگهداری کنید.'**
  String get partnerApplicationSuccessMessage;

  /// No description provided for @partnerApplicationAlreadySubmittedMessage.
  ///
  /// In fa, this message translates to:
  /// **'این درخواست قبلاً ثبت شده بود و همان شماره پیگیری بازیابی شد.'**
  String get partnerApplicationAlreadySubmittedMessage;

  /// No description provided for @partnerApplicationViewMyApplications.
  ///
  /// In fa, this message translates to:
  /// **'درخواست‌های همکاری من'**
  String get partnerApplicationViewMyApplications;

  /// No description provided for @partnerApplicationTrackingCode.
  ///
  /// In fa, this message translates to:
  /// **'شماره پیگیری'**
  String get partnerApplicationTrackingCode;

  /// No description provided for @partnerApplicationCopyTrackingCode.
  ///
  /// In fa, this message translates to:
  /// **'کپی شماره پیگیری'**
  String get partnerApplicationCopyTrackingCode;

  /// No description provided for @partnerApplicationTrackingCodeCopied.
  ///
  /// In fa, this message translates to:
  /// **'شماره پیگیری کپی شد.'**
  String get partnerApplicationTrackingCodeCopied;

  /// No description provided for @partnerApplicationStatusSubmitted.
  ///
  /// In fa, this message translates to:
  /// **'ثبت‌شده'**
  String get partnerApplicationStatusSubmitted;

  /// No description provided for @partnerApplicationStatusUnderReview.
  ///
  /// In fa, this message translates to:
  /// **'در حال بررسی'**
  String get partnerApplicationStatusUnderReview;

  /// No description provided for @partnerApplicationStatusNeedsCorrection.
  ///
  /// In fa, this message translates to:
  /// **'نیازمند اصلاح'**
  String get partnerApplicationStatusNeedsCorrection;

  /// No description provided for @partnerApplicationStatusApproved.
  ///
  /// In fa, this message translates to:
  /// **'تأییدشده'**
  String get partnerApplicationStatusApproved;

  /// No description provided for @partnerApplicationStatusRejected.
  ///
  /// In fa, this message translates to:
  /// **'ردشده'**
  String get partnerApplicationStatusRejected;

  /// No description provided for @partnerApplicationStatusUnknown.
  ///
  /// In fa, this message translates to:
  /// **'نامشخص'**
  String get partnerApplicationStatusUnknown;

  /// No description provided for @partnerApplicationsTitle.
  ///
  /// In fa, this message translates to:
  /// **'درخواست‌های همکاری من'**
  String get partnerApplicationsTitle;

  /// No description provided for @partnerApplicationsSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'وضعیت درخواست‌های ثبت‌شده را مشاهده و پیگیری کنید.'**
  String get partnerApplicationsSubtitle;

  /// No description provided for @partnerApplicationsEmpty.
  ///
  /// In fa, this message translates to:
  /// **'هنوز درخواست همکاری ثبت‌شده‌ای ندارید.'**
  String get partnerApplicationsEmpty;

  /// No description provided for @partnerApplicationRetry.
  ///
  /// In fa, this message translates to:
  /// **'تلاش دوباره'**
  String get partnerApplicationRetry;

  /// No description provided for @partnerApplicationDetailsTitle.
  ///
  /// In fa, this message translates to:
  /// **'جزئیات درخواست همکاری'**
  String get partnerApplicationDetailsTitle;

  /// No description provided for @partnerApplicationCurrentStatus.
  ///
  /// In fa, this message translates to:
  /// **'وضعیت فعلی'**
  String get partnerApplicationCurrentStatus;

  /// No description provided for @partnerApplicationSubmittedAt.
  ///
  /// In fa, this message translates to:
  /// **'زمان ثبت'**
  String get partnerApplicationSubmittedAt;

  /// No description provided for @partnerApplicationStatusHistory.
  ///
  /// In fa, this message translates to:
  /// **'تاریخچه وضعیت'**
  String get partnerApplicationStatusHistory;

  /// No description provided for @partnerApplicationNoStatusHistory.
  ///
  /// In fa, this message translates to:
  /// **'تاریخچه‌ای برای این درخواست ثبت نشده است.'**
  String get partnerApplicationNoStatusHistory;

  /// No description provided for @partnerApplicationFormIncomplete.
  ///
  /// In fa, this message translates to:
  /// **'لطفاً فیلدهای ناقص یا نامعتبر فرم را اصلاح کنید.'**
  String get partnerApplicationFormIncomplete;

  /// No description provided for @partnerApplicationVerificationExpired.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات احراز هویت یا ویدیوی تأیید کامل نیست. فرایند ثبت‌نام را از مرحله احراز هویت دوباره انجام دهید.'**
  String get partnerApplicationVerificationExpired;

  /// No description provided for @partnerApplicationUnexpectedFailure.
  ///
  /// In fa, this message translates to:
  /// **'در ثبت درخواست خطای غیرمنتظره‌ای رخ داد. لطفاً دوباره تلاش کنید.'**
  String get partnerApplicationUnexpectedFailure;

  /// No description provided for @authEntryTitle.
  ///
  /// In fa, this message translates to:
  /// **'ورود یا ثبت‌نام'**
  String get authEntryTitle;

  /// No description provided for @authEntrySubtitle.
  ///
  /// In fa, this message translates to:
  /// **'برای ورود یا ساخت حساب، شماره موبایل خود را وارد کنید'**
  String get authEntrySubtitle;

  /// No description provided for @registrationTitle.
  ///
  /// In fa, this message translates to:
  /// **'تکمیل ثبت‌نام آدرس'**
  String get registrationTitle;

  /// No description provided for @registrationSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات پایه را وارد کنید و مسیر شروع خود را انتخاب کنید.'**
  String get registrationSubtitle;

  /// No description provided for @registrationFirstName.
  ///
  /// In fa, this message translates to:
  /// **'نام'**
  String get registrationFirstName;

  /// No description provided for @registrationLastName.
  ///
  /// In fa, this message translates to:
  /// **'نام خانوادگی'**
  String get registrationLastName;

  /// No description provided for @registrationVerifiedPhone.
  ///
  /// In fa, this message translates to:
  /// **'شماره موبایل تأییدشده'**
  String get registrationVerifiedPhone;

  /// No description provided for @registrationStartQuestion.
  ///
  /// In fa, this message translates to:
  /// **'می‌خواهید چگونه شروع کنید؟'**
  String get registrationStartQuestion;

  /// No description provided for @registrationServicesTitle.
  ///
  /// In fa, this message translates to:
  /// **'استفاده از خدمات آدرس'**
  String get registrationServicesTitle;

  /// No description provided for @registrationServicesSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'تاکسی، خرید، ارسال، رزرو و خدمات شهری'**
  String get registrationServicesSubtitle;

  /// No description provided for @registrationPartnerTitle.
  ///
  /// In fa, this message translates to:
  /// **'همکاری با آدرس'**
  String get registrationPartnerTitle;

  /// No description provided for @registrationPartnerSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'فروشگاه، راننده، تأمین‌کننده و سایر همکاری‌ها'**
  String get registrationPartnerSubtitle;

  /// No description provided for @registrationTermsAcceptance.
  ///
  /// In fa, this message translates to:
  /// **'قوانین استفاده و حریم خصوصی آدرس را می‌پذیرم.'**
  String get registrationTermsAcceptance;

  /// No description provided for @registrationAction.
  ///
  /// In fa, this message translates to:
  /// **'تکمیل ثبت‌نام'**
  String get registrationAction;

  /// No description provided for @registrationChangePhone.
  ///
  /// In fa, this message translates to:
  /// **'تغییر شماره موبایل'**
  String get registrationChangePhone;

  /// No description provided for @registrationTermsRequired.
  ///
  /// In fa, this message translates to:
  /// **'برای ادامه باید قوانین و حریم خصوصی را بپذیرید.'**
  String get registrationTermsRequired;

  /// No description provided for @registrationNameValidation.
  ///
  /// In fa, this message translates to:
  /// **'این فیلد باید حداقل دو نویسه داشته باشد.'**
  String get registrationNameValidation;

  /// No description provided for @registrationSessionExpired.
  ///
  /// In fa, this message translates to:
  /// **'نشست ورود معتبر نیست. دوباره وارد حساب شوید.'**
  String get registrationSessionExpired;

  /// No description provided for @registrationTryAgainLater.
  ///
  /// In fa, this message translates to:
  /// **'لطفاً کمی بعد دوباره تلاش کنید.'**
  String get registrationTryAgainLater;

  /// No description provided for @registrationSubmitFailed.
  ///
  /// In fa, this message translates to:
  /// **'تکمیل ثبت‌نام انجام نشد. دوباره تلاش کنید.'**
  String get registrationSubmitFailed;

  /// No description provided for @partnerApplicationHistorySubmittedByApplicant.
  ///
  /// In fa, this message translates to:
  /// **'درخواست توسط متقاضی ثبت شد.'**
  String get partnerApplicationHistorySubmittedByApplicant;

  /// No description provided for @partnerReusableIdentityBannerTitle.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات هویتی شما قبلاً تأیید شده است'**
  String get partnerReusableIdentityBannerTitle;

  /// No description provided for @partnerReusableIdentityBannerSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'برای این فعالیت جدید، اطلاعات هویتی و احراز زنده قبلی دوباره استفاده می‌شود و فقط اطلاعات اختصاصی فعالیت دریافت خواهد شد.'**
  String get partnerReusableIdentityBannerSubtitle;

  /// No description provided for @profileTitle.
  ///
  /// In fa, this message translates to:
  /// **'پروفایل من'**
  String get profileTitle;

  /// No description provided for @profileSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات حساب و همکاری‌های خود را مدیریت کنید.'**
  String get profileSubtitle;

  /// No description provided for @profilePersonalInfo.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات شخصی'**
  String get profilePersonalInfo;

  /// No description provided for @profileEmailOptional.
  ///
  /// In fa, this message translates to:
  /// **'ایمیل (اختیاری)'**
  String get profileEmailOptional;

  /// No description provided for @profileBirthDateOptional.
  ///
  /// In fa, this message translates to:
  /// **'تاریخ تولد (اختیاری)'**
  String get profileBirthDateOptional;

  /// No description provided for @profileVerifiedPhone.
  ///
  /// In fa, this message translates to:
  /// **'شماره موبایل تأییدشده'**
  String get profileVerifiedPhone;

  /// No description provided for @profileAccountStatus.
  ///
  /// In fa, this message translates to:
  /// **'وضعیت حساب'**
  String get profileAccountStatus;

  /// No description provided for @profileAccountActive.
  ///
  /// In fa, this message translates to:
  /// **'فعال'**
  String get profileAccountActive;

  /// No description provided for @profilePartnerIdentity.
  ///
  /// In fa, this message translates to:
  /// **'هویت همکاری'**
  String get profilePartnerIdentity;

  /// No description provided for @profileIdentityVerified.
  ///
  /// In fa, this message translates to:
  /// **'هویت همکاری تأیید شده است'**
  String get profileIdentityVerified;

  /// No description provided for @profileIdentityNotVerified.
  ///
  /// In fa, this message translates to:
  /// **'هویت همکاری هنوز تأیید نشده است'**
  String get profileIdentityNotVerified;

  /// No description provided for @profileIdentityValidUntil.
  ///
  /// In fa, this message translates to:
  /// **'معتبر تا'**
  String get profileIdentityValidUntil;

  /// No description provided for @profileActivities.
  ///
  /// In fa, this message translates to:
  /// **'فعالیت‌ها و درخواست‌های همکاری'**
  String get profileActivities;

  /// No description provided for @profileNoActivities.
  ///
  /// In fa, this message translates to:
  /// **'هنوز فعالیتی ثبت نشده است.'**
  String get profileNoActivities;

  /// No description provided for @profileAddActivity.
  ///
  /// In fa, this message translates to:
  /// **'افزودن فعالیت جدید'**
  String get profileAddActivity;

  /// No description provided for @profileSave.
  ///
  /// In fa, this message translates to:
  /// **'ذخیره تغییرات'**
  String get profileSave;

  /// No description provided for @profileSaved.
  ///
  /// In fa, this message translates to:
  /// **'پروفایل با موفقیت ذخیره شد.'**
  String get profileSaved;

  /// No description provided for @profileSaveFailed.
  ///
  /// In fa, this message translates to:
  /// **'ذخیره پروفایل انجام نشد.'**
  String get profileSaveFailed;

  /// No description provided for @profileLoadFailed.
  ///
  /// In fa, this message translates to:
  /// **'دریافت اطلاعات پروفایل انجام نشد.'**
  String get profileLoadFailed;

  /// No description provided for @profileInvalidEmail.
  ///
  /// In fa, this message translates to:
  /// **'ایمیل واردشده معتبر نیست.'**
  String get profileInvalidEmail;

  /// No description provided for @profileAvatarOptional.
  ///
  /// In fa, this message translates to:
  /// **'عکس پروفایل اختیاری است.'**
  String get profileAvatarOptional;

  /// No description provided for @profileRemoveAvatar.
  ///
  /// In fa, this message translates to:
  /// **'حذف عکس'**
  String get profileRemoveAvatar;

  /// No description provided for @profileAvatarSaved.
  ///
  /// In fa, this message translates to:
  /// **'عکس پروفایل ذخیره شد.'**
  String get profileAvatarSaved;

  /// No description provided for @profileAvatarRemoved.
  ///
  /// In fa, this message translates to:
  /// **'عکس پروفایل حذف شد.'**
  String get profileAvatarRemoved;

  /// No description provided for @profileAvatarUploadFailed.
  ///
  /// In fa, this message translates to:
  /// **'ثبت عکس پروفایل انجام نشد.'**
  String get profileAvatarUploadFailed;

  /// No description provided for @profileImageTooLarge.
  ///
  /// In fa, this message translates to:
  /// **'حجم عکس باید کمتر از ۲ مگابایت باشد.'**
  String get profileImageTooLarge;

  /// No description provided for @profileUnsupportedImage.
  ///
  /// In fa, this message translates to:
  /// **'فرمت عکس باید JPEG، PNG یا WebP باشد.'**
  String get profileUnsupportedImage;

  /// No description provided for @registrationAvatarOptional.
  ///
  /// In fa, this message translates to:
  /// **'عکس پروفایل (اختیاری)'**
  String get registrationAvatarOptional;

  /// No description provided for @registrationAvatarUploadSkipped.
  ///
  /// In fa, this message translates to:
  /// **'ثبت‌نام انجام شد، اما بارگذاری عکس پروفایل انجام نشد. می‌توانید آن را بعداً در پروفایل اضافه کنید.'**
  String get registrationAvatarUploadSkipped;

  /// No description provided for @partnerApplicationRevision.
  ///
  /// In fa, this message translates to:
  /// **'نسخه درخواست'**
  String get partnerApplicationRevision;

  /// No description provided for @partnerApplicationCorrectionTitle.
  ///
  /// In fa, this message translates to:
  /// **'رفع نقص درخواست'**
  String get partnerApplicationCorrectionTitle;

  /// No description provided for @partnerApplicationCorrectionInstructions.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات و مدارک را مطابق نظر کارشناس اصلاح کنید و در پایان، درخواست را دوباره ارسال کنید.'**
  String get partnerApplicationCorrectionInstructions;

  /// No description provided for @partnerApplicationCorrectionNoteTitle.
  ///
  /// In fa, this message translates to:
  /// **'موارد اعلام‌شده برای رفع نقص'**
  String get partnerApplicationCorrectionNoteTitle;

  /// No description provided for @partnerApplicationStartCorrection.
  ///
  /// In fa, this message translates to:
  /// **'اصلاح درخواست'**
  String get partnerApplicationStartCorrection;

  /// No description provided for @partnerApplicationResubmitFinal.
  ///
  /// In fa, this message translates to:
  /// **'ارسال مجدد درخواست'**
  String get partnerApplicationResubmitFinal;

  /// No description provided for @partnerApplicationResubmittedMessage.
  ///
  /// In fa, this message translates to:
  /// **'نسخه اصلاح‌شده درخواست با موفقیت ارسال شد.'**
  String get partnerApplicationResubmittedMessage;

  /// No description provided for @partnerApplicationHistoryResubmittedByApplicant.
  ///
  /// In fa, this message translates to:
  /// **'نسخه اصلاح‌شده درخواست توسط متقاضی ارسال شد.'**
  String get partnerApplicationHistoryResubmittedByApplicant;

  /// No description provided for @partnerSelectiveCorrectionTitle.
  ///
  /// In fa, this message translates to:
  /// **'اصلاح انتخابی درخواست'**
  String get partnerSelectiveCorrectionTitle;

  /// No description provided for @partnerSelectiveCorrectionSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'فقط مواردی که کارشناس برای رفع نقص انتخاب کرده است در این صفحه قابل ویرایش است.'**
  String get partnerSelectiveCorrectionSubtitle;

  /// No description provided for @partnerSelectiveCorrectionSelectedItems.
  ///
  /// In fa, this message translates to:
  /// **'موارد انتخاب‌شده برای رفع نقص'**
  String get partnerSelectiveCorrectionSelectedItems;

  /// No description provided for @partnerSelectiveCorrectionOnlySelected.
  ///
  /// In fa, this message translates to:
  /// **'فقط موارد زیر را اصلاح کنید؛ سایر اطلاعات درخواست بدون تغییر باقی می‌ماند.'**
  String get partnerSelectiveCorrectionOnlySelected;

  /// No description provided for @partnerSelectiveCorrectionItemsUnavailable.
  ///
  /// In fa, this message translates to:
  /// **'فهرست موارد رفع نقص دریافت نشد. صفحه را تازه‌سازی کنید.'**
  String get partnerSelectiveCorrectionItemsUnavailable;

  /// No description provided for @partnerSelectiveCorrectionNewFileRequired.
  ///
  /// In fa, this message translates to:
  /// **'بارگذاری فایل جدید برای این مورد الزامی است.'**
  String get partnerSelectiveCorrectionNewFileRequired;

  /// No description provided for @partnerSelectiveCorrectionOtherNotice.
  ///
  /// In fa, this message translates to:
  /// **'برای گزینه «سایر موارد»، همه بخش‌ها نمایش داده شده‌اند؛ فقط مورد توضیح‌داده‌شده توسط کارشناس را تغییر دهید.'**
  String get partnerSelectiveCorrectionOtherNotice;

  /// No description provided for @partnerSelectiveCorrectionLivenessRequired.
  ///
  /// In fa, this message translates to:
  /// **'ویدئوی احراز زنده جدید هنوز ثبت نشده است.'**
  String get partnerSelectiveCorrectionLivenessRequired;

  /// No description provided for @partnerSelectiveCorrectionLivenessDone.
  ///
  /// In fa, this message translates to:
  /// **'ویدئوی احراز زنده جدید ثبت شد.'**
  String get partnerSelectiveCorrectionLivenessDone;

  /// No description provided for @partnerSelectiveCorrectionLivenessAction.
  ///
  /// In fa, this message translates to:
  /// **'ثبت دوباره ویدئوی احراز زنده'**
  String get partnerSelectiveCorrectionLivenessAction;

  /// No description provided for @partnerSelectiveCorrectionMapRequired.
  ///
  /// In fa, this message translates to:
  /// **'موقعیت جدید روی نقشه هنوز تأیید نشده است.'**
  String get partnerSelectiveCorrectionMapRequired;

  /// No description provided for @partnerSelectiveCorrectionMapDone.
  ///
  /// In fa, this message translates to:
  /// **'موقعیت جدید روی نقشه تأیید شد.'**
  String get partnerSelectiveCorrectionMapDone;

  /// No description provided for @partnerSelectiveCorrectionMapAction.
  ///
  /// In fa, this message translates to:
  /// **'اصلاح موقعیت روی نقشه'**
  String get partnerSelectiveCorrectionMapAction;

  /// No description provided for @partnerSelectiveCorrectionPostalLookupRequired.
  ///
  /// In fa, this message translates to:
  /// **'پس از تغییر کدپستی، استعلام نشانی را انجام دهید.'**
  String get partnerSelectiveCorrectionPostalLookupRequired;

  /// No description provided for @partnerSelectiveCorrectionSelectionRequired.
  ///
  /// In fa, this message translates to:
  /// **'حداقل یک نوع فعالیت را انتخاب کنید.'**
  String get partnerSelectiveCorrectionSelectionRequired;

  /// No description provided for @notificationsTitle.
  ///
  /// In fa, this message translates to:
  /// **'اعلان‌ها'**
  String get notificationsTitle;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'آخرین تغییرات و پیام‌های مهم حساب خود را اینجا مشاهده کنید.'**
  String get notificationsSubtitle;

  /// No description provided for @notificationsBack.
  ///
  /// In fa, this message translates to:
  /// **'بازگشت'**
  String get notificationsBack;

  /// No description provided for @notificationsUnread.
  ///
  /// In fa, this message translates to:
  /// **'خوانده‌نشده'**
  String get notificationsUnread;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In fa, this message translates to:
  /// **'خواندن همه'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsEmpty.
  ///
  /// In fa, this message translates to:
  /// **'اعلانی ندارید'**
  String get notificationsEmpty;

  /// No description provided for @notificationsEmptyDescription.
  ///
  /// In fa, this message translates to:
  /// **'اعلان‌های جدید و تغییرات مهم حساب در این بخش نمایش داده می‌شوند.'**
  String get notificationsEmptyDescription;

  /// No description provided for @notificationsLoadFailed.
  ///
  /// In fa, this message translates to:
  /// **'دریافت اعلان‌ها انجام نشد'**
  String get notificationsLoadFailed;

  /// No description provided for @notificationsLoadFailedDescription.
  ///
  /// In fa, this message translates to:
  /// **'ارتباط با صندوق اعلان برقرار نشد. دوباره تلاش کنید.'**
  String get notificationsLoadFailedDescription;

  /// No description provided for @notificationsRefreshFailed.
  ///
  /// In fa, this message translates to:
  /// **'تازه‌سازی اعلان‌ها انجام نشد؛ اطلاعات قبلی نمایش داده می‌شود.'**
  String get notificationsRefreshFailed;

  /// No description provided for @notificationsReadFailed.
  ///
  /// In fa, this message translates to:
  /// **'ثبت وضعیت خوانده‌شده انجام نشد.'**
  String get notificationsReadFailed;

  /// No description provided for @notificationsMarkAllFailed.
  ///
  /// In fa, this message translates to:
  /// **'خوانده‌شدن همه اعلان‌ها ثبت نشد.'**
  String get notificationsMarkAllFailed;

  /// No description provided for @notificationPartnerReviewStartedTitle.
  ///
  /// In fa, this message translates to:
  /// **'بررسی درخواست آغاز شد'**
  String get notificationPartnerReviewStartedTitle;

  /// No description provided for @notificationPartnerReviewStartedBody.
  ///
  /// In fa, this message translates to:
  /// **'کارشناس بررسی درخواست همکاری شما را آغاز کرده است.'**
  String get notificationPartnerReviewStartedBody;

  /// No description provided for @notificationPartnerNeedsCorrectionTitle.
  ///
  /// In fa, this message translates to:
  /// **'درخواست نیازمند اصلاح است'**
  String get notificationPartnerNeedsCorrectionTitle;

  /// No description provided for @notificationPartnerNeedsCorrectionBody.
  ///
  /// In fa, this message translates to:
  /// **'موارد اعلام‌شده را در جزئیات درخواست مشاهده و اصلاح کنید.'**
  String get notificationPartnerNeedsCorrectionBody;

  /// No description provided for @notificationPartnerApprovedTitle.
  ///
  /// In fa, this message translates to:
  /// **'درخواست همکاری تأیید شد'**
  String get notificationPartnerApprovedTitle;

  /// No description provided for @notificationPartnerApprovedBody.
  ///
  /// In fa, this message translates to:
  /// **'درخواست همکاری شما با موفقیت تأیید شده است.'**
  String get notificationPartnerApprovedBody;

  /// No description provided for @notificationPartnerRejectedTitle.
  ///
  /// In fa, this message translates to:
  /// **'درخواست همکاری رد شد'**
  String get notificationPartnerRejectedTitle;

  /// No description provided for @notificationPartnerRejectedBody.
  ///
  /// In fa, this message translates to:
  /// **'دلیل رد را در جزئیات درخواست همکاری مشاهده کنید.'**
  String get notificationPartnerRejectedBody;

  /// No description provided for @partnerApplicationRejectionReasonTitle.
  ///
  /// In fa, this message translates to:
  /// **'دلیل رد نهایی درخواست'**
  String get partnerApplicationRejectionReasonTitle;

  /// No description provided for @partnerApplicationRejectionReasonFallback.
  ///
  /// In fa, this message translates to:
  /// **'دلیل رد در حال حاضر قابل نمایش نیست. صفحه را تازه‌سازی کنید.'**
  String get partnerApplicationRejectionReasonFallback;

  /// No description provided for @notificationUnknownTitle.
  ///
  /// In fa, this message translates to:
  /// **'اعلان جدید'**
  String get notificationUnknownTitle;

  /// No description provided for @notificationUnknownBody.
  ///
  /// In fa, this message translates to:
  /// **'یک تغییر جدید در حساب شما ثبت شده است.'**
  String get notificationUnknownBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fa', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
