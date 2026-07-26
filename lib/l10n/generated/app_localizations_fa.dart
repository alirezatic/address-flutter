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
  String get foodServices => 'غذا و\nفروشگاه';

  @override
  String get generalServices => ' عمومی';

  @override
  String get repairServices => 'تعمیر و\nقطعات یدکی';

  @override
  String get insuranceServices => 'همکاران آدرس';

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

  @override
  String get distributionOrders => 'سفارش‌های توزیع';

  @override
  String get distributionOrderDetails => 'جزئیات سفارش';

  @override
  String get allOrders => 'همه';

  @override
  String get confirmedOrders => 'تأییدشده';

  @override
  String get receivedOrders => 'دریافت‌شده';

  @override
  String get filterByState => 'فیلتر وضعیت';

  @override
  String get clearFilters => 'پاک‌کردن فیلترها';

  @override
  String get noDistributionOrders => 'سفارشی پیدا نشد';

  @override
  String get noDistributionOrdersDescription =>
      'در حال حاضر سفارشی با این فیلتر وجود ندارد.';

  @override
  String get distributionLoading => 'در حال دریافت سفارش‌ها...';

  @override
  String get distributionLoadError => 'دریافت سفارش‌ها ممکن نشد';

  @override
  String get distributionNetworkError =>
      'ارتباط با سرور برقرار نشد. اتصال شبکه را بررسی کنید.';

  @override
  String get distributionServerError => 'سرویس توزیع موقتاً در دسترس نیست.';

  @override
  String get distributionInvalidResponse =>
      'پاسخ سرویس توزیع قابل پردازش نیست.';

  @override
  String get distributionOrderNotFound => 'سفارش موردنظر پیدا نشد.';

  @override
  String get orderNumber => 'شماره سفارش';

  @override
  String get orderStatus => 'وضعیت سفارش';

  @override
  String get walletStatus => 'وضعیت کیف پول';

  @override
  String get deliveryStatus => 'وضعیت تحویل';

  @override
  String get totalAmount => 'مبلغ کل';

  @override
  String get plannedDelivery => 'تحویل برنامه‌ریزی‌شده';

  @override
  String get createdDate => 'تاریخ ایجاد';

  @override
  String get deliveryDriver => 'راننده تحویل';

  @override
  String get deliveryTrip => 'سفر تحویل';

  @override
  String get deliveryConfirmed => 'تأیید تحویل';

  @override
  String get deliveryProof => 'مدرک تحویل';

  @override
  String get orderProducts => 'اقلام سفارش';

  @override
  String get quantity => 'تعداد';

  @override
  String get unitPrice => 'قیمت واحد';

  @override
  String get finalUnitPrice => 'قیمت نهایی';

  @override
  String get walletReservedAmount => 'مبلغ رزروشده';

  @override
  String get walletCapturedAmount => 'مبلغ پرداخت‌شده';

  @override
  String get notAvailable => 'ثبت نشده';

  @override
  String get viewDetails => 'مشاهده جزئیات';

  @override
  String get stateDraft => 'پیش‌نویس';

  @override
  String get stateConfirmed => 'تأییدشده';

  @override
  String get stateReceived => 'دریافت‌شده';

  @override
  String get stateCancelled => 'لغوشده';

  @override
  String get walletPaid => 'پرداخت‌شده';

  @override
  String get walletReserved => 'رزروشده';

  @override
  String get walletUnpaid => 'پرداخت‌نشده';

  @override
  String get walletRefunded => 'بازپرداخت‌شده';

  @override
  String get deliveryDelivered => 'تحویل‌شده';

  @override
  String get deliveryNone => 'بدون ارسال';

  @override
  String get deliveryPending => 'در انتظار';

  @override
  String get deliveryAssigned => 'اختصاص‌یافته';

  @override
  String get deliveryInTransit => 'در مسیر';

  @override
  String get adminShopAccess => 'مدیریت دسترسی فروشگاه';

  @override
  String get manageShopAccess => 'ثبت یا لغو دسترسی فروشگاه';

  @override
  String get adminShopAccessPrivacyNote =>
      'شماره کامل فقط برای اجرای همین درخواست استفاده می‌شود و در فهرست به‌صورت ماسک‌شده نمایش داده می‌شود.';

  @override
  String get shopId => 'شناسه فروشگاه';

  @override
  String get optionalShopId => 'شناسه فروشگاه (اختیاری)';

  @override
  String get invalidShopId => 'یک شناسه فروشگاه معتبر و مثبت وارد کنید';

  @override
  String get invalidAdminMobile => 'یک شماره موبایل معتبر ایران وارد کنید';

  @override
  String get grantAccess => 'ثبت دسترسی';

  @override
  String get revokeAccess => 'لغو دسترسی';

  @override
  String get adminAccessGranted => 'دسترسی ثبت شد';

  @override
  String get adminAccessRevoked => 'دسترسی لغو شد';

  @override
  String get accessListFilters => 'فیلترهای فهرست دسترسی';

  @override
  String get applyFilters => 'اعمال';

  @override
  String get includeInactiveAccess => 'نمایش دسترسی‌های غیرفعال';

  @override
  String get activeAccess => 'فعال';

  @override
  String get inactiveAccess => 'غیرفعال';

  @override
  String get adminAccessLoading => 'در حال دریافت دسترسی‌های فروشگاه...';

  @override
  String get noAdminShopAccess => 'دسترسی‌ای پیدا نشد';

  @override
  String get noAdminShopAccessDescription =>
      'هیچ نگاشت دسترسی با فیلترهای انتخاب‌شده وجود ندارد.';

  @override
  String get adminAccessForbiddenTitle => 'دسترسی مدیر لازم است';

  @override
  String get adminAccessForbiddenMessage =>
      'این حساب اجازه مدیریت دسترسی فروشگاه‌ها را ندارد.';

  @override
  String get adminAccessLoadError => 'دریافت دسترسی‌ها ممکن نشد';

  @override
  String get adminAccessUnauthorized =>
      'نشست شما معتبر نیست. دوباره وارد حساب شوید.';

  @override
  String get adminAccessValidationError =>
      'شماره موبایل یا شناسه فروشگاه معتبر نیست.';

  @override
  String get adminAccessNetworkError =>
      'ارتباط با سرور برقرار نشد. اتصال شبکه را بررسی کنید.';

  @override
  String get adminAccessServerError =>
      'سرویس مدیریت دسترسی موقتاً در دسترس نیست.';

  @override
  String get adminAccessInvalidResponse =>
      'پاسخ سرویس مدیریت دسترسی قابل پردازش نیست.';

  @override
  String get shopIdVerificationNote =>
      'شناسه فروشگاه را از Odoo تأیید کنید؛ Gateway عمداً مجوز گسترده مشاهده فهرست فروشگاه‌ها را ندارد.';

  @override
  String get partnerShop => 'فروشگاه و سوپرمارکت';

  @override
  String get addressPartnersIntro =>
      'نوع همکاری خود را انتخاب کنید. ثبت‌نام، بررسی مدارک و فعال‌سازی پنل اختصاصی در مراحل بعد انجام می‌شود.';

  @override
  String get partnerDistributor => 'شرکت پخش';

  @override
  String get partnerCarDriver => 'راننده خودرو';

  @override
  String get partnerFoodBusiness => 'رستوران، فست‌فود و کترینگ';

  @override
  String get partnerMotorcycleDriver => 'راننده موتور';

  @override
  String get companyPharmaMedical => 'محصولات دارویی و تجهیزات پزشکی';

  @override
  String get storeBeautyHealth => 'فروشگاه آرایشی و بهداشتی';

  @override
  String get foodBakeryDessert => 'نان، شیرینی و دسر';

  @override
  String get storeBakeryPastry => 'نانوایی و شیرینی‌فروشی';

  @override
  String get foodCatering => 'کترینگ و تهیه غذا';

  @override
  String get otherHomeBuilding => 'خدمات منزل و ساختمان';

  @override
  String get driverVan => 'ون';

  @override
  String get partnerCategoryDriver => 'راننده';

  @override
  String get driverPickup => 'وانت';

  @override
  String get otherTechnicalRepair => 'خدمات فنی و تعمیرات';

  @override
  String get driverTractorTrailer => 'کشنده و تریلر';

  @override
  String get companyBeautyHealth => 'محصولات آرایشی و بهداشتی';

  @override
  String get foodIranian => 'رستوران ایرانی';

  @override
  String get partnerCategoryOther => 'سایر';

  @override
  String get driverLightTruck => 'کامیونت';

  @override
  String get driverMotorcycle => 'موتورسیکلت';

  @override
  String get storeDairy => 'فروشگاه لبنیات';

  @override
  String get companyMotorcycleParts => 'قطعات یدکی موتورسیکلت';

  @override
  String get companyHeavyVehicleParts => 'قطعات یدکی خودروهای سنگین';

  @override
  String get otherHospitality => 'هتل، اقامتگاه و خدمات گردشگری';

  @override
  String get partnersFormNextStage =>
      'در مرحله بعد فرم ثبت‌نام این گروه ساخته می‌شود.';

  @override
  String get companyCleaning => 'شوینده‌ها و پاک‌کننده‌ها';

  @override
  String get storeProtein => 'فروشگاه پروتئینی و فرآورده‌های پروتئینی';

  @override
  String get foodFastFood => 'فست‌فود';

  @override
  String get partnerCategoryCompany => 'شرکت';

  @override
  String get partnersChooseSubcategory => 'زمینه فعالیت';

  @override
  String get foodCafe => 'کافه و کافی‌شاپ';

  @override
  String get driverPassengerCar => 'خودروی سواری';

  @override
  String get storeFruitVegetable => 'میوه و سبزی‌فروشی';

  @override
  String get partnersChooseCategory => 'نوع همکاری را انتخاب کنید';

  @override
  String get partnersContinue => 'ادامه';

  @override
  String get companyRetailEquipment => 'تجهیزات و ملزومات فروشگاهی';

  @override
  String get otherEvents => 'تشریفات و خدمات مجالس';

  @override
  String get otherLaundry => 'خشکشویی و خدمات شست‌وشو';

  @override
  String get driverBus => 'اتوبوس';

  @override
  String get storeSupermarket => 'سوپرمارکت';

  @override
  String get storeGrocery => 'خواربارفروشی';

  @override
  String get otherBeautyWellness => 'خدمات زیبایی و سلامت';

  @override
  String get companyPackagingDisposable => 'محصولات بسته‌بندی و یک‌بارمصرف';

  @override
  String get driverTruck => 'کامیون';

  @override
  String get companyLightVehicleParts => 'قطعات یدکی خودروهای سبک';

  @override
  String get companyFoodBeverage => 'محصولات غذایی و نوشیدنی';

  @override
  String get partnersSingleSelection => 'انتخاب یک گزینه';

  @override
  String get partnerCategoryStore => 'فروشگاه';

  @override
  String get foodHealthyDiet => 'غذای سالم و رژیمی';

  @override
  String get partnerCategoryFood => 'غذا';

  @override
  String get otherBusiness => 'سایر کسب‌وکارها';

  @override
  String get driverMinibus => 'مینی‌بوس';

  @override
  String get foodInternational => 'رستوران بین‌المللی';

  @override
  String get partnersMultipleSelection => 'انتخاب چندگانه';

  @override
  String get foodSeafood => 'رستوران دریایی';

  @override
  String get partnersStartOver => 'شروع دوباره';

  @override
  String get partnersSelected => 'انتخاب شد';

  @override
  String get partnersSecondaryActivities => 'فعالیت‌های جانبی';

  @override
  String get partnersQuestionTitle => 'کسب‌وکار شما در کدام دسته است؟';

  @override
  String get storeSupermarketDescription => 'کالای متنوع روزمره';

  @override
  String get partnersSelect => 'انتخاب';

  @override
  String get partnersSummaryReadyTitle => 'پروفایل کسب‌وکار آماده شد!';

  @override
  String get storeDairyDescription => 'شیر و فرآورده‌های لبنی';

  @override
  String get partnersMainCategory => 'دسته اصلی';

  @override
  String get partnerGroupOtherSubtitle => 'خدمات تخصصی و رفاهی';

  @override
  String get partnerGroupCompaniesSubtitle => 'تأمین و پخش عمده کالا';

  @override
  String get partnersRegistrationNext =>
      'فرم ثبت‌نام و ارسال درخواست در مرحله بعد متصل می‌شود.';

  @override
  String get partnerGroupFoodSubtitle => 'رستوران، کافه و تهیه غذا';

  @override
  String get foodCateringDescription => 'پذیرایی و سفارش';

  @override
  String get storeBakeryPastryDescription => 'نان و شیرینی';

  @override
  String get partnerGroupCompanies => 'شرکت‌ها و تأمین‌کنندگان';

  @override
  String get foodInternationalDescription => 'غذاهای بین‌المللی';

  @override
  String get partnersBrandSubtitle => 'ثبت‌نام و انتخاب دسته کسب‌وکار';

  @override
  String get partnerGroupDrivers => 'رانندگان و ناوگان';

  @override
  String get partnersPrimaryBadge => 'اصلی';

  @override
  String partnersSubcategoryCount(int count) {
    return '$count زیرمجموعه';
  }

  @override
  String get partnersNothingSelected => 'هنوز انتخابی نشده';

  @override
  String get partnersCompleteRegistration => 'تکمیل فرم ثبت‌نام';

  @override
  String get partnersPrimaryActivity => 'فعالیت اصلی';

  @override
  String get partnersPrimarySummaryBadge => 'اصلی';

  @override
  String get partnerGroupStores => 'فروشگاه‌ها';

  @override
  String get storeFruitVegetableDescription => 'میوه و سبزیجات تازه';

  @override
  String get partnersStepConfirm => 'تأیید نهایی';

  @override
  String get partnerGroupDriversSubtitle => 'حمل‌ونقل و لجستیک';

  @override
  String partnersSelectionCount(int count) {
    return '$count مورد انتخاب شد';
  }

  @override
  String get partnersDriverCompany => 'شرکت حمل‌ونقل';

  @override
  String get storeBeautyHealthDescription => 'لوازم آرایشی و بهداشتی';

  @override
  String get partnersVersionLabel => 'نسخه ۱.۰';

  @override
  String get partnersViewSummary => 'مشاهده خلاصه';

  @override
  String get foodBakeryDessertDescription => 'دسر و شیرینی';

  @override
  String get foodSeafoodDescription => 'غذاهای دریایی';

  @override
  String get partnersHintDriverPersonal =>
      'به‌عنوان راننده شخصی، یک وسیله اصلی انتخاب کنید.';

  @override
  String get partnersOneItem => '(یک مورد)';

  @override
  String get partnersSelectedOptions => 'گزینه‌های انتخابی';

  @override
  String get partnersSummaryReadySubtitle => 'خلاصه انتخاب‌های شما در آدرس';

  @override
  String get partnersDriverPersonal => 'راننده شخصی';

  @override
  String get storeGroceryDescription => 'خواروبار و مواد اولیه';

  @override
  String get foodCafeDescription => 'قهوه و نوشیدنی';

  @override
  String get partnersHintMultiple =>
      'می‌توانید چند گزینه را هم‌زمان انتخاب کنید.';

  @override
  String get foodIranianDescription => 'غذاهای اصیل ایرانی';

  @override
  String get foodFastFoodDescription => 'غذای سریع';

  @override
  String get partnersQuestionSubtitle =>
      'یکی از پنج گروه اصلی را انتخاب کنید تا زیرمجموعه‌های مرتبط نمایش داده شوند.';

  @override
  String get partnersMainVehicle => 'وسیله اصلی';

  @override
  String get partnerGroupOther => 'سایر خدمات';

  @override
  String get partnersStepDetails => 'جزئیات فعالیت';

  @override
  String get foodHealthyDietDescription => 'غذای رژیمی و سالم';

  @override
  String get partnerGroupStoresSubtitle => 'فروش مستقیم کالا به مشتریان';

  @override
  String get partnersStepCategory => 'دسته اصلی';

  @override
  String get partnersHintDriverCompany =>
      'به‌عنوان شرکت حمل‌ونقل، می‌توانید چند نوع وسیله ثبت کنید.';

  @override
  String get partnerGroupFood => 'غذا و پذیرایی';

  @override
  String get storeProteinDescription => 'گوشت و فرآورده‌های پروتئینی';

  @override
  String get partnersHintPrimarySecondary =>
      'یک فعالیت اصلی انتخاب کنید، سپس می‌توانید چند فعالیت جانبی اضافه کنید.';

  @override
  String get partnersBack => 'بازگشت';

  @override
  String get partnersBrandTitle => 'همکاران آدرس';

  @override
  String get partnersFleetTypes => 'انواع ناوگان';

  @override
  String get partnersSupport => 'پشتیبانی';

  @override
  String get partnersSupportSubtitle => 'همیشه در کنار شما';

  @override
  String get partnerRegistrationStart => 'شروع ثبت‌نام';

  @override
  String get partnerRegistrationContinue => 'ادامه';

  @override
  String get partnerRegistrationApplicantTypeTitle =>
      'نوع متقاضی را انتخاب کنید';

  @override
  String get partnerRegistrationApplicantTypeSubtitle =>
      'مشخص کنید درخواست به نام شخص یا شرکت ثبت می‌شود.';

  @override
  String get partnerRegistrationIndividual => 'شخص حقیقی';

  @override
  String get partnerRegistrationIndividualDescription =>
      'ثبت درخواست به نام یک فرد';

  @override
  String get partnerRegistrationLegalEntity => 'شرکت یا کسب‌وکار حقوقی';

  @override
  String get partnerRegistrationLegalEntityDescription =>
      'ثبت درخواست با اطلاعات رسمی شرکت';

  @override
  String get partnerRegistrationBasicInfoTitle => 'اطلاعات پایه';

  @override
  String get partnerRegistrationBasicInfoSubtitle =>
      'اطلاعات هویتی و راه ارتباطی متقاضی را وارد کنید.';

  @override
  String get partnerRegistrationFullName => 'نام و نام خانوادگی';

  @override
  String get partnerRegistrationCompanyName => 'نام رسمی شرکت یا کسب‌وکار';

  @override
  String get partnerRegistrationRepresentativeName => 'نام نماینده مسئول';

  @override
  String get partnerRegistrationNationalId => 'کد ملی';

  @override
  String get partnerRegistrationCompanyNationalId => 'شناسه ملی شرکت';

  @override
  String get partnerRegistrationMobile => 'شماره تلفن همراه';

  @override
  String get partnerRegistrationEmailOptional => 'ایمیل (اختیاری)';

  @override
  String get partnerRegistrationRequiredField => 'تکمیل این فیلد الزامی است';

  @override
  String get partnerRegistrationInvalidMobile => 'شماره تلفن همراه معتبر نیست';

  @override
  String get partnerRegistrationBasicInfoSaved =>
      'اطلاعات پایه ذخیره شد؛ مرحله اطلاعات کسب‌وکار بعدی است.';

  @override
  String get partnerRegistrationBusinessInfoTitle => 'اطلاعات کسب‌وکار';

  @override
  String get partnerRegistrationBusinessInfoSubtitle =>
      'نام فعالیت، توضیح خدمات و سابقه کاری را ثبت کنید.';

  @override
  String get partnerRegistrationBusinessName => 'نام تجاری یا نام فعالیت';

  @override
  String get partnerRegistrationBusinessDescription =>
      'توضیح کوتاه درباره محصولات یا خدمات';

  @override
  String get partnerRegistrationExperienceYears =>
      'سابقه فعالیت به سال (اختیاری)';

  @override
  String get partnerRegistrationSaveBusinessInfo => 'ذخیره اطلاعات';

  @override
  String get partnerRegistrationBusinessInfoSaved =>
      'اطلاعات کسب‌وکار در پیش‌نویس ذخیره شد.';

  @override
  String get partnerRegistrationIndividualFormTitle => 'فرم ثبت‌نام شخص حقیقی';

  @override
  String get partnerRegistrationLegalFormTitle => 'فرم ثبت‌نام شخص حقوقی';

  @override
  String get partnerRegistrationFormSubtitle =>
      'اطلاعات هویتی و اطلاعات فعالیت را در همین فرم وارد کنید.';

  @override
  String get partnerRegistrationSubmitApplication => 'ثبت درخواست';

  @override
  String get partnerRegistrationDraftSaved =>
      'اطلاعات فرم با موفقیت در پیش‌نویس ثبت شد.';

  @override
  String get partnerRegistrationPersonalInformationTitle => 'اطلاعات فردی';

  @override
  String get partnerRegistrationCompanyInformationTitle => 'اطلاعات شرکت';

  @override
  String get partnerRegistrationPersonalInformationSubtitle =>
      'اطلاعات هویتی و راه‌های تماس را وارد کنید.';

  @override
  String get partnerRegistrationRepresentativeNationalId =>
      'کد ملی نماینده شرکت';

  @override
  String get partnerRegistrationCompanyLandline => 'تلفن ثابت شرکت';

  @override
  String get partnerRegistrationLandlineOptional => 'تلفن ثابت (اختیاری)';

  @override
  String get partnerRegistrationInvalidNationalId => 'کد ملی باید ۱۰ رقم باشد.';

  @override
  String get partnerRegistrationInvalidCompanyNationalId =>
      'شناسه ملی شرکت باید ۱۱ رقم باشد.';

  @override
  String get partnerRegistrationInvalidIranianMobile =>
      'شماره همراه باید با ۰۹ شروع شود و ۱۱ رقم باشد.';

  @override
  String get partnerRegistrationInvalidLandline =>
      'تلفن ثابت را همراه کد شهر و در ۱۱ رقم وارد کنید.';

  @override
  String get partnerRegistrationContinueToStore => 'ادامه و اطلاعات فروشگاه';

  @override
  String get partnerRegistrationStoreInformationTitle => 'اطلاعات فروشگاه';

  @override
  String get partnerRegistrationStoreInformationSubtitle =>
      'مشخصات محل فعالیت و تصاویر موردنیاز را ثبت کنید.';

  @override
  String get partnerRegistrationStoreName => 'نام فروشگاه';

  @override
  String get partnerRegistrationStoreOwnership => 'نوع مالکیت فروشگاه';

  @override
  String get partnerRegistrationOwnershipOwner => 'مالک';

  @override
  String get partnerRegistrationOwnershipTenant => 'مستأجر';

  @override
  String get partnerRegistrationOwnershipGoodwill => 'سرقفلی';

  @override
  String get partnerRegistrationOwnershipOther => 'سایر';

  @override
  String get partnerRegistrationStorePhone => 'تلفن ثابت فروشگاه';

  @override
  String get partnerRegistrationPostalCode => 'کد پستی';

  @override
  String get partnerRegistrationStoreArea => 'متراژ فروشگاه (مترمربع)';

  @override
  String get partnerRegistrationStoreAddress => 'نشانی کامل فروشگاه';

  @override
  String get partnerRegistrationBusinessDescriptionOptional =>
      'توضیح کوتاه درباره فعالیت (اختیاری)';

  @override
  String get partnerRegistrationLicenseImage => 'تصویر مجوز فعالیت';

  @override
  String get partnerRegistrationLicenseImageOptional =>
      'اختیاری؛ برای انتخاب تصویر لمس کنید.';

  @override
  String get partnerRegistrationSignboardImage => 'تصویر تابلوی فروشگاه';

  @override
  String get partnerRegistrationSignboardImageRequired =>
      'اجباری؛ برای انتخاب تصویر لمس کنید.';

  @override
  String get partnerRegistrationSignboardImageValidation =>
      'تصویر تابلوی فروشگاه الزامی است.';

  @override
  String get partnerRegistrationInvalidPostalCode =>
      'کد پستی باید ۱۰ رقم باشد.';

  @override
  String get partnerRegistrationInvalidStoreArea =>
      'متراژ فروشگاه باید عددی بیشتر از صفر باشد.';

  @override
  String get partnerRegistrationDraftCompletedTitle => 'اطلاعات ثبت شد';

  @override
  String get partnerRegistrationDraftCompletedMessage =>
      'اطلاعات در پیش‌نویس نگهداری شد. اتصال ارسال نهایی به سرور در مرحله بعد انجام می‌شود.';

  @override
  String get partnerRegistrationDialogConfirm => 'متوجه شدم';

  @override
  String get partnerVerificationOwnerTitle => 'احراز هویت صاحب کسب‌وکار';

  @override
  String get partnerVerificationLegalOwnerTitle => 'احراز هویت نماینده شرکت';

  @override
  String get partnerVerificationOwnerSubtitle =>
      'کد ملی و شماره همراهی را وارد کنید که به نام صاحب کسب‌وکار یا نماینده شرکت است.';

  @override
  String get partnerVerificationOwnerMobile => 'شماره همراه صاحب کسب‌وکار';

  @override
  String get partnerVerificationConsent =>
      'با استعلام و پردازش اطلاعات هویتی برای ثبت درخواست همکاری موافقم.';

  @override
  String get partnerVerificationConsentRequired =>
      'برای انجام استعلام، پذیرش رضایت‌نامه الزامی است.';

  @override
  String get partnerVerificationLookupIdentity => 'استعلام اطلاعات هویتی';

  @override
  String get partnerVerificationIdentityResultTitle => 'اطلاعات دریافت‌شده';

  @override
  String get partnerVerificationMobileMatched =>
      'مالکیت شماره همراه با کد ملی تطبیق دارد.';

  @override
  String get partnerVerificationMobileMismatch =>
      'شماره همراه واردشده متعلق به این کد ملی نیست.';

  @override
  String get partnerVerificationFatherName => 'نام پدر';

  @override
  String get partnerVerificationBirthDate => 'تاریخ تولد';

  @override
  String get partnerVerificationConfirmAccuracy =>
      'اطلاعات نمایش‌داده‌شده صحیح است و آن را تأیید می‌کنم.';

  @override
  String get partnerVerificationAccuracyRequired =>
      'ابتدا صحت اطلاعات نمایش‌داده‌شده را تأیید کنید.';

  @override
  String get partnerVerificationConfirmAndContinue => 'تأیید و ادامه';

  @override
  String get partnerVerificationPostalLookup => 'دریافت نشانی از کد پستی';

  @override
  String get partnerVerificationPostalResultTitle => 'نشانی دریافت‌شده';

  @override
  String get partnerVerificationMapConfirmationPending =>
      'در مرحله بعد، محل دقیق فروشگاه روی نقشه تأیید خواهد شد.';

  @override
  String get partnerVerificationPostalLookupRequired =>
      'ابتدا نشانی را از طریق کد پستی استعلام کنید.';

  @override
  String get partnerVerificationNextLivenessMessage =>
      'اطلاعات هویتی و پستی در پیش‌نویس ثبت شد. مرحله بعد، احراز هویت ویدیویی و تأیید محل فروشگاه روی نقشه خواهد بود.';

  @override
  String get partnerRegistrationFinalConfirm => 'تأیید';

  @override
  String get partnerLivenessTitle => 'احراز هویت ویدیویی';

  @override
  String get partnerLivenessSubtitle =>
      'پس از پذیرش رضایت‌نامه، دوربین جلو فعال می‌شود. متن نمایش‌داده‌شده را واضح بخوانید.';

  @override
  String get partnerLivenessPhraseTitle => 'متن اعتبارسنجی';

  @override
  String get partnerLivenessConsent =>
      'با ضبط و پردازش ویدئو برای احراز هویت صاحب کسب‌وکار موافقم.';

  @override
  String get partnerLivenessConsentRequired =>
      'برای فعال‌شدن دوربین، پذیرش رضایت‌نامه ویدیویی الزامی است.';

  @override
  String get partnerLivenessCameraUnavailable =>
      'دوربین جلو در دسترس نیست یا مجوز دوربین و میکروفن صادر نشده است.';

  @override
  String get partnerLivenessRecordInstruction =>
      'برای شروع ضبط، دکمه دوربین را بزنید و متن را واضح بخوانید.';

  @override
  String get partnerLivenessRecordingInstruction =>
      'در حال ضبط است؛ متن نمایش‌داده‌شده را واضح و کامل بخوانید.';

  @override
  String get partnerLivenessStartRecording => 'شروع ضبط ویدئو';

  @override
  String get partnerLivenessStopRecording => 'پایان ضبط ویدئو';

  @override
  String get partnerLivenessRecordingFailed =>
      'ضبط ویدئو انجام نشد. دوباره تلاش کنید.';

  @override
  String get partnerLivenessPreviewTitle => 'پیش‌نمایش ویدئو';

  @override
  String get partnerLivenessRetake => 'ضبط مجدد';

  @override
  String get partnerLivenessVerificationFailed =>
      'احراز هویت ویدیویی تأیید نشد. ویدئو را دوباره ضبط کنید.';

  @override
  String get partnerMapConfirmationRequired =>
      'ابتدا موقعیت فروشگاه را روی نقشه تأیید کنید.';

  @override
  String get partnerMapConfirmed => 'موقعیت فروشگاه تأیید شد';

  @override
  String get partnerMapOpen => 'تأیید موقعیت روی نقشه';

  @override
  String get partnerMapConfirmInstruction =>
      'برای ثبت موقعیت، دکمه فلش را بزنید.';

  @override
  String get partnerMapHint => 'پین ثابت است؛ نقشه را زیر آن جابه‌جا کنید.';

  @override
  String get partnerMapTitle => 'تأیید موقعیت فروشگاه';

  @override
  String get partnerMapSubtitle =>
      'نقشه را حرکت دهید تا پین دقیقاً روی محل فروشگاه قرار گیرد.';

  @override
  String get partnerMapCoordinatesUnavailable =>
      'مختصات اولیه برای نمایش نقشه در دسترس نیست.';

  @override
  String get partnerRegistrationImageSourceGallery => 'گالری';

  @override
  String get partnerRegistrationImageSourceCamera => 'دوربین';

  @override
  String get partnerRegistrationImageSourceTitle =>
      'روش افزودن تصویر را انتخاب کنید';

  @override
  String get partnerIdentityResultPageTitle => 'نتیجه استعلام هویت';

  @override
  String get partnerIdentityResultMatchedSubtitle =>
      'اطلاعات هویتی دریافت شد و مالکیت شماره همراه با کد ملی تطابق دارد.';

  @override
  String get partnerIdentityResultMismatchSubtitle =>
      'شماره همراه با کد ملی تطابق ندارد. اطلاعات را ویرایش و دوباره استعلام کنید.';

  @override
  String get partnerIdentityEditInformation => 'ویرایش اطلاعات';

  @override
  String get partnerIdentityNationalCardImage => 'تصویر کارت ملی متقاضی';

  @override
  String get partnerIdentityNationalCardImageRequiredSubtitle =>
      'الزامی؛ تصویر باید فقط با دوربین و به‌صورت زنده ثبت شود.';

  @override
  String get partnerIdentityNationalCardImageValidation =>
      'ثبت زنده تصویر کارت ملی متقاضی الزامی است.';

  @override
  String get partnerIdentityNationalCardCameraTitle => 'تصویربرداری کارت ملی';

  @override
  String get partnerIdentityNationalCardCameraInstruction =>
      'کارت ملی را کامل، صاف و خوانا داخل کادر قرار دهید.';

  @override
  String get partnerDocumentCameraUnavailable =>
      'دوربین در دسترس نیست یا مجوز دوربین صادر نشده است.';

  @override
  String get partnerDocumentCaptureFailed =>
      'تصویربرداری انجام نشد. دوباره تلاش کنید.';

  @override
  String get partnerLivenessProcessingVideo =>
      'در حال آماده‌سازی پیش‌نمایش ویدئو...';

  @override
  String get partnerOwnershipDocumentImage =>
      'تصویر سند مالکیت، اجاره‌نامه یا سرقفلی';

  @override
  String get partnerOwnershipDocumentImageRequired =>
      'اجباری؛ برای افزودن تصویر لمس کنید.';

  @override
  String get partnerOwnershipDocumentImageValidation =>
      'تصویر سند مالکیت، اجاره‌نامه یا سرقفلی الزامی است.';

  @override
  String get partnerSignboardCameraInstruction =>
      'تابلوی فروشگاه را کامل و واضح داخل کادر قرار دهید.';

  @override
  String get partnerLicenseCameraInstruction =>
      'مجوز فعالیت را کامل، صاف و خوانا داخل کادر قرار دهید.';

  @override
  String get partnerOwnershipDocumentCameraInstruction =>
      'صفحه اصلی سند مالکیت، اجاره‌نامه یا سرقفلی را کامل و خوانا داخل کادر قرار دهید.';

  @override
  String get partnerApplicationSubmitFinal => 'ارسال نهایی درخواست';

  @override
  String get partnerApplicationReviewTitle => 'مرور نهایی درخواست همکاری';

  @override
  String get partnerApplicationReviewSubtitle =>
      'پیش از ارسال، اطلاعات زیر را بررسی کنید. پس از ثبت، شماره پیگیری صادر می‌شود.';

  @override
  String get partnerApplicationActivitySection => 'نوع همکاری';

  @override
  String get partnerApplicationCategory => 'گروه فعالیت';

  @override
  String get partnerApplicationApplicantType => 'نوع متقاضی';

  @override
  String get partnerApplicationIdentitySection => 'اطلاعات هویتی';

  @override
  String get partnerApplicationApplicantName => 'نام متقاضی';

  @override
  String get partnerApplicationStoreSection => 'اطلاعات محل فعالیت';

  @override
  String get partnerApplicationMapStatus => 'وضعیت موقعیت';

  @override
  String get partnerApplicationMapConfirmed => 'موقعیت روی نقشه تأیید شده است';

  @override
  String get partnerApplicationMapNotConfirmed =>
      'موقعیت روی نقشه تأیید نشده است';

  @override
  String get partnerApplicationDocumentsSection => 'احراز و مدارک';

  @override
  String get partnerApplicationVerified => 'تأیید شده';

  @override
  String get partnerApplicationSubmissionNotice =>
      'با ارسال درخواست، اطلاعات برای بررسی واحد همکاری آدرس ثبت می‌شود.';

  @override
  String get partnerApplicationSuccessTitle => 'درخواست همکاری ثبت شد';

  @override
  String get partnerApplicationSuccessMessage =>
      'درخواست شما با موفقیت ثبت شد. برای پیگیری، شماره زیر را نگهداری کنید.';

  @override
  String get partnerApplicationAlreadySubmittedMessage =>
      'این درخواست قبلاً ثبت شده بود و همان شماره پیگیری بازیابی شد.';

  @override
  String get partnerApplicationViewMyApplications => 'درخواست‌های همکاری من';

  @override
  String get partnerApplicationTrackingCode => 'شماره پیگیری';

  @override
  String get partnerApplicationCopyTrackingCode => 'کپی شماره پیگیری';

  @override
  String get partnerApplicationTrackingCodeCopied => 'شماره پیگیری کپی شد.';

  @override
  String get partnerApplicationStatusSubmitted => 'ثبت‌شده';

  @override
  String get partnerApplicationStatusUnderReview => 'در حال بررسی';

  @override
  String get partnerApplicationStatusNeedsCorrection => 'نیازمند اصلاح';

  @override
  String get partnerApplicationStatusApproved => 'تأییدشده';

  @override
  String get partnerApplicationStatusRejected => 'ردشده';

  @override
  String get partnerApplicationStatusUnknown => 'نامشخص';

  @override
  String get partnerApplicationsTitle => 'درخواست‌های همکاری من';

  @override
  String get partnerApplicationsSubtitle =>
      'وضعیت درخواست‌های ثبت‌شده را مشاهده و پیگیری کنید.';

  @override
  String get partnerApplicationsEmpty =>
      'هنوز درخواست همکاری ثبت‌شده‌ای ندارید.';

  @override
  String get partnerApplicationRetry => 'تلاش دوباره';

  @override
  String get partnerApplicationDetailsTitle => 'جزئیات درخواست همکاری';

  @override
  String get partnerApplicationCurrentStatus => 'وضعیت فعلی';

  @override
  String get partnerApplicationSubmittedAt => 'زمان ثبت';

  @override
  String get partnerApplicationStatusHistory => 'تاریخچه وضعیت';

  @override
  String get partnerApplicationNoStatusHistory =>
      'تاریخچه‌ای برای این درخواست ثبت نشده است.';

  @override
  String get partnerApplicationFormIncomplete =>
      'لطفاً فیلدهای ناقص یا نامعتبر فرم را اصلاح کنید.';

  @override
  String get partnerApplicationVerificationExpired =>
      'اطلاعات احراز هویت یا ویدیوی تأیید کامل نیست. فرایند ثبت‌نام را از مرحله احراز هویت دوباره انجام دهید.';

  @override
  String get partnerApplicationUnexpectedFailure =>
      'در ثبت درخواست خطای غیرمنتظره‌ای رخ داد. لطفاً دوباره تلاش کنید.';

  @override
  String get authEntryTitle => 'ورود یا ثبت‌نام';

  @override
  String get authEntrySubtitle =>
      'برای ورود یا ساخت حساب، شماره موبایل خود را وارد کنید';

  @override
  String get registrationTitle => 'تکمیل ثبت‌نام آدرس';

  @override
  String get registrationSubtitle =>
      'اطلاعات پایه را وارد کنید و مسیر شروع خود را انتخاب کنید.';

  @override
  String get registrationFirstName => 'نام';

  @override
  String get registrationLastName => 'نام خانوادگی';

  @override
  String get registrationVerifiedPhone => 'شماره موبایل تأییدشده';

  @override
  String get registrationStartQuestion => 'می‌خواهید چگونه شروع کنید؟';

  @override
  String get registrationServicesTitle => 'استفاده از خدمات آدرس';

  @override
  String get registrationServicesSubtitle =>
      'تاکسی، خرید، ارسال، رزرو و خدمات شهری';

  @override
  String get registrationPartnerTitle => 'همکاری با آدرس';

  @override
  String get registrationPartnerSubtitle =>
      'فروشگاه، راننده، تأمین‌کننده و سایر همکاری‌ها';

  @override
  String get registrationTermsAcceptance =>
      'قوانین استفاده و حریم خصوصی آدرس را می‌پذیرم.';

  @override
  String get registrationAction => 'تکمیل ثبت‌نام';

  @override
  String get registrationChangePhone => 'تغییر شماره موبایل';

  @override
  String get registrationTermsRequired =>
      'برای ادامه باید قوانین و حریم خصوصی را بپذیرید.';

  @override
  String get registrationNameValidation =>
      'این فیلد باید حداقل دو نویسه داشته باشد.';

  @override
  String get registrationSessionExpired =>
      'نشست ورود معتبر نیست. دوباره وارد حساب شوید.';

  @override
  String get registrationTryAgainLater => 'لطفاً کمی بعد دوباره تلاش کنید.';

  @override
  String get registrationSubmitFailed =>
      'تکمیل ثبت‌نام انجام نشد. دوباره تلاش کنید.';

  @override
  String get partnerApplicationHistorySubmittedByApplicant =>
      'درخواست توسط متقاضی ثبت شد.';

  @override
  String get partnerReusableIdentityBannerTitle =>
      'اطلاعات هویتی شما قبلاً تأیید شده است';

  @override
  String get partnerReusableIdentityBannerSubtitle =>
      'برای این فعالیت جدید، اطلاعات هویتی و احراز زنده قبلی دوباره استفاده می‌شود و فقط اطلاعات اختصاصی فعالیت دریافت خواهد شد.';

  @override
  String get profileTitle => 'پروفایل من';

  @override
  String get profileSubtitle => 'اطلاعات حساب و همکاری‌های خود را مدیریت کنید.';

  @override
  String get profilePersonalInfo => 'اطلاعات شخصی';

  @override
  String get profileEmailOptional => 'ایمیل (اختیاری)';

  @override
  String get profileBirthDateOptional => 'تاریخ تولد (اختیاری)';

  @override
  String get profileVerifiedPhone => 'شماره موبایل تأییدشده';

  @override
  String get profileAccountStatus => 'وضعیت حساب';

  @override
  String get profileAccountActive => 'فعال';

  @override
  String get profilePartnerIdentity => 'هویت همکاری';

  @override
  String get profileIdentityVerified => 'هویت همکاری تأیید شده است';

  @override
  String get profileIdentityNotVerified => 'هویت همکاری هنوز تأیید نشده است';

  @override
  String get profileIdentityValidUntil => 'معتبر تا';

  @override
  String get profileActivities => 'فعالیت‌ها و درخواست‌های همکاری';

  @override
  String get profileNoActivities => 'هنوز فعالیتی ثبت نشده است.';

  @override
  String get profileAddActivity => 'افزودن فعالیت جدید';

  @override
  String get profileSave => 'ذخیره تغییرات';

  @override
  String get profileSaved => 'پروفایل با موفقیت ذخیره شد.';

  @override
  String get profileSaveFailed => 'ذخیره پروفایل انجام نشد.';

  @override
  String get profileLoadFailed => 'دریافت اطلاعات پروفایل انجام نشد.';

  @override
  String get profileInvalidEmail => 'ایمیل واردشده معتبر نیست.';

  @override
  String get profileAvatarOptional => 'عکس پروفایل اختیاری است.';

  @override
  String get profileRemoveAvatar => 'حذف عکس';

  @override
  String get profileAvatarSaved => 'عکس پروفایل ذخیره شد.';

  @override
  String get profileAvatarRemoved => 'عکس پروفایل حذف شد.';

  @override
  String get profileAvatarUploadFailed => 'ثبت عکس پروفایل انجام نشد.';

  @override
  String get profileImageTooLarge => 'حجم عکس باید کمتر از ۲ مگابایت باشد.';

  @override
  String get profileUnsupportedImage => 'فرمت عکس باید JPEG، PNG یا WebP باشد.';

  @override
  String get registrationAvatarOptional => 'عکس پروفایل (اختیاری)';

  @override
  String get registrationAvatarUploadSkipped =>
      'ثبت‌نام انجام شد، اما بارگذاری عکس پروفایل انجام نشد. می‌توانید آن را بعداً در پروفایل اضافه کنید.';

  @override
  String get partnerApplicationRevision => 'نسخه درخواست';

  @override
  String get partnerApplicationCorrectionTitle => 'رفع نقص درخواست';

  @override
  String get partnerApplicationCorrectionInstructions =>
      'اطلاعات و مدارک را مطابق نظر کارشناس اصلاح کنید و در پایان، درخواست را دوباره ارسال کنید.';

  @override
  String get partnerApplicationCorrectionNoteTitle =>
      'موارد اعلام‌شده برای رفع نقص';

  @override
  String get partnerApplicationStartCorrection => 'اصلاح درخواست';

  @override
  String get partnerApplicationResubmitFinal => 'ارسال مجدد درخواست';

  @override
  String get partnerApplicationResubmittedMessage =>
      'نسخه اصلاح‌شده درخواست با موفقیت ارسال شد.';

  @override
  String get partnerApplicationHistoryResubmittedByApplicant =>
      'نسخه اصلاح‌شده درخواست توسط متقاضی ارسال شد.';

  @override
  String get partnerSelectiveCorrectionTitle => 'اصلاح انتخابی درخواست';

  @override
  String get partnerSelectiveCorrectionSubtitle =>
      'فقط مواردی که کارشناس برای رفع نقص انتخاب کرده است در این صفحه قابل ویرایش است.';

  @override
  String get partnerSelectiveCorrectionSelectedItems =>
      'موارد انتخاب‌شده برای رفع نقص';

  @override
  String get partnerSelectiveCorrectionOnlySelected =>
      'فقط موارد زیر را اصلاح کنید؛ سایر اطلاعات درخواست بدون تغییر باقی می‌ماند.';

  @override
  String get partnerSelectiveCorrectionItemsUnavailable =>
      'فهرست موارد رفع نقص دریافت نشد. صفحه را تازه‌سازی کنید.';

  @override
  String get partnerSelectiveCorrectionNewFileRequired =>
      'بارگذاری فایل جدید برای این مورد الزامی است.';

  @override
  String get partnerSelectiveCorrectionOtherNotice =>
      'برای گزینه «سایر موارد»، همه بخش‌ها نمایش داده شده‌اند؛ فقط مورد توضیح‌داده‌شده توسط کارشناس را تغییر دهید.';

  @override
  String get partnerSelectiveCorrectionLivenessRequired =>
      'ویدئوی احراز زنده جدید هنوز ثبت نشده است.';

  @override
  String get partnerSelectiveCorrectionLivenessDone =>
      'ویدئوی احراز زنده جدید ثبت شد.';

  @override
  String get partnerSelectiveCorrectionLivenessAction =>
      'ثبت دوباره ویدئوی احراز زنده';

  @override
  String get partnerSelectiveCorrectionMapRequired =>
      'موقعیت جدید روی نقشه هنوز تأیید نشده است.';

  @override
  String get partnerSelectiveCorrectionMapDone =>
      'موقعیت جدید روی نقشه تأیید شد.';

  @override
  String get partnerSelectiveCorrectionMapAction => 'اصلاح موقعیت روی نقشه';

  @override
  String get partnerSelectiveCorrectionPostalLookupRequired =>
      'پس از تغییر کدپستی، استعلام نشانی را انجام دهید.';

  @override
  String get partnerSelectiveCorrectionSelectionRequired =>
      'حداقل یک نوع فعالیت را انتخاب کنید.';

  @override
  String get notificationsTitle => 'اعلان‌ها';

  @override
  String get notificationsSubtitle =>
      'آخرین تغییرات و پیام‌های مهم حساب خود را اینجا مشاهده کنید.';

  @override
  String get notificationsBack => 'بازگشت';

  @override
  String get notificationsUnread => 'خوانده‌نشده';

  @override
  String get notificationsMarkAllRead => 'خواندن همه';

  @override
  String get notificationsEmpty => 'اعلانی ندارید';

  @override
  String get notificationsEmptyDescription =>
      'اعلان‌های جدید و تغییرات مهم حساب در این بخش نمایش داده می‌شوند.';

  @override
  String get notificationsLoadFailed => 'دریافت اعلان‌ها انجام نشد';

  @override
  String get notificationsLoadFailedDescription =>
      'ارتباط با صندوق اعلان برقرار نشد. دوباره تلاش کنید.';

  @override
  String get notificationsRefreshFailed =>
      'تازه‌سازی اعلان‌ها انجام نشد؛ اطلاعات قبلی نمایش داده می‌شود.';

  @override
  String get notificationsReadFailed => 'ثبت وضعیت خوانده‌شده انجام نشد.';

  @override
  String get notificationsMarkAllFailed => 'خوانده‌شدن همه اعلان‌ها ثبت نشد.';

  @override
  String get notificationPartnerReviewStartedTitle => 'بررسی درخواست آغاز شد';

  @override
  String get notificationPartnerReviewStartedBody =>
      'کارشناس بررسی درخواست همکاری شما را آغاز کرده است.';

  @override
  String get notificationPartnerNeedsCorrectionTitle =>
      'درخواست نیازمند اصلاح است';

  @override
  String get notificationPartnerNeedsCorrectionBody =>
      'موارد اعلام‌شده را در جزئیات درخواست مشاهده و اصلاح کنید.';

  @override
  String get notificationPartnerApprovedTitle => 'درخواست همکاری تأیید شد';

  @override
  String get notificationPartnerApprovedBody =>
      'درخواست همکاری شما با موفقیت تأیید شده است.';

  @override
  String get notificationPartnerRejectedTitle => 'درخواست همکاری رد شد';

  @override
  String get notificationPartnerRejectedBody =>
      'دلیل رد را در جزئیات درخواست همکاری مشاهده کنید.';

  @override
  String get partnerApplicationRejectionReasonTitle => 'دلیل رد نهایی درخواست';

  @override
  String get partnerApplicationRejectionReasonFallback =>
      'دلیل رد در حال حاضر قابل نمایش نیست. صفحه را تازه‌سازی کنید.';

  @override
  String get notificationUnknownTitle => 'اعلان جدید';

  @override
  String get notificationUnknownBody =>
      'یک تغییر جدید در حساب شما ثبت شده است.';
}
