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
  /// **'کد ۵ رقمی را کامل وارد کنید'**
  String get enterFullOtpCode;

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
  /// **'بیمه'**
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
