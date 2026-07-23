// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'التطبق الشامل';

  @override
  String get home => 'الرئسة';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get continueLabel => 'متابعة';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get unknownError => 'حدث خطأ غر معروف';

  @override
  String get getStarted => 'ابدأ';

  @override
  String get changeLanguage => 'تغر اللغة';

  @override
  String get onboardingSubtitle =>
      'استمتع بالتنقل والتسوق والتوصل والخدمات الومة بسهولة أكبر.';

  @override
  String get onboardingTitle => 'كل خدمات المدنة ف عنوان واحد';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get welcome => 'مرحبًا';

  @override
  String get enteryourmobilenumber => 'أدخل رقم جوالك';

  @override
  String get mobileNumber => 'رقم الجوال';

  @override
  String get enterMobileError => 'يرجى إدخال رقم الجوال';

  @override
  String get notDigits => 'يجب أن يحتوي رقم الجوال على أرقام فقط';

  @override
  String get invalidPrefix => 'يجب أن يبدأ رقم الجوال بـ \'09\' أو \'9\'';

  @override
  String get enterMobileErrorWithZero =>
      'يجب أن يكون رقم الجوال 11 رقمًا (يبدأ بـ 0)';

  @override
  String get enterMobileErrorWithoutZero =>
      'يجب أن يكون رقم الجوال 10 أرقام (بدون 0 في البداية)';

  @override
  String get tooShort => 'رقم الجوال قصير جدًا';

  @override
  String get networkError => 'خطأ في الشبكة، يرجى التحقق من اتصال الإنترنت';

  @override
  String enterOtpCode(Object phoneNumber) {
    return 'أدخل رمز التحقق الخماسي المرسل إلى $phoneNumber';
  }

  @override
  String didNotReceiveCode(Object seconds) {
    return 'لم تستلم رمزًّا (00:$seconds)';
  }

  @override
  String get resendCode => 'إعادة إرسال الرمز';

  @override
  String get changeNumber => 'تغيير الرقم';

  @override
  String get or => 'أو';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get enterFullOtpCode => 'يرجى إدخال الرمز الكامل المكوّن من 5 أرقام';

  @override
  String get invalidOtpCode => 'رمز التحقق غير صحيح';

  @override
  String get expiredOtpCode => 'انتهت صلاحية رمز التحقق. اطلب رمزًا جديدًا';

  @override
  String get otpRequestTooSoon => 'يرجى الانتظار قبل طلب رمز آخر';

  @override
  String get language => 'اللغة';

  @override
  String get logOut => 'تسجيل الخروج';

  @override
  String get services => 'الخدمات';

  @override
  String get activity => 'النشاطات';

  @override
  String get messages => 'الرسائل';

  @override
  String get settings => 'الإعدادات';

  @override
  String get sendGift => 'إرسال هدية';

  @override
  String get businessHub => 'مركز الأعمال';

  @override
  String get manageAddressAccount => 'إدارة الحساب والعنوان';

  @override
  String get ride => 'الرحلة';

  @override
  String get deliver => 'التوصيل';

  @override
  String get airport => 'المطار';

  @override
  String get bike => 'دراجة نارية';

  @override
  String get safeYourTrip => 'أمّن رحلتك';

  @override
  String get anywhereCityTrip => 'في أي مكان داخل المدينة';

  @override
  String get cityOrIntercityTrip => 'رحلة داخل المدينة أو بين المدن';

  @override
  String get fastAndSafe => 'سريع وآمن';

  @override
  String get passengerServices => 'خدمات الركاب';

  @override
  String get cargoServices => 'خدمات الشحن';

  @override
  String get foodServices => 'خدمات الطعام';

  @override
  String get generalServices => 'الخدمات العامة';

  @override
  String get repairServices => 'خدمات الإصلاح وقطع الغيار';

  @override
  String get insuranceServices => 'خدمات التأمين';

  @override
  String get comingSoon => 'سيتم تفعيل هذا القسم قريبًا.';

  @override
  String get logoutConfirmTitle => 'تسجيل الخروج';

  @override
  String get logoutConfirmMessage => 'هل تريد تسجيل الخروج من حسابك؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تسجيل الخروج';

  @override
  String get addressUser => 'مستخدم عنوان';
}
