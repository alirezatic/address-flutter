// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'سوپر اپ';

  @override
  String get home => 'خانه';

  @override
  String get phoneNumber => 'شماره موبایل';

  @override
  String get continueLabel => 'ادامه';

  @override
  String get retry => 'تلاش مجدد';

  @override
  String get unknownError => 'خطای ناشناختهای رخ داد';

  @override
  String get getStarted => 'شروع';

  @override
  String get changeLanguage => 'تغییر زبان';

  @override
  String get onboardingSubtitle =>
      'رفتوآمد خرید توزیع و خدمات روزمره را سادهتر تجربه کنید.';

  @override
  String get onboardingTitle => 'همه خدمات شهر در یک آدرس';

  @override
  String get login => 'ورود';

  @override
  String get welcome => 'خوش آمدید';

  @override
  String get enteryourmobilenumber => 'شماره موبایل خود را وارد کنید';

  @override
  String get mobileNumber => 'شماره موبایل';

  @override
  String get enterMobileError => 'لطفاً شماره موبایل خود را وارد کنید';

  @override
  String get notDigits => 'شماره موبایل باید فقط شامل اعداد باشد';

  @override
  String get invalidPrefix => 'شماره موبایل باید با «09» یا «9» شروع شود';

  @override
  String get enterMobileErrorWithZero =>
      'شماره موبایل باید ۱۱ رقم باشد (با صفر در ابتدای آن)';

  @override
  String get enterMobileErrorWithoutZero =>
      'شماره موبایل باید ۱۰ رقم باشد (بدون صفر در ابتدای آن)';

  @override
  String get tooShort => 'شماره واردشده خیلی کوتاه است';

  @override
  String get networkError => 'خطای شبکه، لطفاً اتصال خود را بررسی کنید';

  @override
  String enterOtpCode(Object phoneNumber) {
    return 'کد پنج‌رقمی ارسال‌شده به $phoneNumber را وارد کنید';
  }

  @override
  String didNotReceiveCode(Object seconds) {
    return 'کد را دریافت نکردم (۰۰:$seconds)';
  }

  @override
  String get resendCode => 'ارسال مجدد کد';

  @override
  String get changeNumber => 'تغییر شماره';

  @override
  String get or => 'یا';

  @override
  String get email => 'ایمیل';

  @override
  String get enterFullOtpCode => 'لطفاً کد ۵ رقمی را کامل وارد کنید';

  @override
  String get invalidOtpCode => 'کد تأیید واردشده نادرست است';

  @override
  String get expiredOtpCode => 'کد تأیید منقضی شده است؛ کد جدید دریافت کنید';

  @override
  String get otpRequestTooSoon => 'لطفاً برای دریافت دوباره کد کمی صبر کنید';

  @override
  String get language => 'زبان';

  @override
  String get logOut => 'خروج از حساب';

  @override
  String get services => 'خدمات';

  @override
  String get activity => 'فعالیت‌ها';

  @override
  String get messages => 'پیام‌ها';

  @override
  String get settings => 'تنظیمات';

  @override
  String get sendGift => 'ارسال هدیه';

  @override
  String get businessHub => 'مرکز کسب‌وکار';

  @override
  String get manageAddressAccount => 'مدیریت حساب آدرس';

  @override
  String get ride => 'سفر';

  @override
  String get deliver => 'تحویل';

  @override
  String get airport => 'فرودگاه';

  @override
  String get bike => 'موتور';

  @override
  String get safeYourTrip => 'سفر ایمن';

  @override
  String get anywhereCityTrip => 'هرکجا در شهر';

  @override
  String get cityOrIntercityTrip => 'سفر شهری یا بین‌شهری';

  @override
  String get fastAndSafe => 'سریع و ایمن';

  @override
  String get passengerServices => ' سفر';

  @override
  String get cargoServices => 'بارو کالا';

  @override
  String get foodServices => 'غذاوفروشگاه';

  @override
  String get generalServices => ' عمومی';

  @override
  String get repairServices => 'تعمیر و قطعات یدکی';

  @override
  String get insuranceServices => 'بیمه';

  @override
  String get comingSoon => 'این بخش به‌زودی فعال می‌شود.';

  @override
  String get logoutConfirmTitle => 'خروج از حساب';

  @override
  String get logoutConfirmMessage => 'آیا می‌خواهید از حساب کاربری خارج شوید؟';

  @override
  String get cancel => 'انصراف';

  @override
  String get confirm => 'خروج';

  @override
  String get addressUser => 'کاربر آدرس';
}
