// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '超级应用';

  @override
  String get home => '首页';

  @override
  String get phoneNumber => '手机号码';

  @override
  String get continueLabel => '继续';

  @override
  String get retry => '重试';

  @override
  String get unknownError => '发生未知错误';

  @override
  String get getStarted => '开始';

  @override
  String get changeLanguage => '更改语言';

  @override
  String get onboardingSubtitle => '更轻松地使用出行、购物、配送和日常服务。';

  @override
  String get onboardingTitle => '城市服务，尽在一个地址';

  @override
  String get login => '登录';

  @override
  String get welcome => '欢迎';

  @override
  String get enteryourmobilenumber => '请输入您的手机号码';

  @override
  String get mobileNumber => '手机号码';

  @override
  String get enterMobileError => '请输入手机号码';

  @override
  String get notDigits => '手机号码只能包含数字';

  @override
  String get invalidPrefix => '手机号码必须以“09”或“9”开头';

  @override
  String get enterMobileErrorWithZero => '手机号码应为11位（以0开头）';

  @override
  String get enterMobileErrorWithoutZero => '手机号码应为10位（不以0开头）';

  @override
  String get tooShort => '手机号码过短';

  @override
  String get networkError => '网络错误，请检查您的连接';

  @override
  String enterOtpCode(Object phoneNumber) {
    return '请输入发送到 $phoneNumber 的五位验证码';
  }

  @override
  String didNotReceiveCode(Object seconds) {
    return '未收到验证码 (00:$seconds)';
  }

  @override
  String get resendCode => '重新发送验证码';

  @override
  String get changeNumber => '更改号码';

  @override
  String get or => '或';

  @override
  String get email => '电子邮件';

  @override
  String get enterFullOtpCode => '请输入完整的5位验证码';

  @override
  String get invalidOtpCode => '验证码不正确';

  @override
  String get expiredOtpCode => '验证码已过期，请重新获取';

  @override
  String get otpRequestTooSoon => '请稍候再请求新的验证码';

  @override
  String get language => '语言';

  @override
  String get logOut => '注销';

  @override
  String get services => '服务';

  @override
  String get activity => '活动';

  @override
  String get messages => '消息';

  @override
  String get settings => '设置';

  @override
  String get sendGift => '发送礼物';

  @override
  String get businessHub => '商务中心';

  @override
  String get manageAddressAccount => '管理账户和地址';

  @override
  String get ride => '出行';

  @override
  String get deliver => '配送';

  @override
  String get airport => '机场';

  @override
  String get bike => '摩托车';

  @override
  String get safeYourTrip => '保障您的旅程';

  @override
  String get anywhereCityTrip => '市内任意地点';

  @override
  String get cityOrIntercityTrip => '市内或城际行程';

  @override
  String get fastAndSafe => '快速且安全';

  @override
  String get passengerServices => '乘客服务';

  @override
  String get cargoServices => '货运服务';

  @override
  String get foodServices => '餐饮服务';

  @override
  String get generalServices => '综合服务';

  @override
  String get repairServices => '维修与配件';

  @override
  String get insuranceServices => 'Address 合作伙伴';

  @override
  String get comingSoon => '此功能即将上线。';

  @override
  String get logoutConfirmTitle => '退出登录';

  @override
  String get logoutConfirmMessage => '确定要退出当前账户吗？';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '退出';

  @override
  String get addressUser => '地址用户';

  @override
  String get distributionOrders => '配送订单';

  @override
  String get distributionOrderDetails => '订单详情';

  @override
  String get allOrders => '全部';

  @override
  String get confirmedOrders => '已确认';

  @override
  String get receivedOrders => '已接收';

  @override
  String get filterByState => '按状态筛选';

  @override
  String get clearFilters => '清除筛选';

  @override
  String get noDistributionOrders => '未找到订单';

  @override
  String get noDistributionOrdersDescription => '当前没有符合此筛选条件的订单。';

  @override
  String get distributionLoading => '正在加载订单...';

  @override
  String get distributionLoadError => '无法加载订单';

  @override
  String get distributionNetworkError => '无法连接服务器，请检查网络连接。';

  @override
  String get distributionUnauthorized => '当前会话已失效，请重新登录。';

  @override
  String get distributionForbidden => '此账户无权查看配送订单。';

  @override
  String get distributionServerError => '配送服务暂时不可用。';

  @override
  String get distributionInvalidResponse => '配送服务返回了无效响应。';

  @override
  String get distributionOrderNotFound => '未找到所请求的订单。';

  @override
  String get orderNumber => '订单号';

  @override
  String get orderStatus => '订单状态';

  @override
  String get walletStatus => '钱包状态';

  @override
  String get deliveryStatus => '配送状态';

  @override
  String get totalAmount => '总金额';

  @override
  String get plannedDelivery => '计划配送';

  @override
  String get createdDate => '创建时间';

  @override
  String get deliveryDriver => '配送司机';

  @override
  String get deliveryTrip => '配送行程';

  @override
  String get deliveryConfirmed => '配送确认时间';

  @override
  String get deliveryProof => '配送凭证';

  @override
  String get orderProducts => '订单商品';

  @override
  String get quantity => '数量';

  @override
  String get unitPrice => '单价';

  @override
  String get finalUnitPrice => '最终单价';

  @override
  String get walletReservedAmount => '预留金额';

  @override
  String get walletCapturedAmount => '已收金额';

  @override
  String get notAvailable => '暂无';

  @override
  String get viewDetails => '查看详情';

  @override
  String get stateDraft => '草稿';

  @override
  String get stateConfirmed => '已确认';

  @override
  String get stateReceived => '已接收';

  @override
  String get stateCancelled => '已取消';

  @override
  String get walletPaid => '已支付';

  @override
  String get walletReserved => '已预留';

  @override
  String get walletUnpaid => '未支付';

  @override
  String get walletRefunded => '已退款';

  @override
  String get deliveryDelivered => '已送达';

  @override
  String get deliveryNone => '无需配送';

  @override
  String get deliveryPending => '待处理';

  @override
  String get deliveryAssigned => '已分配';

  @override
  String get deliveryInTransit => '配送中';

  @override
  String get adminShopAccess => '店铺访问管理';

  @override
  String get manageShopAccess => '授予或撤销店铺访问权限';

  @override
  String get adminShopAccessPrivacyNote => '完整手机号仅用于本次请求，访问列表只显示脱敏号码。';

  @override
  String get shopId => '店铺 ID';

  @override
  String get optionalShopId => '店铺 ID（可选）';

  @override
  String get invalidShopId => '请输入有效的正数店铺 ID';

  @override
  String get invalidAdminMobile => '请输入有效的伊朗手机号';

  @override
  String get grantAccess => '授予权限';

  @override
  String get revokeAccess => '撤销权限';

  @override
  String get adminAccessGranted => '权限已授予';

  @override
  String get adminAccessRevoked => '权限已撤销';

  @override
  String get accessListFilters => '访问列表筛选';

  @override
  String get applyFilters => '应用';

  @override
  String get includeInactiveAccess => '包含已停用权限';

  @override
  String get activeAccess => '有效';

  @override
  String get inactiveAccess => '已停用';

  @override
  String get adminAccessLoading => '正在加载店铺访问权限...';

  @override
  String get noAdminShopAccess => '未找到访问权限';

  @override
  String get noAdminShopAccessDescription => '没有符合当前筛选条件的访问映射。';

  @override
  String get adminAccessForbiddenTitle => '需要管理员权限';

  @override
  String get adminAccessForbiddenMessage => '此账户无权管理店铺访问权限。';

  @override
  String get adminAccessLoadError => '无法加载访问权限';

  @override
  String get adminAccessUnauthorized => '当前会话已失效，请重新登录。';

  @override
  String get adminAccessValidationError => '手机号或店铺 ID 无效。';

  @override
  String get adminAccessNetworkError => '无法连接服务器，请检查网络。';

  @override
  String get adminAccessServerError => '访问管理服务暂时不可用。';

  @override
  String get adminAccessInvalidResponse => '无法处理访问管理服务的响应。';

  @override
  String get shopIdVerificationNote =>
      '请使用已在 Odoo 中核对的店铺 ID；Gateway 按最小权限原则不具备读取完整店铺目录的权限。';

  @override
  String get partnerShop => '商店和超市';

  @override
  String get addressPartnersIntro => '请选择合作类型。注册、资料审核和专属工作台启用将在后续阶段完成。';

  @override
  String get partnerDistributor => '配送公司';

  @override
  String get partnerCarDriver => '汽车司机';

  @override
  String get partnerFoodBusiness => '餐厅、快餐和餐饮服务';

  @override
  String get partnerMotorcycleDriver => '摩托车司机';

  @override
  String get companyPharmaMedical => '药品和医疗用品';

  @override
  String get storeBeautyHealth => '美容健康用品店';

  @override
  String get foodBakeryDessert => '面包、糕点和甜品';

  @override
  String get storeBakeryPastry => '面包和糕点店';

  @override
  String get foodCatering => '餐饮配送和熟食';

  @override
  String get otherHomeBuilding => '家庭和建筑服务';

  @override
  String get driverVan => '厢式车';

  @override
  String get partnerCategoryDriver => '司机';

  @override
  String get driverPickup => '皮卡';

  @override
  String get otherTechnicalRepair => '技术和维修服务';

  @override
  String get driverTractorTrailer => '牵引车和挂车';

  @override
  String get companyBeautyHealth => '美容和个人护理产品';

  @override
  String get foodIranian => '伊朗餐厅';

  @override
  String get partnerCategoryOther => '其他';

  @override
  String get driverLightTruck => '轻型卡车';

  @override
  String get driverMotorcycle => '摩托车';

  @override
  String get storeDairy => '乳制品店';

  @override
  String get companyMotorcycleParts => '摩托车零配件';

  @override
  String get companyHeavyVehicleParts => '重型汽车零配件';

  @override
  String get otherHospitality => '酒店、住宿和旅游';

  @override
  String get partnersFormNextStage => '下一阶段将创建该类别的注册表单。';

  @override
  String get companyCleaning => '洗涤和清洁产品';

  @override
  String get storeProtein => '肉类和蛋白制品店';

  @override
  String get foodFastFood => '快餐';

  @override
  String get partnerCategoryCompany => '公司';

  @override
  String get partnersChooseSubcategory => '经营活动';

  @override
  String get foodCafe => '咖啡馆';

  @override
  String get driverPassengerCar => '乘用车';

  @override
  String get storeFruitVegetable => '水果蔬菜店';

  @override
  String get partnersChooseCategory => '选择合作类型';

  @override
  String get partnersContinue => '继续';

  @override
  String get companyRetailEquipment => '零售设备和用品';

  @override
  String get otherEvents => '活动和庆典服务';

  @override
  String get otherLaundry => '洗衣和清洗服务';

  @override
  String get driverBus => '巴士';

  @override
  String get storeSupermarket => '超市';

  @override
  String get storeGrocery => '杂货店';

  @override
  String get otherBeautyWellness => '美容和健康服务';

  @override
  String get companyPackagingDisposable => '包装和一次性用品';

  @override
  String get driverTruck => '卡车';

  @override
  String get companyLightVehicleParts => '轻型汽车零配件';

  @override
  String get companyFoodBeverage => '食品和饮料';

  @override
  String get partnersSingleSelection => '选择一项';

  @override
  String get partnerCategoryStore => '商店';

  @override
  String get foodHealthyDiet => '健康和减脂餐';

  @override
  String get partnerCategoryFood => '餐饮';

  @override
  String get otherBusiness => '其他业务';

  @override
  String get driverMinibus => '小型巴士';

  @override
  String get foodInternational => '国际餐厅';

  @override
  String get partnersMultipleSelection => '可多选';

  @override
  String get foodSeafood => '海鲜餐厅';

  @override
  String get partnersStartOver => '重新开始';

  @override
  String get partnersSelected => '已选择';

  @override
  String get partnersSecondaryActivities => '辅助业务';

  @override
  String get partnersQuestionTitle => '您的业务属于哪一类？';

  @override
  String get storeSupermarketDescription => '多种日常用品';

  @override
  String get partnersSelect => '选择';

  @override
  String get partnersSummaryReadyTitle => '商家资料已准备完成！';

  @override
  String get storeDairyDescription => '牛奶与乳制品';

  @override
  String get partnersMainCategory => '主分类';

  @override
  String get partnerGroupOtherSubtitle => '专业与生活服务';

  @override
  String get partnerGroupCompaniesSubtitle => '批发供应与配送';

  @override
  String get partnersRegistrationNext => '注册与提交申请表将在下一阶段接入。';

  @override
  String get partnerGroupFoodSubtitle => '餐厅、咖啡馆与熟食';

  @override
  String get foodCateringDescription => '餐饮配送与预制订单';

  @override
  String get storeBakeryPastryDescription => '面包与糕点';

  @override
  String get partnerGroupCompanies => '公司与供应商';

  @override
  String get foodInternationalDescription => '国际菜系';

  @override
  String get partnersBrandSubtitle => '商家注册与分类选择';

  @override
  String get partnerGroupDrivers => '司机与车队';

  @override
  String get partnersPrimaryBadge => '主营';

  @override
  String partnersSubcategoryCount(int count) {
    return '$count 个子分类';
  }

  @override
  String get partnersNothingSelected => '尚未选择';

  @override
  String get partnersCompleteRegistration => '填写注册表';

  @override
  String get partnersPrimaryActivity => '主营业务';

  @override
  String get partnersPrimarySummaryBadge => '主营';

  @override
  String get partnerGroupStores => '商店';

  @override
  String get storeFruitVegetableDescription => '新鲜水果和蔬菜';

  @override
  String get partnersStepConfirm => '最终确认';

  @override
  String get partnerGroupDriversSubtitle => '运输与物流';

  @override
  String partnersSelectionCount(int count) {
    return '已选择 $count 项';
  }

  @override
  String get partnersDriverCompany => '运输公司';

  @override
  String get storeBeautyHealthDescription => '美容与个人护理';

  @override
  String get partnersVersionLabel => '版本 1.0';

  @override
  String get partnersViewSummary => '查看摘要';

  @override
  String get foodBakeryDessertDescription => '面包、糕点与甜品';

  @override
  String get foodSeafoodDescription => '海鲜菜肴';

  @override
  String get partnersHintDriverPersonal => '个人司机请选择一辆主要车辆。';

  @override
  String get partnersOneItem => '（一项）';

  @override
  String get partnersSelectedOptions => '已选项目';

  @override
  String get partnersSummaryReadySubtitle => '您在 Address 中的选择摘要';

  @override
  String get partnersDriverPersonal => '个人司机';

  @override
  String get storeGroceryDescription => '杂货与食材';

  @override
  String get foodCafeDescription => '咖啡与饮品';

  @override
  String get partnersHintMultiple => '可以同时选择多个选项。';

  @override
  String get foodIranianDescription => '传统伊朗菜';

  @override
  String get foodFastFoodDescription => '快捷餐食';

  @override
  String get partnersQuestionSubtitle => '请选择五个主分类之一以查看相关子分类。';

  @override
  String get partnersMainVehicle => '主要车辆';

  @override
  String get partnerGroupOther => '其他服务';

  @override
  String get partnersStepDetails => '经营详情';

  @override
  String get foodHealthyDietDescription => '健康与减脂餐';

  @override
  String get partnerGroupStoresSubtitle => '直接向顾客零售商品';

  @override
  String get partnersStepCategory => '主分类';

  @override
  String get partnersHintDriverCompany => '运输公司可以登记多种车辆。';

  @override
  String get partnerGroupFood => '餐饮与接待';

  @override
  String get storeProteinDescription => '肉类与蛋白制品';

  @override
  String get partnersHintPrimarySecondary => '请选择一个主营业务，然后可添加多个辅助业务。';

  @override
  String get partnersBack => '返回';

  @override
  String get partnersBrandTitle => 'Address 合作伙伴';

  @override
  String get partnersFleetTypes => '车辆类型';

  @override
  String get partnersSupport => '支持';

  @override
  String get partnersSupportSubtitle => '始终陪伴您';

  @override
  String get partnerRegistrationStart => '开始注册';

  @override
  String get partnerRegistrationContinue => '继续';

  @override
  String get partnerRegistrationApplicantTypeTitle => '选择申请人类型';

  @override
  String get partnerRegistrationApplicantTypeSubtitle => '请选择以个人或企业名义提交申请。';

  @override
  String get partnerRegistrationIndividual => '个人';

  @override
  String get partnerRegistrationIndividualDescription => '以个人名义提交申请';

  @override
  String get partnerRegistrationLegalEntity => '公司或法人企业';

  @override
  String get partnerRegistrationLegalEntityDescription => '使用公司的正式信息注册';

  @override
  String get partnerRegistrationBasicInfoTitle => '基本信息';

  @override
  String get partnerRegistrationBasicInfoSubtitle => '请输入申请人的身份和联系方式。';

  @override
  String get partnerRegistrationFullName => '姓名';

  @override
  String get partnerRegistrationCompanyName => '公司或企业正式名称';

  @override
  String get partnerRegistrationRepresentativeName => '负责人姓名';

  @override
  String get partnerRegistrationNationalId => '身份证号';

  @override
  String get partnerRegistrationCompanyNationalId => '企业统一识别号';

  @override
  String get partnerRegistrationMobile => '手机号码';

  @override
  String get partnerRegistrationEmailOptional => '电子邮箱（可选）';

  @override
  String get partnerRegistrationRequiredField => '此项为必填项';

  @override
  String get partnerRegistrationInvalidMobile => '请输入有效的手机号码';

  @override
  String get partnerRegistrationBasicInfoSaved => '基本信息已保存，下一步将填写业务信息。';

  @override
  String get partnerRegistrationBusinessInfoTitle => '业务信息';

  @override
  String get partnerRegistrationBusinessInfoSubtitle => '填写业务名称、服务内容和从业经验。';

  @override
  String get partnerRegistrationBusinessName => '企业或业务名称';

  @override
  String get partnerRegistrationBusinessDescription => '产品或服务的简要说明';

  @override
  String get partnerRegistrationExperienceYears => '从业年限（可选）';

  @override
  String get partnerRegistrationSaveBusinessInfo => '保存信息';

  @override
  String get partnerRegistrationBusinessInfoSaved => '业务信息已保存到草稿。';

  @override
  String get partnerRegistrationIndividualFormTitle => '个人注册表';

  @override
  String get partnerRegistrationLegalFormTitle => '企业注册表';

  @override
  String get partnerRegistrationFormSubtitle => '请在此表中填写身份和业务信息。';

  @override
  String get partnerRegistrationSubmitApplication => '提交申请';

  @override
  String get partnerRegistrationDraftSaved => '表单已成功保存为草稿。';

  @override
  String get partnerRegistrationPersonalInformationTitle => '个人信息';

  @override
  String get partnerRegistrationCompanyInformationTitle => '企业信息';

  @override
  String get partnerRegistrationPersonalInformationSubtitle => '请输入身份和联系方式。';

  @override
  String get partnerRegistrationRepresentativeNationalId => '公司代表身份证号';

  @override
  String get partnerRegistrationCompanyLandline => '公司固定电话';

  @override
  String get partnerRegistrationLandlineOptional => '固定电话（可选）';

  @override
  String get partnerRegistrationInvalidNationalId => '身份证号必须为10位数字。';

  @override
  String get partnerRegistrationInvalidCompanyNationalId => '企业识别号必须为11位数字。';

  @override
  String get partnerRegistrationInvalidIranianMobile => '手机号必须以09开头并包含11位数字。';

  @override
  String get partnerRegistrationInvalidLandline => '请输入包含区号的11位固定电话号码。';

  @override
  String get partnerRegistrationContinueToStore => '继续填写商店信息';

  @override
  String get partnerRegistrationStoreInformationTitle => '商店信息';

  @override
  String get partnerRegistrationStoreInformationSubtitle => '填写经营场所信息并上传所需图片。';

  @override
  String get partnerRegistrationStoreName => '商店名称';

  @override
  String get partnerRegistrationStoreOwnership => '商店产权类型';

  @override
  String get partnerRegistrationOwnershipOwner => '自有';

  @override
  String get partnerRegistrationOwnershipTenant => '租赁';

  @override
  String get partnerRegistrationOwnershipGoodwill => '商誉权';

  @override
  String get partnerRegistrationOwnershipOther => '其他';

  @override
  String get partnerRegistrationStorePhone => '商店固定电话';

  @override
  String get partnerRegistrationPostalCode => '邮政编码';

  @override
  String get partnerRegistrationStoreArea => '商店面积（平方米）';

  @override
  String get partnerRegistrationStoreAddress => '商店完整地址';

  @override
  String get partnerRegistrationBusinessDescriptionOptional => '业务简述（可选）';

  @override
  String get partnerRegistrationLicenseImage => '营业执照图片';

  @override
  String get partnerRegistrationLicenseImageOptional => '可选；点击选择图片。';

  @override
  String get partnerRegistrationSignboardImage => '商店招牌图片';

  @override
  String get partnerRegistrationSignboardImageRequired => '必填；点击选择图片。';

  @override
  String get partnerRegistrationSignboardImageValidation => '必须上传商店招牌图片。';

  @override
  String get partnerRegistrationInvalidPostalCode => '邮政编码必须为10位数字。';

  @override
  String get partnerRegistrationInvalidStoreArea => '商店面积必须大于零。';

  @override
  String get partnerRegistrationDraftCompletedTitle => '信息已保存';

  @override
  String get partnerRegistrationDraftCompletedMessage =>
      '信息已保存为草稿，下一阶段将连接服务器提交。';

  @override
  String get partnerRegistrationDialogConfirm => '确定';

  @override
  String get partnerVerificationOwnerTitle => '企业主身份验证';

  @override
  String get partnerVerificationLegalOwnerTitle => '公司代表身份验证';

  @override
  String get partnerVerificationOwnerSubtitle => '请输入登记在企业主或公司代表名下的身份证号和手机号。';

  @override
  String get partnerVerificationOwnerMobile => '企业主手机号';

  @override
  String get partnerVerificationConsent => '我同意为合作申请进行身份查询和数据处理。';

  @override
  String get partnerVerificationConsentRequired => '进行身份验证前必须同意授权。';

  @override
  String get partnerVerificationLookupIdentity => '查询身份信息';

  @override
  String get partnerVerificationIdentityResultTitle => '查询到的身份信息';

  @override
  String get partnerVerificationMobileMatched => '手机号所有权与身份证号匹配。';

  @override
  String get partnerVerificationMobileMismatch => '该手机号不属于此身份证号。';

  @override
  String get partnerVerificationFatherName => '父亲姓名';

  @override
  String get partnerVerificationBirthDate => '出生日期';

  @override
  String get partnerVerificationConfirmAccuracy => '我确认显示的信息正确。';

  @override
  String get partnerVerificationAccuracyRequired => '继续前请确认显示的信息。';

  @override
  String get partnerVerificationConfirmAndContinue => '确认并继续';

  @override
  String get partnerVerificationPostalLookup => '通过邮政编码获取地址';

  @override
  String get partnerVerificationPostalResultTitle => '查询到的邮政地址';

  @override
  String get partnerVerificationMapConfirmationPending => '下一阶段将在地图上确认商店的准确位置。';

  @override
  String get partnerVerificationPostalLookupRequired => '提交前请先查询邮政地址。';

  @override
  String get partnerVerificationNextLivenessMessage =>
      '身份和邮政信息已保存到草稿。下一阶段将加入视频活体检测和地图位置确认。';

  @override
  String get partnerRegistrationFinalConfirm => '确认';

  @override
  String get partnerLivenessTitle => '视频身份验证';

  @override
  String get partnerLivenessSubtitle => '同意后将启动前置摄像头。请清晰朗读显示的句子。';

  @override
  String get partnerLivenessPhraseTitle => '验证句子';

  @override
  String get partnerLivenessConsent => '我同意为企业主身份验证录制和处理视频。';

  @override
  String get partnerLivenessConsentRequired => '启动摄像头前必须同意视频授权。';

  @override
  String get partnerLivenessCameraUnavailable => '前置摄像头不可用，或未授予摄像头和麦克风权限。';

  @override
  String get partnerLivenessRecordInstruction => '点击摄像头按钮并清晰朗读句子。';

  @override
  String get partnerLivenessRecordingInstruction => '正在录制，请清晰完整地朗读句子。';

  @override
  String get partnerLivenessStartRecording => '开始录制视频';

  @override
  String get partnerLivenessStopRecording => '停止录制视频';

  @override
  String get partnerLivenessRecordingFailed => '视频录制失败，请重试。';

  @override
  String get partnerLivenessPreviewTitle => '视频预览';

  @override
  String get partnerLivenessRetake => '重新录制';

  @override
  String get partnerLivenessVerificationFailed => '视频验证失败，请重新录制。';

  @override
  String get partnerMapConfirmationRequired => '请先在地图上确认店铺位置。';

  @override
  String get partnerMapConfirmed => '店铺位置已确认';

  @override
  String get partnerMapOpen => '在地图上确认位置';

  @override
  String get partnerMapConfirmInstruction => '点击箭头按钮保存此位置。';

  @override
  String get partnerMapHint => '图钉保持固定，请移动下方地图。';

  @override
  String get partnerMapTitle => '确认店铺位置';

  @override
  String get partnerMapSubtitle => '移动地图，使图钉准确位于店铺位置。';

  @override
  String get partnerMapCoordinatesUnavailable => '无法获取初始坐标。';

  @override
  String get partnerRegistrationImageSourceGallery => '图库';

  @override
  String get partnerRegistrationImageSourceCamera => '相机';

  @override
  String get partnerRegistrationImageSourceTitle => '选择图片来源';

  @override
  String get partnerIdentityResultPageTitle => '身份查询结果';

  @override
  String get partnerIdentityResultMatchedSubtitle => '已获取身份信息，手机号与身份证号匹配。';

  @override
  String get partnerIdentityResultMismatchSubtitle => '手机号与身份证号不匹配。请编辑信息后重新查询。';

  @override
  String get partnerIdentityEditInformation => '编辑信息';

  @override
  String get partnerIdentityNationalCardImage => '申请人身份证照片';

  @override
  String get partnerIdentityNationalCardImageRequiredSubtitle =>
      '必填；必须使用相机实时拍摄。';

  @override
  String get partnerIdentityNationalCardImageValidation => '必须实时拍摄申请人的身份证照片。';

  @override
  String get partnerIdentityNationalCardCameraTitle => '拍摄身份证';

  @override
  String get partnerIdentityNationalCardCameraInstruction =>
      '请将完整、平整且清晰的证件放入取景框内。';

  @override
  String get partnerDocumentCameraUnavailable => '相机不可用或未授予相机权限。';

  @override
  String get partnerDocumentCaptureFailed => '拍摄失败，请重试。';

  @override
  String get partnerLivenessProcessingVideo => '正在准备视频预览...';

  @override
  String get partnerOwnershipDocumentImage => '产权证、租赁合同或经营权文件照片';

  @override
  String get partnerOwnershipDocumentImageRequired => '必填；点击添加照片。';

  @override
  String get partnerOwnershipDocumentImageValidation => '必须提供产权证、租赁合同或经营权文件照片。';

  @override
  String get partnerSignboardCameraInstruction => '请将完整清晰的店铺招牌放入取景框内。';

  @override
  String get partnerLicenseCameraInstruction => '请将完整、平整且清晰的经营许可证放入取景框内。';

  @override
  String get partnerOwnershipDocumentCameraInstruction =>
      '请将产权证、租赁合同或经营权文件的主页完整清晰地放入取景框内。';

  @override
  String get partnerApplicationSubmitFinal => '最终提交申请';

  @override
  String get partnerApplicationReviewTitle => '审核合作申请';

  @override
  String get partnerApplicationReviewSubtitle => '提交前请核对以下信息。登记后将生成跟踪编号。';

  @override
  String get partnerApplicationActivitySection => '合作类型';

  @override
  String get partnerApplicationCategory => '业务类别';

  @override
  String get partnerApplicationApplicantType => '申请人类型';

  @override
  String get partnerApplicationIdentitySection => '身份信息';

  @override
  String get partnerApplicationApplicantName => '申请人姓名';

  @override
  String get partnerApplicationStoreSection => '经营地点';

  @override
  String get partnerApplicationMapStatus => '位置状态';

  @override
  String get partnerApplicationMapConfirmed => '地图位置已确认';

  @override
  String get partnerApplicationMapNotConfirmed => '地图位置尚未确认';

  @override
  String get partnerApplicationDocumentsSection => '验证与文件';

  @override
  String get partnerApplicationVerified => '已验证';

  @override
  String get partnerApplicationSubmissionNotice => '提交后，信息将登记并交由“地址”合作团队审核。';

  @override
  String get partnerApplicationSuccessTitle => '合作申请已提交';

  @override
  String get partnerApplicationSuccessMessage => '申请已成功提交，请保存以下跟踪编号。';

  @override
  String get partnerApplicationAlreadySubmittedMessage => '此申请此前已提交，现已恢复原跟踪编号。';

  @override
  String get partnerApplicationViewMyApplications => '我的合作申请';

  @override
  String get partnerApplicationTrackingCode => '跟踪编号';

  @override
  String get partnerApplicationCopyTrackingCode => '复制跟踪编号';

  @override
  String get partnerApplicationTrackingCodeCopied => '跟踪编号已复制。';

  @override
  String get partnerApplicationStatusSubmitted => '已提交';

  @override
  String get partnerApplicationStatusUnderReview => '审核中';

  @override
  String get partnerApplicationStatusNeedsCorrection => '需要修改';

  @override
  String get partnerApplicationStatusApproved => '已批准';

  @override
  String get partnerApplicationStatusRejected => '已拒绝';

  @override
  String get partnerApplicationStatusUnknown => '未知';

  @override
  String get partnerApplicationsTitle => '我的合作申请';

  @override
  String get partnerApplicationsSubtitle => '查看并跟踪已提交合作申请的状态。';

  @override
  String get partnerApplicationsEmpty => '您尚未提交合作申请。';

  @override
  String get partnerApplicationRetry => '重试';

  @override
  String get partnerApplicationDetailsTitle => '合作申请详情';

  @override
  String get partnerApplicationCurrentStatus => '当前状态';

  @override
  String get partnerApplicationSubmittedAt => '提交时间';

  @override
  String get partnerApplicationStatusHistory => '状态记录';

  @override
  String get partnerApplicationNoStatusHistory => '此申请暂无状态记录。';

  @override
  String get partnerApplicationFormIncomplete => '请修正表单中未填写或无效的字段。';

  @override
  String get partnerApplicationVerificationExpired =>
      '身份验证或活体验证不完整，请从验证步骤重新开始注册。';

  @override
  String get partnerApplicationUnexpectedFailure => '提交申请时发生意外错误，请重试。';

  @override
  String get authEntryTitle => '登录或注册';

  @override
  String get authEntrySubtitle => '输入手机号以登录或创建账户';

  @override
  String get registrationTitle => '完成“地址”注册';

  @override
  String get registrationSubtitle => '填写基本信息并选择开始方式。';

  @override
  String get registrationFirstName => '名字';

  @override
  String get registrationLastName => '姓氏';

  @override
  String get registrationVerifiedPhone => '已验证手机号';

  @override
  String get registrationStartQuestion => '您想如何开始？';

  @override
  String get registrationServicesTitle => '使用“地址”服务';

  @override
  String get registrationServicesSubtitle => '出租车、购物、配送、预订和城市服务';

  @override
  String get registrationPartnerTitle => '成为“地址”合作伙伴';

  @override
  String get registrationPartnerSubtitle => '商店、司机、供应商及其他合作类型';

  @override
  String get registrationTermsAcceptance => '我接受“地址”使用条款和隐私政策。';

  @override
  String get registrationAction => '完成注册';

  @override
  String get registrationChangePhone => '更换手机号';

  @override
  String get registrationExitAction => '取消注册';

  @override
  String get registrationExitTitle => '退出注册？';

  @override
  String get registrationExitMessage => '您的注册尚未完成。退出后，本页已输入的信息不会保存，您可以稍后重新注册。';

  @override
  String get registrationExitContinue => '继续注册';

  @override
  String get registrationExitConfirm => '退出注册';

  @override
  String get registrationTermsRequired => '继续前必须接受使用条款和隐私政策。';

  @override
  String get registrationNameValidation => '此字段至少需要两个字符。';

  @override
  String get registrationSessionExpired => '登录会话无效，请重新登录。';

  @override
  String get registrationTryAgainLater => '请稍后重试。';

  @override
  String get registrationSubmitFailed => '无法完成注册，请重试。';

  @override
  String get partnerApplicationHistorySubmittedByApplicant => '申请已由申请人提交。';

  @override
  String get partnerReusableIdentityBannerTitle => '您的身份已通过验证';

  @override
  String get partnerReusableIdentityBannerSubtitle =>
      '新的经营活动将复用已验证的身份和活体验证信息，只需填写该活动的专属资料。';

  @override
  String get profileTitle => '我的个人资料';

  @override
  String get profileSubtitle => '管理账户信息和合作活动。';

  @override
  String get profilePersonalInfo => '个人信息';

  @override
  String get profileEmailOptional => '电子邮箱（可选）';

  @override
  String get profileBirthDateOptional => '出生日期（可选）';

  @override
  String get profileVerifiedPhone => '已验证手机号';

  @override
  String get profileAccountStatus => '账户状态';

  @override
  String get profileAccountActive => '正常';

  @override
  String get profilePartnerIdentity => '合作身份';

  @override
  String get profileIdentityVerified => '合作身份已验证';

  @override
  String get profileIdentityNotVerified => '合作身份尚未验证';

  @override
  String get profileIdentityValidUntil => '有效期至';

  @override
  String get profileActivities => '合作活动与申请';

  @override
  String get profileNoActivities => '尚未登记任何活动。';

  @override
  String get profileAddActivity => '添加新活动';

  @override
  String get profileSave => '保存更改';

  @override
  String get profileSaved => '个人资料已保存。';

  @override
  String get profileSaveFailed => '无法保存个人资料。';

  @override
  String get profileLoadFailed => '无法加载个人资料。';

  @override
  String get profileInvalidEmail => '请输入有效的电子邮箱。';

  @override
  String get profileAvatarOptional => '头像为可选项。';

  @override
  String get profileRemoveAvatar => '删除照片';

  @override
  String get profileAvatarSaved => '头像已保存。';

  @override
  String get profileAvatarRemoved => '头像已删除。';

  @override
  String get profileAvatarUploadFailed => '无法保存头像。';

  @override
  String get profileImageTooLarge => '照片大小必须小于 2 MB。';

  @override
  String get profileUnsupportedImage => '照片格式必须为 JPEG、PNG 或 WebP。';

  @override
  String get registrationAvatarOptional => '头像（可选）';

  @override
  String get registrationAvatarUploadSkipped => '注册已完成，但头像上传失败。您可以稍后在个人资料中添加。';

  @override
  String get partnerApplicationRevision => '申请版本';

  @override
  String get partnerApplicationCorrectionTitle => '修改申请';

  @override
  String get partnerApplicationCorrectionInstructions =>
      '请根据审核意见修改信息和材料，然后重新提交申请。';

  @override
  String get partnerApplicationCorrectionNoteTitle => '需要修改的项目';

  @override
  String get partnerApplicationStartCorrection => '修改申请';

  @override
  String get partnerApplicationResubmitFinal => '重新提交申请';

  @override
  String get partnerApplicationResubmittedMessage => '修改后的申请已成功重新提交。';

  @override
  String get partnerApplicationHistoryResubmittedByApplicant =>
      '申请人已重新提交修改后的申请。';

  @override
  String get partnerSelectiveCorrectionTitle => '修改指定项目';

  @override
  String get partnerSelectiveCorrectionSubtitle => '本页面仅允许修改审核人员指定的项目。';

  @override
  String get partnerSelectiveCorrectionSelectedItems => '需要修改的项目';

  @override
  String get partnerSelectiveCorrectionOnlySelected => '请只修改下列项目，其他申请信息将保持不变。';

  @override
  String get partnerSelectiveCorrectionItemsUnavailable => '未收到修改项目列表，请刷新页面。';

  @override
  String get partnerSelectiveCorrectionNewFileRequired => '此项目必须上传新文件。';

  @override
  String get partnerSelectiveCorrectionOtherNotice =>
      '选择“其他”时会显示全部栏目，请只修改审核人员说明的内容。';

  @override
  String get partnerSelectiveCorrectionLivenessRequired => '尚未录制新的人脸活体验证视频。';

  @override
  String get partnerSelectiveCorrectionLivenessDone => '已录制新的人脸活体验证视频。';

  @override
  String get partnerSelectiveCorrectionLivenessAction => '重新录制活体验证视频';

  @override
  String get partnerSelectiveCorrectionMapRequired => '尚未确认新的地图位置。';

  @override
  String get partnerSelectiveCorrectionMapDone => '已确认新的地图位置。';

  @override
  String get partnerSelectiveCorrectionMapAction => '修改地图位置';

  @override
  String get partnerSelectiveCorrectionPostalLookupRequired =>
      '修改邮政编码后请重新查询地址。';

  @override
  String get partnerSelectiveCorrectionSelectionRequired => '请至少选择一种活动类型。';

  @override
  String get notificationsTitle => '通知';

  @override
  String get notificationsSubtitle => '在这里查看账户的最新动态和重要消息。';

  @override
  String get notificationsBack => '返回';

  @override
  String get notificationsUnread => '未读';

  @override
  String get notificationsMarkAllRead => '全部标为已读';

  @override
  String get notificationsEmpty => '暂无通知';

  @override
  String get notificationsEmptyDescription => '新通知和重要账户动态将显示在这里。';

  @override
  String get notificationsLoadFailed => '无法加载通知';

  @override
  String get notificationsLoadFailedDescription => '无法连接通知收件箱，请重试。';

  @override
  String get notificationsRefreshFailed => '无法刷新通知，当前显示之前加载的信息。';

  @override
  String get notificationsReadFailed => '无法将通知标记为已读。';

  @override
  String get notificationsMarkAllFailed => '无法将全部通知标记为已读。';

  @override
  String get notificationPartnerReviewStartedTitle => '申请审核已开始';

  @override
  String get notificationPartnerReviewStartedBody => '审核人员已开始审核您的合作申请。';

  @override
  String get notificationPartnerNeedsCorrectionTitle => '申请需要修改';

  @override
  String get notificationPartnerNeedsCorrectionBody => '请打开申请详情，查看并修改要求的项目。';

  @override
  String get notificationPartnerApprovedTitle => '合作申请已通过';

  @override
  String get notificationPartnerApprovedBody => '您的合作申请已成功通过审核。';

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
  String get notificationUnknownTitle => '新通知';

  @override
  String get notificationUnknownBody => '您的账户有一项新动态。';
}
