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
  String get insuranceServices => 'شركاء آدرس';

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

  @override
  String get distributionOrders => 'طلبات التوزيع';

  @override
  String get distributionOrderDetails => 'تفاصيل الطلب';

  @override
  String get allOrders => 'الكل';

  @override
  String get confirmedOrders => 'مؤكدة';

  @override
  String get receivedOrders => 'مستلمة';

  @override
  String get filterByState => 'تصفية حسب الحالة';

  @override
  String get clearFilters => 'مسح عوامل التصفية';

  @override
  String get noDistributionOrders => 'لم يتم العثور على طلبات';

  @override
  String get noDistributionOrdersDescription =>
      'لا توجد حالياً طلبات مطابقة لهذا التصفية.';

  @override
  String get distributionLoading => 'جارٍ تحميل الطلبات...';

  @override
  String get distributionLoadError => 'تعذر تحميل الطلبات';

  @override
  String get distributionNetworkError =>
      'تعذر الاتصال بالخادم. تحقق من اتصال الشبكة.';

  @override
  String get distributionServerError => 'خدمة التوزيع غير متاحة مؤقتاً.';

  @override
  String get distributionInvalidResponse =>
      'أعادت خدمة التوزيع استجابة غير صالحة.';

  @override
  String get distributionOrderNotFound => 'تعذر العثور على الطلب المطلوب.';

  @override
  String get orderNumber => 'رقم الطلب';

  @override
  String get orderStatus => 'حالة الطلب';

  @override
  String get walletStatus => 'حالة المحفظة';

  @override
  String get deliveryStatus => 'حالة التسليم';

  @override
  String get totalAmount => 'المبلغ الإجمالي';

  @override
  String get plannedDelivery => 'التسليم المخطط';

  @override
  String get createdDate => 'تاريخ الإنشاء';

  @override
  String get deliveryDriver => 'سائق التسليم';

  @override
  String get deliveryTrip => 'رحلة التسليم';

  @override
  String get deliveryConfirmed => 'تأكيد التسليم';

  @override
  String get deliveryProof => 'إثبات التسليم';

  @override
  String get orderProducts => 'عناصر الطلب';

  @override
  String get quantity => 'الكمية';

  @override
  String get unitPrice => 'سعر الوحدة';

  @override
  String get finalUnitPrice => 'السعر النهائي';

  @override
  String get walletReservedAmount => 'المبلغ المحجوز';

  @override
  String get walletCapturedAmount => 'المبلغ المحصل';

  @override
  String get notAvailable => 'غير متوفر';

  @override
  String get viewDetails => 'عرض التفاصيل';

  @override
  String get stateDraft => 'مسودة';

  @override
  String get stateConfirmed => 'مؤكد';

  @override
  String get stateReceived => 'مستلم';

  @override
  String get stateCancelled => 'ملغى';

  @override
  String get walletPaid => 'مدفوع';

  @override
  String get walletReserved => 'محجوز';

  @override
  String get walletUnpaid => 'غير مدفوع';

  @override
  String get walletRefunded => 'مسترد';

  @override
  String get deliveryDelivered => 'تم التسليم';

  @override
  String get deliveryNone => 'بدون تسليم';

  @override
  String get deliveryPending => 'قيد الانتظار';

  @override
  String get deliveryAssigned => 'تم التعيين';

  @override
  String get deliveryInTransit => 'في الطريق';

  @override
  String get adminShopAccess => 'إدارة صلاحيات المتجر';

  @override
  String get manageShopAccess => 'منح أو إلغاء صلاحية المتجر';

  @override
  String get adminShopAccessPrivacyNote =>
      'يُستخدم رقم الهاتف الكامل لهذا الطلب فقط، وتعرض القائمة أرقامًا مخفية.';

  @override
  String get shopId => 'معرّف المتجر';

  @override
  String get optionalShopId => 'معرّف المتجر (اختياري)';

  @override
  String get invalidShopId => 'أدخل معرّف متجر موجبًا وصحيحًا';

  @override
  String get invalidAdminMobile => 'أدخل رقم هاتف إيرانيًا صحيحًا';

  @override
  String get grantAccess => 'منح الصلاحية';

  @override
  String get revokeAccess => 'إلغاء الصلاحية';

  @override
  String get adminAccessGranted => 'تم منح الصلاحية';

  @override
  String get adminAccessRevoked => 'تم إلغاء الصلاحية';

  @override
  String get accessListFilters => 'مرشحات قائمة الصلاحيات';

  @override
  String get applyFilters => 'تطبيق';

  @override
  String get includeInactiveAccess => 'إظهار الصلاحيات غير النشطة';

  @override
  String get activeAccess => 'نشط';

  @override
  String get inactiveAccess => 'غير نشط';

  @override
  String get adminAccessLoading => 'جارٍ تحميل صلاحيات المتجر...';

  @override
  String get noAdminShopAccess => 'لم يتم العثور على صلاحيات';

  @override
  String get noAdminShopAccessDescription =>
      'لا توجد صلاحيات مطابقة للمرشحات المحددة.';

  @override
  String get adminAccessForbiddenTitle => 'صلاحية المدير مطلوبة';

  @override
  String get adminAccessForbiddenMessage =>
      'هذا الحساب غير مخول لإدارة صلاحيات المتاجر.';

  @override
  String get adminAccessLoadError => 'تعذر تحميل الصلاحيات';

  @override
  String get adminAccessUnauthorized =>
      'انتهت صلاحية الجلسة. سجّل الدخول مجددًا.';

  @override
  String get adminAccessValidationError =>
      'رقم الهاتف أو معرّف المتجر غير صالح.';

  @override
  String get adminAccessNetworkError => 'تعذر الاتصال بالخادم. تحقق من الشبكة.';

  @override
  String get adminAccessServerError => 'خدمة إدارة الصلاحيات غير متاحة مؤقتًا.';

  @override
  String get adminAccessInvalidResponse =>
      'تعذر معالجة استجابة إدارة الصلاحيات.';

  @override
  String get shopIdVerificationNote =>
      'استخدم معرّف متجر تم التحقق منه في Odoo؛ فالبوابة لا تملك عمدًا صلاحية واسعة لعرض دليل المتاجر.';

  @override
  String get partnerShop => 'المتجر والسوبرماركت';

  @override
  String get addressPartnersIntro =>
      'اختر نوع الشراكة. ستتم إضافة التسجيل ومراجعة المستندات وتفعيل لوحة العمل المخصصة في المراحل التالية.';

  @override
  String get partnerDistributor => 'شركة التوزيع';

  @override
  String get partnerCarDriver => 'سائق سيارة';

  @override
  String get partnerFoodBusiness => 'مطعم ووجبات سريعة وتموين';

  @override
  String get partnerMotorcycleDriver => 'سائق دراجة نارية';

  @override
  String get companyPharmaMedical => 'الأدوية والمستلزمات الطبية';

  @override
  String get storeBeautyHealth => 'متجر التجميل والصحة';

  @override
  String get foodBakeryDessert => 'خبز وحلويات';

  @override
  String get storeBakeryPastry => 'مخبز وحلويات';

  @override
  String get foodCatering => 'تموين وإعداد الطعام';

  @override
  String get otherHomeBuilding => 'خدمات المنزل والمباني';

  @override
  String get driverVan => 'فان';

  @override
  String get partnerCategoryDriver => 'سائق';

  @override
  String get driverPickup => 'سيارة بيك أب';

  @override
  String get otherTechnicalRepair => 'خدمات فنية وصيانة';

  @override
  String get driverTractorTrailer => 'رأس قاطرة ومقطورة';

  @override
  String get companyBeautyHealth => 'منتجات التجميل والعناية الشخصية';

  @override
  String get foodIranian => 'مطعم إيراني';

  @override
  String get partnerCategoryOther => 'أخرى';

  @override
  String get driverLightTruck => 'شاحنة خفيفة';

  @override
  String get driverMotorcycle => 'دراجة نارية';

  @override
  String get storeDairy => 'متجر ألبان';

  @override
  String get companyMotorcycleParts => 'قطع غيار الدراجات النارية';

  @override
  String get companyHeavyVehicleParts => 'قطع غيار المركبات الثقيلة';

  @override
  String get otherHospitality => 'فنادق وإقامة وسياحة';

  @override
  String get partnersFormNextStage =>
      'سيتم إنشاء نموذج التسجيل لهذه الفئة في المرحلة التالية.';

  @override
  String get companyCleaning => 'المنظفات ومواد التنظيف';

  @override
  String get storeProtein => 'متجر اللحوم والمنتجات البروتينية';

  @override
  String get foodFastFood => 'وجبات سريعة';

  @override
  String get partnerCategoryCompany => 'شركة';

  @override
  String get partnersChooseSubcategory => 'مجال النشاط';

  @override
  String get foodCafe => 'مقهى';

  @override
  String get driverPassengerCar => 'سيارة ركوب';

  @override
  String get storeFruitVegetable => 'متجر الفواكه والخضروات';

  @override
  String get partnersChooseCategory => 'اختر نوع الشراكة';

  @override
  String get partnersContinue => 'متابعة';

  @override
  String get companyRetailEquipment => 'معدات ومستلزمات المتاجر';

  @override
  String get otherEvents => 'خدمات المناسبات والاحتفالات';

  @override
  String get otherLaundry => 'غسيل وكي الملابس';

  @override
  String get driverBus => 'حافلة';

  @override
  String get storeSupermarket => 'سوبرماركت';

  @override
  String get storeGrocery => 'متجر بقالة';

  @override
  String get otherBeautyWellness => 'خدمات الجمال والصحة';

  @override
  String get companyPackagingDisposable =>
      'منتجات التعبئة والتغليف والاستخدام الواحد';

  @override
  String get driverTruck => 'شاحنة';

  @override
  String get companyLightVehicleParts => 'قطع غيار المركبات الخفيفة';

  @override
  String get companyFoodBeverage => 'الأغذية والمشروبات';

  @override
  String get partnersSingleSelection => 'اختر خياراً واحداً';

  @override
  String get partnerCategoryStore => 'متجر';

  @override
  String get foodHealthyDiet => 'طعام صحي وحمية';

  @override
  String get partnerCategoryFood => 'طعام';

  @override
  String get otherBusiness => 'أعمال أخرى';

  @override
  String get driverMinibus => 'حافلة صغيرة';

  @override
  String get foodInternational => 'مطعم عالمي';

  @override
  String get partnersMultipleSelection => 'اختيار متعدد';

  @override
  String get foodSeafood => 'مطعم مأكولات بحرية';

  @override
  String get partnersStartOver => 'البدء من جديد';

  @override
  String get partnersSelected => 'تم الاختيار';

  @override
  String get partnersSecondaryActivities => 'الأنشطة الثانوية';

  @override
  String get partnersQuestionTitle => 'إلى أي فئة ينتمي نشاطك؟';

  @override
  String get storeSupermarketDescription => 'سلع يومية متنوعة';

  @override
  String get partnersSelect => 'اختيار';

  @override
  String get partnersSummaryReadyTitle => 'ملف النشاط جاهز!';

  @override
  String get storeDairyDescription => 'حليب ومنتجات ألبان';

  @override
  String get partnersMainCategory => 'الفئة الرئيسية';

  @override
  String get partnerGroupOtherSubtitle => 'خدمات متخصصة ورفاهية';

  @override
  String get partnerGroupCompaniesSubtitle => 'التوريد والتوزيع بالجملة';

  @override
  String get partnersRegistrationNext =>
      'سيتم ربط نموذج التسجيل وإرسال الطلب في المرحلة التالية.';

  @override
  String get partnerGroupFoodSubtitle => 'مطاعم ومقاهٍ وتجهيز الطعام';

  @override
  String get foodCateringDescription => 'تموين وطلبات جاهزة';

  @override
  String get storeBakeryPastryDescription => 'خبز وحلويات';

  @override
  String get partnerGroupCompanies => 'الشركات والموردون';

  @override
  String get foodInternationalDescription => 'مأكولات عالمية';

  @override
  String get partnersBrandSubtitle => 'تسجيل النشاط واختيار الفئة';

  @override
  String get partnerGroupDrivers => 'السائقون والأسطول';

  @override
  String get partnersPrimaryBadge => 'رئيسي';

  @override
  String partnersSubcategoryCount(int count) {
    return '$count فئات فرعية';
  }

  @override
  String get partnersNothingSelected => 'لم يتم اختيار شيء';

  @override
  String get partnersCompleteRegistration => 'إكمال نموذج التسجيل';

  @override
  String get partnersPrimaryActivity => 'النشاط الرئيسي';

  @override
  String get partnersPrimarySummaryBadge => 'رئيسي';

  @override
  String get partnerGroupStores => 'المتاجر';

  @override
  String get storeFruitVegetableDescription => 'فواكه وخضروات طازجة';

  @override
  String get partnersStepConfirm => 'التأكيد النهائي';

  @override
  String get partnerGroupDriversSubtitle => 'النقل والخدمات اللوجستية';

  @override
  String partnersSelectionCount(int count) {
    return 'تم اختيار $count';
  }

  @override
  String get partnersDriverCompany => 'شركة نقل';

  @override
  String get storeBeautyHealthDescription => 'تجميل وعناية شخصية';

  @override
  String get partnersVersionLabel => 'الإصدار 1.0';

  @override
  String get partnersViewSummary => 'عرض الملخص';

  @override
  String get foodBakeryDessertDescription => 'خبز وحلويات';

  @override
  String get foodSeafoodDescription => 'مأكولات بحرية';

  @override
  String get partnersHintDriverPersonal =>
      'كسائق فردي اختر مركبة رئيسية واحدة.';

  @override
  String get partnersOneItem => '(خيار واحد)';

  @override
  String get partnersSelectedOptions => 'الخيارات المحددة';

  @override
  String get partnersSummaryReadySubtitle => 'ملخص اختياراتك في آدرس';

  @override
  String get partnersDriverPersonal => 'سائق فردي';

  @override
  String get storeGroceryDescription => 'بقالة ومواد أولية';

  @override
  String get foodCafeDescription => 'قهوة ومشروبات';

  @override
  String get partnersHintMultiple => 'يمكنك اختيار عدة خيارات.';

  @override
  String get foodIranianDescription => 'مأكولات إيرانية أصيلة';

  @override
  String get foodFastFoodDescription => 'وجبات سريعة';

  @override
  String get partnersQuestionSubtitle =>
      'اختر إحدى الفئات الخمس لعرض الفئات الفرعية.';

  @override
  String get partnersMainVehicle => 'المركبة الرئيسية';

  @override
  String get partnerGroupOther => 'خدمات أخرى';

  @override
  String get partnersStepDetails => 'تفاصيل النشاط';

  @override
  String get foodHealthyDietDescription => 'وجبات صحية وحمية';

  @override
  String get partnerGroupStoresSubtitle => 'بيع مباشر للعملاء';

  @override
  String get partnersStepCategory => 'الفئة الرئيسية';

  @override
  String get partnersHintDriverCompany =>
      'كشركة نقل يمكنك تسجيل عدة أنواع من المركبات.';

  @override
  String get partnerGroupFood => 'الطعام والضيافة';

  @override
  String get storeProteinDescription => 'لحوم ومنتجات بروتينية';

  @override
  String get partnersHintPrimarySecondary =>
      'اختر نشاطاً رئيسياً ثم أضف الأنشطة الثانوية.';

  @override
  String get partnersBack => 'رجوع';

  @override
  String get partnersBrandTitle => 'شركاء آدرس';

  @override
  String get partnersFleetTypes => 'أنواع الأسطول';

  @override
  String get partnersSupport => 'الدعم';

  @override
  String get partnersSupportSubtitle => 'دائماً إلى جانبك';

  @override
  String get partnerRegistrationStart => 'بدء التسجيل';

  @override
  String get partnerRegistrationContinue => 'متابعة';

  @override
  String get partnerRegistrationApplicantTypeTitle => 'اختر نوع مقدم الطلب';

  @override
  String get partnerRegistrationApplicantTypeSubtitle =>
      'حدد ما إذا كان الطلب باسم فرد أو شركة.';

  @override
  String get partnerRegistrationIndividual => 'فرد';

  @override
  String get partnerRegistrationIndividualDescription => 'تسجيل الطلب باسم شخص';

  @override
  String get partnerRegistrationLegalEntity => 'شركة أو منشأة قانونية';

  @override
  String get partnerRegistrationLegalEntityDescription =>
      'التسجيل باستخدام المعلومات الرسمية للشركة';

  @override
  String get partnerRegistrationBasicInfoTitle => 'المعلومات الأساسية';

  @override
  String get partnerRegistrationBasicInfoSubtitle =>
      'أدخل معلومات الهوية والتواصل لمقدم الطلب.';

  @override
  String get partnerRegistrationFullName => 'الاسم الكامل';

  @override
  String get partnerRegistrationCompanyName => 'الاسم الرسمي للشركة أو النشاط';

  @override
  String get partnerRegistrationRepresentativeName => 'اسم الممثل المسؤول';

  @override
  String get partnerRegistrationNationalId => 'الرقم الوطني';

  @override
  String get partnerRegistrationCompanyNationalId => 'الرقم الوطني للشركة';

  @override
  String get partnerRegistrationMobile => 'رقم الهاتف المحمول';

  @override
  String get partnerRegistrationEmailOptional => 'البريد الإلكتروني (اختياري)';

  @override
  String get partnerRegistrationRequiredField => 'هذا الحقل مطلوب';

  @override
  String get partnerRegistrationInvalidMobile => 'أدخل رقم هاتف محمول صالحاً';

  @override
  String get partnerRegistrationBasicInfoSaved =>
      'تم حفظ المعلومات الأساسية. معلومات النشاط هي الخطوة التالية.';

  @override
  String get partnerRegistrationBusinessInfoTitle => 'معلومات النشاط';

  @override
  String get partnerRegistrationBusinessInfoSubtitle =>
      'أدخل اسم النشاط والخدمات وسنوات الخبرة.';

  @override
  String get partnerRegistrationBusinessName => 'اسم النشاط التجاري';

  @override
  String get partnerRegistrationBusinessDescription =>
      'وصف مختصر للمنتجات أو الخدمات';

  @override
  String get partnerRegistrationExperienceYears => 'سنوات الخبرة (اختياري)';

  @override
  String get partnerRegistrationSaveBusinessInfo => 'حفظ المعلومات';

  @override
  String get partnerRegistrationBusinessInfoSaved =>
      'تم حفظ معلومات النشاط في المسودة.';

  @override
  String get partnerRegistrationIndividualFormTitle => 'نموذج تسجيل فرد';

  @override
  String get partnerRegistrationLegalFormTitle => 'نموذج تسجيل شركة';

  @override
  String get partnerRegistrationFormSubtitle =>
      'أدخل معلومات الهوية والنشاط في هذا النموذج.';

  @override
  String get partnerRegistrationSubmitApplication => 'إرسال الطلب';

  @override
  String get partnerRegistrationDraftSaved => 'تم حفظ النموذج بنجاح كمسودة.';

  @override
  String get partnerRegistrationPersonalInformationTitle => 'المعلومات الشخصية';

  @override
  String get partnerRegistrationCompanyInformationTitle => 'معلومات الشركة';

  @override
  String get partnerRegistrationPersonalInformationSubtitle =>
      'أدخل معلومات الهوية ووسائل الاتصال.';

  @override
  String get partnerRegistrationRepresentativeNationalId =>
      'الرقم الوطني لممثل الشركة';

  @override
  String get partnerRegistrationCompanyLandline => 'هاتف الشركة الثابت';

  @override
  String get partnerRegistrationLandlineOptional => 'الهاتف الثابت (اختياري)';

  @override
  String get partnerRegistrationInvalidNationalId =>
      'يجب أن يتكون الرقم الوطني من 10 أرقام.';

  @override
  String get partnerRegistrationInvalidCompanyNationalId =>
      'يجب أن يتكون معرف الشركة من 11 رقما.';

  @override
  String get partnerRegistrationInvalidIranianMobile =>
      'يجب أن يبدأ رقم الجوال بـ 09 ويتكون من 11 رقما.';

  @override
  String get partnerRegistrationInvalidLandline =>
      'أدخل الهاتف الثابت مع رمز المدينة في 11 رقما.';

  @override
  String get partnerRegistrationContinueToStore => 'متابعة إلى معلومات المتجر';

  @override
  String get partnerRegistrationStoreInformationTitle => 'معلومات المتجر';

  @override
  String get partnerRegistrationStoreInformationSubtitle =>
      'أدخل تفاصيل مكان النشاط والصور المطلوبة.';

  @override
  String get partnerRegistrationStoreName => 'اسم المتجر';

  @override
  String get partnerRegistrationStoreOwnership => 'نوع ملكية المتجر';

  @override
  String get partnerRegistrationOwnershipOwner => 'مالك';

  @override
  String get partnerRegistrationOwnershipTenant => 'مستأجر';

  @override
  String get partnerRegistrationOwnershipGoodwill => 'حق الانتفاع';

  @override
  String get partnerRegistrationOwnershipOther => 'أخرى';

  @override
  String get partnerRegistrationStorePhone => 'هاتف المتجر الثابت';

  @override
  String get partnerRegistrationPostalCode => 'الرمز البريدي';

  @override
  String get partnerRegistrationStoreArea => 'مساحة المتجر بالمتر المربع';

  @override
  String get partnerRegistrationStoreAddress => 'العنوان الكامل للمتجر';

  @override
  String get partnerRegistrationBusinessDescriptionOptional =>
      'وصف مختصر للنشاط (اختياري)';

  @override
  String get partnerRegistrationLicenseImage => 'صورة رخصة النشاط';

  @override
  String get partnerRegistrationLicenseImageOptional =>
      'اختياري؛ اضغط لاختيار صورة.';

  @override
  String get partnerRegistrationSignboardImage => 'صورة لافتة المتجر';

  @override
  String get partnerRegistrationSignboardImageRequired =>
      'مطلوب؛ اضغط لاختيار صورة.';

  @override
  String get partnerRegistrationSignboardImageValidation =>
      'صورة لافتة المتجر مطلوبة.';

  @override
  String get partnerRegistrationInvalidPostalCode =>
      'يجب أن يتكون الرمز البريدي من 10 أرقام.';

  @override
  String get partnerRegistrationInvalidStoreArea =>
      'يجب أن تكون مساحة المتجر أكبر من صفر.';

  @override
  String get partnerRegistrationDraftCompletedTitle => 'تم حفظ المعلومات';

  @override
  String get partnerRegistrationDraftCompletedMessage =>
      'تم حفظ المعلومات كمسودة، وسيتم ربط الإرسال إلى الخادم في المرحلة التالية.';

  @override
  String get partnerRegistrationDialogConfirm => 'حسنا';

  @override
  String get partnerVerificationOwnerTitle => 'التحقق من هوية صاحب النشاط';

  @override
  String get partnerVerificationLegalOwnerTitle => 'التحقق من هوية ممثل الشركة';

  @override
  String get partnerVerificationOwnerSubtitle =>
      'أدخل الرقم الوطني ورقم الجوال المسجل باسم صاحب النشاط أو ممثل الشركة.';

  @override
  String get partnerVerificationOwnerMobile => 'رقم جوال صاحب النشاط';

  @override
  String get partnerVerificationConsent =>
      'أوافق على الاستعلام عن الهوية ومعالجة البيانات لغرض طلب الشراكة.';

  @override
  String get partnerVerificationConsentRequired =>
      'الموافقة مطلوبة قبل الاستعلام عن الهوية.';

  @override
  String get partnerVerificationLookupIdentity => 'الاستعلام عن معلومات الهوية';

  @override
  String get partnerVerificationIdentityResultTitle =>
      'معلومات الهوية المستلمة';

  @override
  String get partnerVerificationMobileMatched =>
      'ملكية رقم الجوال متطابقة مع الرقم الوطني.';

  @override
  String get partnerVerificationMobileMismatch =>
      'رقم الجوال لا يعود إلى هذا الرقم الوطني.';

  @override
  String get partnerVerificationFatherName => 'اسم الأب';

  @override
  String get partnerVerificationBirthDate => 'تاريخ الميلاد';

  @override
  String get partnerVerificationConfirmAccuracy =>
      'أؤكد أن المعلومات المعروضة صحيحة.';

  @override
  String get partnerVerificationAccuracyRequired =>
      'أكد صحة المعلومات المعروضة قبل المتابعة.';

  @override
  String get partnerVerificationConfirmAndContinue => 'تأكيد ومتابعة';

  @override
  String get partnerVerificationPostalLookup => 'جلب العنوان من الرمز البريدي';

  @override
  String get partnerVerificationPostalResultTitle => 'العنوان البريدي المستلم';

  @override
  String get partnerVerificationMapConfirmationPending =>
      'سيتم تأكيد موقع المتجر الدقيق على الخريطة في المرحلة التالية.';

  @override
  String get partnerVerificationPostalLookupRequired =>
      'استعلم عن العنوان البريدي قبل الإرسال.';

  @override
  String get partnerVerificationNextLivenessMessage =>
      'تم حفظ معلومات الهوية والعنوان في المسودة. ستتم إضافة التحقق بالفيديو وتأكيد الموقع على الخريطة في المرحلة التالية.';

  @override
  String get partnerRegistrationFinalConfirm => 'تأكيد';

  @override
  String get partnerLivenessTitle => 'التحقق من الهوية بالفيديو';

  @override
  String get partnerLivenessSubtitle =>
      'بعد الموافقة سيتم تشغيل الكاميرا الأمامية. اقرأ العبارة المعروضة بوضوح.';

  @override
  String get partnerLivenessPhraseTitle => 'عبارة التحقق';

  @override
  String get partnerLivenessConsent =>
      'أوافق على تسجيل الفيديو ومعالجته للتحقق من هوية صاحب النشاط.';

  @override
  String get partnerLivenessConsentRequired =>
      'الموافقة على تسجيل الفيديو مطلوبة قبل تشغيل الكاميرا.';

  @override
  String get partnerLivenessCameraUnavailable =>
      'الكاميرا الأمامية غير متاحة أو لم يتم منح إذن الكاميرا والميكروفون.';

  @override
  String get partnerLivenessRecordInstruction =>
      'اضغط زر الكاميرا واقرأ العبارة بوضوح.';

  @override
  String get partnerLivenessRecordingInstruction =>
      'التسجيل جارٍ. اقرأ العبارة كاملة وبوضوح.';

  @override
  String get partnerLivenessStartRecording => 'بدء تسجيل الفيديو';

  @override
  String get partnerLivenessStopRecording => 'إيقاف تسجيل الفيديو';

  @override
  String get partnerLivenessRecordingFailed =>
      'تعذر تسجيل الفيديو. حاول مرة أخرى.';

  @override
  String get partnerLivenessPreviewTitle => 'معاينة الفيديو';

  @override
  String get partnerLivenessRetake => 'إعادة التسجيل';

  @override
  String get partnerLivenessVerificationFailed =>
      'فشل التحقق بالفيديو. سجل الفيديو مرة أخرى.';

  @override
  String get partnerMapConfirmationRequired =>
      'أكّد موقع المتجر على الخريطة أولاً.';

  @override
  String get partnerMapConfirmed => 'تم تأكيد موقع المتجر';

  @override
  String get partnerMapOpen => 'تأكيد الموقع على الخريطة';

  @override
  String get partnerMapConfirmInstruction => 'اضغط زر السهم لحفظ هذا الموقع.';

  @override
  String get partnerMapHint => 'الدبوس ثابت؛ حرّك الخريطة تحته.';

  @override
  String get partnerMapTitle => 'تأكيد موقع المتجر';

  @override
  String get partnerMapSubtitle =>
      'حرّك الخريطة حتى يصبح الدبوس فوق موقع المتجر بدقة.';

  @override
  String get partnerMapCoordinatesUnavailable =>
      'الإحداثيات الأولية غير متاحة.';

  @override
  String get partnerRegistrationImageSourceGallery => 'المعرض';

  @override
  String get partnerRegistrationImageSourceCamera => 'الكاميرا';

  @override
  String get partnerRegistrationImageSourceTitle => 'اختر مصدر الصورة';

  @override
  String get partnerIdentityResultPageTitle => 'نتيجة الاستعلام عن الهوية';

  @override
  String get partnerIdentityResultMatchedSubtitle =>
      'تم استلام بيانات الهوية ورقم الهاتف مطابق للرقم الوطني.';

  @override
  String get partnerIdentityResultMismatchSubtitle =>
      'رقم الهاتف غير مطابق للرقم الوطني. عدّل البيانات وأعد الاستعلام.';

  @override
  String get partnerIdentityEditInformation => 'تعديل البيانات';

  @override
  String get partnerIdentityNationalCardImage =>
      'صورة البطاقة الوطنية لمقدم الطلب';

  @override
  String get partnerIdentityNationalCardImageRequiredSubtitle =>
      'إلزامي؛ يجب التقاط الصورة مباشرة بالكاميرا.';

  @override
  String get partnerIdentityNationalCardImageValidation =>
      'التقاط صورة مباشرة للبطاقة الوطنية إلزامي.';

  @override
  String get partnerIdentityNationalCardCameraTitle => 'تصوير البطاقة الوطنية';

  @override
  String get partnerIdentityNationalCardCameraInstruction =>
      'ضع البطاقة كاملة ومستقيمة وواضحة داخل الإطار.';

  @override
  String get partnerDocumentCameraUnavailable =>
      'الكاميرا غير متاحة أو لم يتم منح إذن الكاميرا.';

  @override
  String get partnerDocumentCaptureFailed =>
      'تعذر التقاط الصورة. حاول مرة أخرى.';

  @override
  String get partnerLivenessProcessingVideo => 'جارٍ تجهيز معاينة الفيديو...';

  @override
  String get partnerOwnershipDocumentImage =>
      'صورة سند الملكية أو عقد الإيجار أو حق الانتفاع';

  @override
  String get partnerOwnershipDocumentImageRequired =>
      'إلزامي؛ اضغط لإضافة صورة.';

  @override
  String get partnerOwnershipDocumentImageValidation =>
      'صورة سند الملكية أو عقد الإيجار أو حق الانتفاع إلزامية.';

  @override
  String get partnerSignboardCameraInstruction =>
      'ضع لافتة المتجر كاملة وواضحة داخل الإطار.';

  @override
  String get partnerLicenseCameraInstruction =>
      'ضع رخصة النشاط كاملة ومستقيمة وواضحة داخل الإطار.';

  @override
  String get partnerOwnershipDocumentCameraInstruction =>
      'ضع الصفحة الرئيسية من سند الملكية أو عقد الإيجار كاملة وواضحة داخل الإطار.';

  @override
  String get partnerApplicationSubmitFinal => 'إرسال الطلب النهائي';

  @override
  String get partnerApplicationReviewTitle => 'مراجعة طلب الشراكة';

  @override
  String get partnerApplicationReviewSubtitle =>
      'راجع المعلومات قبل الإرسال. سيصدر رقم تتبع بعد التسجيل.';

  @override
  String get partnerApplicationActivitySection => 'نوع الشراكة';

  @override
  String get partnerApplicationCategory => 'مجموعة النشاط';

  @override
  String get partnerApplicationApplicantType => 'نوع مقدم الطلب';

  @override
  String get partnerApplicationIdentitySection => 'معلومات الهوية';

  @override
  String get partnerApplicationApplicantName => 'اسم مقدم الطلب';

  @override
  String get partnerApplicationStoreSection => 'موقع النشاط';

  @override
  String get partnerApplicationMapStatus => 'حالة الموقع';

  @override
  String get partnerApplicationMapConfirmed => 'تم تأكيد الموقع على الخريطة';

  @override
  String get partnerApplicationMapNotConfirmed =>
      'لم يتم تأكيد الموقع على الخريطة';

  @override
  String get partnerApplicationDocumentsSection => 'التحقق والمستندات';

  @override
  String get partnerApplicationVerified => 'تم التحقق';

  @override
  String get partnerApplicationSubmissionNotice =>
      'عند إرسال الطلب تُسجل المعلومات لمراجعتها من فريق شراكات آدرس.';

  @override
  String get partnerApplicationSuccessTitle => 'تم إرسال طلب الشراكة';

  @override
  String get partnerApplicationSuccessMessage =>
      'تم تسجيل طلبك بنجاح. احتفظ برقم التتبع التالي.';

  @override
  String get partnerApplicationAlreadySubmittedMessage =>
      'سبق إرسال هذا الطلب وتمت استعادة رقم التتبع نفسه.';

  @override
  String get partnerApplicationViewMyApplications => 'طلبات الشراكة الخاصة بي';

  @override
  String get partnerApplicationTrackingCode => 'رقم التتبع';

  @override
  String get partnerApplicationCopyTrackingCode => 'نسخ رقم التتبع';

  @override
  String get partnerApplicationTrackingCodeCopied => 'تم نسخ رقم التتبع.';

  @override
  String get partnerApplicationStatusSubmitted => 'تم الإرسال';

  @override
  String get partnerApplicationStatusUnderReview => 'قيد المراجعة';

  @override
  String get partnerApplicationStatusNeedsCorrection => 'يحتاج إلى تصحيح';

  @override
  String get partnerApplicationStatusApproved => 'مقبول';

  @override
  String get partnerApplicationStatusRejected => 'مرفوض';

  @override
  String get partnerApplicationStatusUnknown => 'غير معروف';

  @override
  String get partnerApplicationsTitle => 'طلبات الشراكة الخاصة بي';

  @override
  String get partnerApplicationsSubtitle =>
      'اعرض وتابع حالة طلبات الشراكة المسجلة.';

  @override
  String get partnerApplicationsEmpty => 'لم تسجل أي طلب شراكة بعد.';

  @override
  String get partnerApplicationRetry => 'إعادة المحاولة';

  @override
  String get partnerApplicationDetailsTitle => 'تفاصيل طلب الشراكة';

  @override
  String get partnerApplicationCurrentStatus => 'الحالة الحالية';

  @override
  String get partnerApplicationSubmittedAt => 'وقت الإرسال';

  @override
  String get partnerApplicationStatusHistory => 'سجل الحالة';

  @override
  String get partnerApplicationNoStatusHistory =>
      'لا يوجد سجل حالة لهذا الطلب.';

  @override
  String get partnerApplicationFormIncomplete =>
      'يرجى تصحيح الحقول الناقصة أو غير الصالحة في النموذج.';

  @override
  String get partnerApplicationVerificationExpired =>
      'التحقق من الهوية أو التحقق الحيوي غير مكتمل. أعد التسجيل من خطوة التحقق.';

  @override
  String get partnerApplicationUnexpectedFailure =>
      'حدث خطأ غير متوقع أثناء إرسال الطلب. يرجى المحاولة مرة أخرى.';

  @override
  String get authEntryTitle => 'تسجيل الدخول أو إنشاء حساب';

  @override
  String get authEntrySubtitle => 'أدخل رقم جوالك لتسجيل الدخول أو إنشاء حساب';

  @override
  String get registrationTitle => 'إكمال التسجيل في عنوان';

  @override
  String get registrationSubtitle =>
      'أدخل معلوماتك الأساسية واختر طريقة البدء.';

  @override
  String get registrationFirstName => 'الاسم';

  @override
  String get registrationLastName => 'اسم العائلة';

  @override
  String get registrationVerifiedPhone => 'رقم الجوال الموثق';

  @override
  String get registrationStartQuestion => 'كيف تريد أن تبدأ؟';

  @override
  String get registrationServicesTitle => 'استخدام خدمات عنوان';

  @override
  String get registrationServicesSubtitle =>
      'سيارات الأجرة والتسوق والتوصيل والحجز والخدمات الحضرية';

  @override
  String get registrationPartnerTitle => 'الشراكة مع عنوان';

  @override
  String get registrationPartnerSubtitle =>
      'متجر أو سائق أو مورد أو شراكات أخرى';

  @override
  String get registrationTermsAcceptance =>
      'أوافق على شروط الاستخدام وسياسة الخصوصية في عنوان.';

  @override
  String get registrationAction => 'إكمال التسجيل';

  @override
  String get registrationChangePhone => 'تغيير رقم الجوال';

  @override
  String get registrationExitAction => 'إلغاء التسجيل';

  @override
  String get registrationExitTitle => 'الخروج من التسجيل؟';

  @override
  String get registrationExitMessage =>
      'لم يكتمل تسجيلك بعد. عند الخروج، لن يتم حفظ المعلومات المدخلة في هذه الصفحة، ويمكنك التسجيل مرة أخرى لاحقًا.';

  @override
  String get registrationExitContinue => 'متابعة التسجيل';

  @override
  String get registrationExitConfirm => 'الخروج من التسجيل';

  @override
  String get registrationTermsRequired =>
      'يجب الموافقة على الشروط وسياسة الخصوصية للمتابعة.';

  @override
  String get registrationNameValidation =>
      'يجب أن يحتوي هذا الحقل على حرفين على الأقل.';

  @override
  String get registrationSessionExpired =>
      'جلسة تسجيل الدخول غير صالحة. سجّل الدخول مرة أخرى.';

  @override
  String get registrationTryAgainLater => 'يرجى المحاولة مرة أخرى بعد قليل.';

  @override
  String get registrationSubmitFailed =>
      'تعذر إكمال التسجيل. يرجى المحاولة مرة أخرى.';

  @override
  String get partnerApplicationHistorySubmittedByApplicant =>
      'تم إرسال الطلب بواسطة مقدم الطلب.';

  @override
  String get partnerReusableIdentityBannerTitle => 'تم التحقق من هويتك مسبقًا';

  @override
  String get partnerReusableIdentityBannerSubtitle =>
      'سيُعاد استخدام بيانات الهوية والتحقق الحيوي للنشاط الجديد، وستُطلب فقط معلومات النشاط.';

  @override
  String get profileTitle => 'ملفي الشخصي';

  @override
  String get profileSubtitle => 'إدارة معلومات الحساب وأنشطة الشراكة.';

  @override
  String get profilePersonalInfo => 'المعلومات الشخصية';

  @override
  String get profileEmailOptional => 'البريد الإلكتروني (اختياري)';

  @override
  String get profileBirthDateOptional => 'تاريخ الميلاد (اختياري)';

  @override
  String get profileVerifiedPhone => 'رقم الهاتف الموثق';

  @override
  String get profileAccountStatus => 'حالة الحساب';

  @override
  String get profileAccountActive => 'نشط';

  @override
  String get profilePartnerIdentity => 'هوية الشريك';

  @override
  String get profileIdentityVerified => 'تم توثيق هوية الشريك';

  @override
  String get profileIdentityNotVerified => 'لم يتم توثيق هوية الشريك بعد';

  @override
  String get profileIdentityValidUntil => 'صالحة حتى';

  @override
  String get profileActivities => 'الأنشطة وطلبات الشراكة';

  @override
  String get profileNoActivities => 'لم يتم تسجيل أي نشاط بعد.';

  @override
  String get profileAddActivity => 'إضافة نشاط جديد';

  @override
  String get profileSave => 'حفظ التغييرات';

  @override
  String get profileSaved => 'تم حفظ الملف الشخصي.';

  @override
  String get profileSaveFailed => 'تعذر حفظ الملف الشخصي.';

  @override
  String get profileLoadFailed => 'تعذر تحميل الملف الشخصي.';

  @override
  String get profileInvalidEmail => 'أدخل بريداً إلكترونياً صالحاً.';

  @override
  String get profileAvatarOptional => 'صورة الملف الشخصي اختيارية.';

  @override
  String get profileRemoveAvatar => 'حذف الصورة';

  @override
  String get profileAvatarSaved => 'تم حفظ صورة الملف الشخصي.';

  @override
  String get profileAvatarRemoved => 'تم حذف صورة الملف الشخصي.';

  @override
  String get profileAvatarUploadFailed => 'تعذر حفظ صورة الملف الشخصي.';

  @override
  String get profileImageTooLarge =>
      'يجب أن يكون حجم الصورة أقل من 2 ميغابايت.';

  @override
  String get profileUnsupportedImage =>
      'يجب أن تكون الصورة JPEG أو PNG أو WebP.';

  @override
  String get registrationAvatarOptional => 'صورة الملف الشخصي (اختياري)';

  @override
  String get registrationAvatarUploadSkipped =>
      'اكتمل التسجيل، لكن تعذر رفع صورة الملف الشخصي. يمكنك إضافتها لاحقاً من الملف الشخصي.';

  @override
  String get partnerApplicationRevision => 'إصدار الطلب';

  @override
  String get partnerApplicationCorrectionTitle => 'تصحيح الطلب';

  @override
  String get partnerApplicationCorrectionInstructions =>
      'حدّث المعلومات والمستندات وفق ملاحظة المراجع، ثم أعد إرسال الطلب.';

  @override
  String get partnerApplicationCorrectionNoteTitle => 'العناصر المطلوب تصحيحها';

  @override
  String get partnerApplicationStartCorrection => 'تصحيح الطلب';

  @override
  String get partnerApplicationResubmitFinal => 'إعادة إرسال الطلب';

  @override
  String get partnerApplicationResubmittedMessage =>
      'تمت إعادة إرسال الطلب المصحح بنجاح.';

  @override
  String get partnerApplicationHistoryResubmittedByApplicant =>
      'أعاد مقدم الطلب إرسال النسخة المصححة.';

  @override
  String get partnerSelectiveCorrectionTitle => 'تصحيح العناصر المحددة';

  @override
  String get partnerSelectiveCorrectionSubtitle =>
      'يمكن تعديل العناصر التي حددها المراجع فقط في هذه الصفحة.';

  @override
  String get partnerSelectiveCorrectionSelectedItems =>
      'العناصر المحددة للتصحيح';

  @override
  String get partnerSelectiveCorrectionOnlySelected =>
      'صحح العناصر التالية فقط، وستبقى بقية بيانات الطلب دون تغيير.';

  @override
  String get partnerSelectiveCorrectionItemsUnavailable =>
      'لم يتم استلام قائمة عناصر التصحيح. حدّث الصفحة.';

  @override
  String get partnerSelectiveCorrectionNewFileRequired =>
      'يجب رفع ملف جديد لهذا العنصر.';

  @override
  String get partnerSelectiveCorrectionOtherNotice =>
      'عند اختيار «أخرى» تظهر جميع الأقسام؛ غيّر فقط ما وصفه المراجع.';

  @override
  String get partnerSelectiveCorrectionLivenessRequired =>
      'لم يتم تسجيل فيديو تحقق حي جديد بعد.';

  @override
  String get partnerSelectiveCorrectionLivenessDone =>
      'تم تسجيل فيديو التحقق الحي الجديد.';

  @override
  String get partnerSelectiveCorrectionLivenessAction =>
      'إعادة تسجيل فيديو التحقق الحي';

  @override
  String get partnerSelectiveCorrectionMapRequired =>
      'لم يتم تأكيد الموقع الجديد على الخريطة بعد.';

  @override
  String get partnerSelectiveCorrectionMapDone =>
      'تم تأكيد الموقع الجديد على الخريطة.';

  @override
  String get partnerSelectiveCorrectionMapAction => 'تصحيح الموقع على الخريطة';

  @override
  String get partnerSelectiveCorrectionPostalLookupRequired =>
      'نفّذ استعلام العنوان بعد تغيير الرمز البريدي.';

  @override
  String get partnerSelectiveCorrectionSelectionRequired =>
      'اختر نوع نشاط واحداً على الأقل.';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get notificationsSubtitle =>
      'اطّلع هنا على آخر التحديثات والرسائل المهمة لحسابك.';

  @override
  String get notificationsBack => 'رجوع';

  @override
  String get notificationsUnread => 'غير مقروء';

  @override
  String get notificationsMarkAllRead => 'تحديد الكل كمقروء';

  @override
  String get notificationsEmpty => 'لا توجد إشعارات';

  @override
  String get notificationsEmptyDescription =>
      'ستظهر هنا الإشعارات الجديدة والتحديثات المهمة للحساب.';

  @override
  String get notificationsLoadFailed => 'تعذر تحميل الإشعارات';

  @override
  String get notificationsLoadFailedDescription =>
      'تعذر الاتصال بصندوق الإشعارات. حاول مرة أخرى.';

  @override
  String get notificationsRefreshFailed =>
      'تعذر تحديث الإشعارات، ويتم عرض المعلومات المحملة سابقًا.';

  @override
  String get notificationsReadFailed => 'تعذر تسجيل الإشعار كمقروء.';

  @override
  String get notificationsMarkAllFailed => 'تعذر تسجيل جميع الإشعارات كمقروءة.';

  @override
  String get notificationPartnerReviewStartedTitle => 'بدأت مراجعة الطلب';

  @override
  String get notificationPartnerReviewStartedBody =>
      'بدأ المراجع فحص طلب الشراكة الخاص بك.';

  @override
  String get notificationPartnerNeedsCorrectionTitle => 'الطلب يحتاج إلى تصحيح';

  @override
  String get notificationPartnerNeedsCorrectionBody =>
      'افتح تفاصيل الطلب لمراجعة العناصر المطلوبة وتصحيحها.';

  @override
  String get notificationPartnerApprovedTitle => 'تم قبول طلب الشراكة';

  @override
  String get notificationPartnerApprovedBody =>
      'تمت الموافقة على طلب الشراكة الخاص بك بنجاح.';

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
  String get notificationUnknownTitle => 'إشعار جديد';

  @override
  String get notificationUnknownBody => 'تم تسجيل تحديث جديد في حسابك.';
}
