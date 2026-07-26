// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Super App';

  @override
  String get home => 'Home';

  @override
  String get phoneNumber => 'Mobile number';

  @override
  String get continueLabel => 'Continue';

  @override
  String get retry => 'Retry';

  @override
  String get unknownError => 'An unknown error occurred';

  @override
  String get getStarted => 'Get started';

  @override
  String get changeLanguage => 'Change language';

  @override
  String get onboardingSubtitle =>
      'Experience transportation, shopping, delivery, and everyday services more easily.';

  @override
  String get onboardingTitle => 'Every city service, in one Address';

  @override
  String get login => 'Login';

  @override
  String get welcome => 'Welcome';

  @override
  String get enteryourmobilenumber => 'Enter your mobile number';

  @override
  String get mobileNumber => 'Mobile number';

  @override
  String get enterMobileError => 'Please enter your mobile number';

  @override
  String get notDigits => 'Mobile number must contain only digits';

  @override
  String get invalidPrefix => 'Mobile number must start with \'09\' or \'9\'';

  @override
  String get enterMobileErrorWithZero =>
      'Mobile number must be 11 digits (with leading zero)';

  @override
  String get enterMobileErrorWithoutZero =>
      'Mobile number must be 10 digits (without leading zero)';

  @override
  String get tooShort => 'The entered number is too short';

  @override
  String get networkError => 'Network error, please check your connection';

  @override
  String enterOtpCode(Object phoneNumber) {
    return 'Enter the 5-digit code sent to $phoneNumber';
  }

  @override
  String didNotReceiveCode(Object seconds) {
    return 'I didn’t receive a code (00:$seconds)';
  }

  @override
  String get resendCode => 'Resend Code';

  @override
  String get changeNumber => 'Change number';

  @override
  String get or => 'Or';

  @override
  String get email => 'Email';

  @override
  String get enterFullOtpCode => 'Please enter the full 5-digit code';

  @override
  String get invalidOtpCode => 'The verification code is incorrect';

  @override
  String get expiredOtpCode =>
      'The verification code has expired. Request a new code';

  @override
  String get otpRequestTooSoon => 'Please wait before requesting another code';

  @override
  String get language => 'Language';

  @override
  String get logOut => 'Log out';

  @override
  String get services => 'Services';

  @override
  String get activity => 'Activity';

  @override
  String get messages => 'Messages';

  @override
  String get settings => 'Settings';

  @override
  String get sendGift => 'Send a gift';

  @override
  String get businessHub => 'Business hub';

  @override
  String get manageAddressAccount => 'Manage Address account';

  @override
  String get ride => 'Ride';

  @override
  String get deliver => 'Deliver';

  @override
  String get airport => 'Airport';

  @override
  String get bike => 'Bike';

  @override
  String get safeYourTrip => 'Travel safely';

  @override
  String get anywhereCityTrip => 'Anywhere in the city';

  @override
  String get cityOrIntercityTrip => 'City or intercity trip';

  @override
  String get fastAndSafe => 'Fast and safe';

  @override
  String get passengerServices => 'Passenger ';

  @override
  String get cargoServices => 'Cargo & Freight';

  @override
  String get foodServices => 'Food & Groceries';

  @override
  String get generalServices => 'General ';

  @override
  String get repairServices => 'Repair & Parts';

  @override
  String get insuranceServices => 'Address Partners';

  @override
  String get comingSoon => 'This section is coming soon.';

  @override
  String get logoutConfirmTitle => 'Log out';

  @override
  String get logoutConfirmMessage => 'Do you want to log out of your account?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Log out';

  @override
  String get addressUser => 'Address user';

  @override
  String get distributionOrders => 'Distribution orders';

  @override
  String get distributionOrderDetails => 'Order details';

  @override
  String get allOrders => 'All';

  @override
  String get confirmedOrders => 'Confirmed';

  @override
  String get receivedOrders => 'Received';

  @override
  String get filterByState => 'Filter by status';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get noDistributionOrders => 'No orders found';

  @override
  String get noDistributionOrdersDescription =>
      'There are no orders matching this filter.';

  @override
  String get distributionLoading => 'Loading orders...';

  @override
  String get distributionLoadError => 'Could not load orders';

  @override
  String get distributionNetworkError =>
      'Could not connect to the server. Check your network connection.';

  @override
  String get distributionServerError =>
      'The distribution service is temporarily unavailable.';

  @override
  String get distributionInvalidResponse =>
      'The distribution service returned an invalid response.';

  @override
  String get distributionOrderNotFound => 'The requested order was not found.';

  @override
  String get orderNumber => 'Order number';

  @override
  String get orderStatus => 'Order status';

  @override
  String get walletStatus => 'Wallet status';

  @override
  String get deliveryStatus => 'Delivery status';

  @override
  String get totalAmount => 'Total amount';

  @override
  String get plannedDelivery => 'Planned delivery';

  @override
  String get createdDate => 'Created';

  @override
  String get deliveryDriver => 'Delivery driver';

  @override
  String get deliveryTrip => 'Delivery trip';

  @override
  String get deliveryConfirmed => 'Delivery confirmed';

  @override
  String get deliveryProof => 'Delivery proof';

  @override
  String get orderProducts => 'Order items';

  @override
  String get quantity => 'Quantity';

  @override
  String get unitPrice => 'Unit price';

  @override
  String get finalUnitPrice => 'Final unit price';

  @override
  String get walletReservedAmount => 'Reserved amount';

  @override
  String get walletCapturedAmount => 'Captured amount';

  @override
  String get notAvailable => 'Not available';

  @override
  String get viewDetails => 'View details';

  @override
  String get stateDraft => 'Draft';

  @override
  String get stateConfirmed => 'Confirmed';

  @override
  String get stateReceived => 'Received';

  @override
  String get stateCancelled => 'Cancelled';

  @override
  String get walletPaid => 'Paid';

  @override
  String get walletReserved => 'Reserved';

  @override
  String get walletUnpaid => 'Unpaid';

  @override
  String get walletRefunded => 'Refunded';

  @override
  String get deliveryDelivered => 'Delivered';

  @override
  String get deliveryNone => 'No delivery';

  @override
  String get deliveryPending => 'Pending';

  @override
  String get deliveryAssigned => 'Assigned';

  @override
  String get deliveryInTransit => 'In transit';

  @override
  String get adminShopAccess => 'Shop access management';

  @override
  String get manageShopAccess => 'Grant or revoke shop access';

  @override
  String get adminShopAccessPrivacyNote =>
      'Full mobile numbers are used only for this request. The access list shows masked numbers.';

  @override
  String get shopId => 'Shop ID';

  @override
  String get optionalShopId => 'Shop ID (optional)';

  @override
  String get invalidShopId => 'Enter a valid positive Shop ID';

  @override
  String get invalidAdminMobile => 'Enter a valid Iranian mobile number';

  @override
  String get grantAccess => 'Grant access';

  @override
  String get revokeAccess => 'Revoke access';

  @override
  String get adminAccessGranted => 'Access granted';

  @override
  String get adminAccessRevoked => 'Access revoked';

  @override
  String get accessListFilters => 'Access list filters';

  @override
  String get applyFilters => 'Apply';

  @override
  String get includeInactiveAccess => 'Include inactive access';

  @override
  String get activeAccess => 'Active';

  @override
  String get inactiveAccess => 'Inactive';

  @override
  String get adminAccessLoading => 'Loading shop access...';

  @override
  String get noAdminShopAccess => 'No shop access found';

  @override
  String get noAdminShopAccessDescription =>
      'No access mapping matches the selected filters.';

  @override
  String get adminAccessForbiddenTitle => 'Administrator access required';

  @override
  String get adminAccessForbiddenMessage =>
      'This account is not allowed to manage shop access.';

  @override
  String get adminAccessLoadError => 'Could not load shop access';

  @override
  String get adminAccessUnauthorized =>
      'Your session is no longer valid. Sign in again.';

  @override
  String get adminAccessValidationError =>
      'The mobile number or Shop ID is invalid.';

  @override
  String get adminAccessNetworkError =>
      'Could not connect to the server. Check your network connection.';

  @override
  String get adminAccessServerError =>
      'The access-management service is temporarily unavailable.';

  @override
  String get adminAccessInvalidResponse =>
      'The access-management response could not be processed.';

  @override
  String get shopIdVerificationNote =>
      'Use a Shop ID verified in Odoo. The Gateway intentionally does not receive broad shop-directory permission.';

  @override
  String get partnerShop => 'Store and supermarket';

  @override
  String get addressPartnersIntro =>
      'Choose your partnership type. Registration, document review, and activation of the dedicated workspace will be added in the next stages.';

  @override
  String get partnerDistributor => 'Distribution company';

  @override
  String get partnerCarDriver => 'Car driver';

  @override
  String get partnerFoodBusiness => 'Restaurant, fast food, and catering';

  @override
  String get partnerMotorcycleDriver => 'Motorcycle driver';

  @override
  String get companyPharmaMedical => 'Pharmaceutical and medical supplies';

  @override
  String get storeBeautyHealth => 'Beauty and health store';

  @override
  String get foodBakeryDessert => 'Bread, pastry and dessert';

  @override
  String get storeBakeryPastry => 'Bakery and pastry shop';

  @override
  String get foodCatering => 'Catering and prepared food';

  @override
  String get otherHomeBuilding => 'Home and building services';

  @override
  String get driverVan => 'Van';

  @override
  String get partnerCategoryDriver => 'Driver';

  @override
  String get driverPickup => 'Pickup';

  @override
  String get otherTechnicalRepair => 'Technical and repair services';

  @override
  String get driverTractorTrailer => 'Tractor and trailer';

  @override
  String get companyBeautyHealth => 'Beauty and personal care products';

  @override
  String get foodIranian => 'Iranian restaurant';

  @override
  String get partnerCategoryOther => 'Other';

  @override
  String get driverLightTruck => 'Light truck';

  @override
  String get driverMotorcycle => 'Motorcycle';

  @override
  String get storeDairy => 'Dairy store';

  @override
  String get companyMotorcycleParts => 'Motorcycle spare parts';

  @override
  String get companyHeavyVehicleParts => 'Heavy vehicle spare parts';

  @override
  String get otherHospitality => 'Hotel, accommodation and tourism';

  @override
  String get partnersFormNextStage =>
      'The registration form for this group will be built in the next stage.';

  @override
  String get companyCleaning => 'Detergents and cleaning products';

  @override
  String get storeProtein => 'Meat and protein products store';

  @override
  String get foodFastFood => 'Fast food';

  @override
  String get partnerCategoryCompany => 'Company';

  @override
  String get partnersChooseSubcategory => 'Business activity';

  @override
  String get foodCafe => 'Cafe and coffee shop';

  @override
  String get driverPassengerCar => 'Passenger car';

  @override
  String get storeFruitVegetable => 'Fruit and vegetable store';

  @override
  String get partnersChooseCategory => 'Choose partnership type';

  @override
  String get partnersContinue => 'Continue';

  @override
  String get companyRetailEquipment => 'Retail equipment and supplies';

  @override
  String get otherEvents => 'Event and ceremony services';

  @override
  String get otherLaundry => 'Laundry and washing services';

  @override
  String get driverBus => 'Bus';

  @override
  String get storeSupermarket => 'Supermarket';

  @override
  String get storeGrocery => 'Grocery store';

  @override
  String get otherBeautyWellness => 'Beauty and wellness services';

  @override
  String get companyPackagingDisposable => 'Packaging and disposable products';

  @override
  String get driverTruck => 'Truck';

  @override
  String get companyLightVehicleParts => 'Light vehicle spare parts';

  @override
  String get companyFoodBeverage => 'Food and beverages';

  @override
  String get partnersSingleSelection => 'Choose one';

  @override
  String get partnerCategoryStore => 'Store';

  @override
  String get foodHealthyDiet => 'Healthy and diet food';

  @override
  String get partnerCategoryFood => 'Food';

  @override
  String get otherBusiness => 'Other businesses';

  @override
  String get driverMinibus => 'Minibus';

  @override
  String get foodInternational => 'International restaurant';

  @override
  String get partnersMultipleSelection => 'Multiple selection';

  @override
  String get foodSeafood => 'Seafood restaurant';

  @override
  String get partnersStartOver => 'Start over';

  @override
  String get partnersSelected => 'Selected';

  @override
  String get partnersSecondaryActivities => 'Secondary activities';

  @override
  String get partnersQuestionTitle => 'Which category describes your business?';

  @override
  String get storeSupermarketDescription => 'Everyday consumer goods';

  @override
  String get partnersSelect => 'Select';

  @override
  String get partnersSummaryReadyTitle => 'Your business profile is ready!';

  @override
  String get storeDairyDescription => 'Milk and dairy products';

  @override
  String get partnersMainCategory => 'Main category';

  @override
  String get partnerGroupOtherSubtitle =>
      'Specialized and hospitality services';

  @override
  String get partnerGroupCompaniesSubtitle =>
      'Wholesale supply and distribution';

  @override
  String get partnersRegistrationNext =>
      'The registration and submission form will be connected in the next stage.';

  @override
  String get partnerGroupFoodSubtitle => 'Restaurants, cafes and prepared food';

  @override
  String get foodCateringDescription => 'Catering and prepared orders';

  @override
  String get storeBakeryPastryDescription => 'Bread and pastries';

  @override
  String get partnerGroupCompanies => 'Companies and suppliers';

  @override
  String get foodInternationalDescription => 'International cuisine';

  @override
  String get partnersBrandSubtitle =>
      'Business registration and category selection';

  @override
  String get partnerGroupDrivers => 'Drivers and fleet';

  @override
  String get partnersPrimaryBadge => 'Primary';

  @override
  String partnersSubcategoryCount(int count) {
    return '$count subcategories';
  }

  @override
  String get partnersNothingSelected => 'Nothing selected yet';

  @override
  String get partnersCompleteRegistration => 'Complete registration form';

  @override
  String get partnersPrimaryActivity => 'Primary activity';

  @override
  String get partnersPrimarySummaryBadge => 'Primary';

  @override
  String get partnerGroupStores => 'Stores';

  @override
  String get storeFruitVegetableDescription => 'Fresh fruit and vegetables';

  @override
  String get partnersStepConfirm => 'Final confirmation';

  @override
  String get partnerGroupDriversSubtitle => 'Transport and logistics';

  @override
  String partnersSelectionCount(int count) {
    return '$count selected';
  }

  @override
  String get partnersDriverCompany => 'Transport company';

  @override
  String get storeBeautyHealthDescription => 'Beauty and personal care';

  @override
  String get partnersVersionLabel => 'Version 1.0';

  @override
  String get partnersViewSummary => 'View summary';

  @override
  String get foodBakeryDessertDescription => 'Bread, pastry and desserts';

  @override
  String get foodSeafoodDescription => 'Seafood dishes';

  @override
  String get partnersHintDriverPersonal =>
      'As an individual driver, choose one primary vehicle.';

  @override
  String get partnersOneItem => '(one item)';

  @override
  String get partnersSelectedOptions => 'Selected options';

  @override
  String get partnersSummaryReadySubtitle =>
      'Summary of your choices in Address';

  @override
  String get partnersDriverPersonal => 'Individual driver';

  @override
  String get storeGroceryDescription => 'Groceries and ingredients';

  @override
  String get foodCafeDescription => 'Coffee and beverages';

  @override
  String get partnersHintMultiple => 'You can select multiple options.';

  @override
  String get foodIranianDescription => 'Traditional Iranian cuisine';

  @override
  String get foodFastFoodDescription => 'Quick-service food';

  @override
  String get partnersQuestionSubtitle =>
      'Choose one of the five main groups to view related subcategories.';

  @override
  String get partnersMainVehicle => 'Primary vehicle';

  @override
  String get partnerGroupOther => 'Other services';

  @override
  String get partnersStepDetails => 'Activity details';

  @override
  String get foodHealthyDietDescription => 'Healthy and diet meals';

  @override
  String get partnerGroupStoresSubtitle => 'Direct retail sales to customers';

  @override
  String get partnersStepCategory => 'Main category';

  @override
  String get partnersHintDriverCompany =>
      'As a transport company, you can register multiple vehicle types.';

  @override
  String get partnerGroupFood => 'Food and catering';

  @override
  String get storeProteinDescription => 'Meat and protein products';

  @override
  String get partnersHintPrimarySecondary =>
      'Choose one primary activity, then add optional secondary activities.';

  @override
  String get partnersBack => 'Back';

  @override
  String get partnersBrandTitle => 'Address Partners';

  @override
  String get partnersFleetTypes => 'Fleet types';

  @override
  String get partnersSupport => 'Support';

  @override
  String get partnersSupportSubtitle => 'Always by your side';

  @override
  String get partnerRegistrationStart => 'Start registration';

  @override
  String get partnerRegistrationContinue => 'Continue';

  @override
  String get partnerRegistrationApplicantTypeTitle => 'Choose applicant type';

  @override
  String get partnerRegistrationApplicantTypeSubtitle =>
      'Choose whether the application is for an individual or a legal business.';

  @override
  String get partnerRegistrationIndividual => 'Individual';

  @override
  String get partnerRegistrationIndividualDescription =>
      'Register the application under a person';

  @override
  String get partnerRegistrationLegalEntity => 'Company or legal business';

  @override
  String get partnerRegistrationLegalEntityDescription =>
      'Register using the official company information';

  @override
  String get partnerRegistrationBasicInfoTitle => 'Basic information';

  @override
  String get partnerRegistrationBasicInfoSubtitle =>
      'Enter the applicant identity and contact information.';

  @override
  String get partnerRegistrationFullName => 'Full name';

  @override
  String get partnerRegistrationCompanyName =>
      'Official company or business name';

  @override
  String get partnerRegistrationRepresentativeName =>
      'Responsible representative';

  @override
  String get partnerRegistrationNationalId => 'National ID';

  @override
  String get partnerRegistrationCompanyNationalId => 'Company national ID';

  @override
  String get partnerRegistrationMobile => 'Mobile number';

  @override
  String get partnerRegistrationEmailOptional => 'Email (optional)';

  @override
  String get partnerRegistrationRequiredField => 'This field is required';

  @override
  String get partnerRegistrationInvalidMobile => 'Enter a valid mobile number';

  @override
  String get partnerRegistrationBasicInfoSaved =>
      'Basic information was saved. Business information is the next step.';

  @override
  String get partnerRegistrationBusinessInfoTitle => 'Business information';

  @override
  String get partnerRegistrationBusinessInfoSubtitle =>
      'Enter the activity name, services, and work experience.';

  @override
  String get partnerRegistrationBusinessName => 'Business or activity name';

  @override
  String get partnerRegistrationBusinessDescription =>
      'Short description of products or services';

  @override
  String get partnerRegistrationExperienceYears =>
      'Years of experience (optional)';

  @override
  String get partnerRegistrationSaveBusinessInfo => 'Save information';

  @override
  String get partnerRegistrationBusinessInfoSaved =>
      'Business information was saved in the draft.';

  @override
  String get partnerRegistrationIndividualFormTitle =>
      'Individual registration form';

  @override
  String get partnerRegistrationLegalFormTitle => 'Company registration form';

  @override
  String get partnerRegistrationFormSubtitle =>
      'Enter identity and business information in this form.';

  @override
  String get partnerRegistrationSubmitApplication => 'Submit application';

  @override
  String get partnerRegistrationDraftSaved =>
      'The form was saved successfully as a draft.';

  @override
  String get partnerRegistrationPersonalInformationTitle =>
      'Personal information';

  @override
  String get partnerRegistrationCompanyInformationTitle =>
      'Company information';

  @override
  String get partnerRegistrationPersonalInformationSubtitle =>
      'Enter identity and contact information.';

  @override
  String get partnerRegistrationRepresentativeNationalId =>
      'Representative national ID';

  @override
  String get partnerRegistrationCompanyLandline => 'Company landline';

  @override
  String get partnerRegistrationLandlineOptional => 'Landline (optional)';

  @override
  String get partnerRegistrationInvalidNationalId =>
      'The national ID must contain 10 digits.';

  @override
  String get partnerRegistrationInvalidCompanyNationalId =>
      'The company national ID must contain 11 digits.';

  @override
  String get partnerRegistrationInvalidIranianMobile =>
      'The mobile number must start with 09 and contain 11 digits.';

  @override
  String get partnerRegistrationInvalidLandline =>
      'Enter an 11-digit landline including the area code.';

  @override
  String get partnerRegistrationContinueToStore =>
      'Continue to store information';

  @override
  String get partnerRegistrationStoreInformationTitle => 'Store information';

  @override
  String get partnerRegistrationStoreInformationSubtitle =>
      'Enter workplace details and the required images.';

  @override
  String get partnerRegistrationStoreName => 'Store name';

  @override
  String get partnerRegistrationStoreOwnership => 'Store ownership';

  @override
  String get partnerRegistrationOwnershipOwner => 'Owner';

  @override
  String get partnerRegistrationOwnershipTenant => 'Tenant';

  @override
  String get partnerRegistrationOwnershipGoodwill => 'Goodwill';

  @override
  String get partnerRegistrationOwnershipOther => 'Other';

  @override
  String get partnerRegistrationStorePhone => 'Store landline';

  @override
  String get partnerRegistrationPostalCode => 'Postal code';

  @override
  String get partnerRegistrationStoreArea => 'Store area (square meters)';

  @override
  String get partnerRegistrationStoreAddress => 'Full store address';

  @override
  String get partnerRegistrationBusinessDescriptionOptional =>
      'Short business description (optional)';

  @override
  String get partnerRegistrationLicenseImage => 'Business license image';

  @override
  String get partnerRegistrationLicenseImageOptional =>
      'Optional; tap to choose an image.';

  @override
  String get partnerRegistrationSignboardImage => 'Store signboard image';

  @override
  String get partnerRegistrationSignboardImageRequired =>
      'Required; tap to choose an image.';

  @override
  String get partnerRegistrationSignboardImageValidation =>
      'The store signboard image is required.';

  @override
  String get partnerRegistrationInvalidPostalCode =>
      'The postal code must contain 10 digits.';

  @override
  String get partnerRegistrationInvalidStoreArea =>
      'The store area must be greater than zero.';

  @override
  String get partnerRegistrationDraftCompletedTitle => 'Information saved';

  @override
  String get partnerRegistrationDraftCompletedMessage =>
      'The information is stored as a draft. Server submission will be connected in the next phase.';

  @override
  String get partnerRegistrationDialogConfirm => 'OK';

  @override
  String get partnerVerificationOwnerTitle =>
      'Business owner identity verification';

  @override
  String get partnerVerificationLegalOwnerTitle =>
      'Company representative verification';

  @override
  String get partnerVerificationOwnerSubtitle =>
      'Enter the national ID and mobile number registered to the business owner or company representative.';

  @override
  String get partnerVerificationOwnerMobile => 'Business owner mobile number';

  @override
  String get partnerVerificationConsent =>
      'I consent to identity verification and processing for this partner application.';

  @override
  String get partnerVerificationConsentRequired =>
      'Consent is required before identity verification.';

  @override
  String get partnerVerificationLookupIdentity => 'Verify identity information';

  @override
  String get partnerVerificationIdentityResultTitle =>
      'Retrieved identity information';

  @override
  String get partnerVerificationMobileMatched =>
      'The mobile number ownership matches the national ID.';

  @override
  String get partnerVerificationMobileMismatch =>
      'The mobile number does not belong to this national ID.';

  @override
  String get partnerVerificationFatherName => 'Father\'s name';

  @override
  String get partnerVerificationBirthDate => 'Birth date';

  @override
  String get partnerVerificationConfirmAccuracy =>
      'I confirm that the displayed information is correct.';

  @override
  String get partnerVerificationAccuracyRequired =>
      'Confirm the displayed information before continuing.';

  @override
  String get partnerVerificationConfirmAndContinue => 'Confirm and continue';

  @override
  String get partnerVerificationPostalLookup => 'Get address from postal code';

  @override
  String get partnerVerificationPostalResultTitle => 'Retrieved postal address';

  @override
  String get partnerVerificationMapConfirmationPending =>
      'The exact store location will be confirmed on the map in the next phase.';

  @override
  String get partnerVerificationPostalLookupRequired =>
      'Look up the postal address before submitting.';

  @override
  String get partnerVerificationNextLivenessMessage =>
      'Identity and postal information were saved in the draft. Video liveness and map confirmation will be added in the next phase.';

  @override
  String get partnerRegistrationFinalConfirm => 'Confirm';

  @override
  String get partnerLivenessTitle => 'Video identity verification';

  @override
  String get partnerLivenessSubtitle =>
      'After consent, the front camera will start. Read the displayed phrase clearly.';

  @override
  String get partnerLivenessPhraseTitle => 'Verification phrase';

  @override
  String get partnerLivenessConsent =>
      'I consent to video recording and processing for business-owner identity verification.';

  @override
  String get partnerLivenessConsentRequired =>
      'Video consent is required before the camera can start.';

  @override
  String get partnerLivenessCameraUnavailable =>
      'The front camera is unavailable, or camera and microphone permissions were not granted.';

  @override
  String get partnerLivenessRecordInstruction =>
      'Tap the camera button and read the phrase clearly.';

  @override
  String get partnerLivenessRecordingInstruction =>
      'Recording is in progress. Read the complete phrase clearly.';

  @override
  String get partnerLivenessStartRecording => 'Start video recording';

  @override
  String get partnerLivenessStopRecording => 'Stop video recording';

  @override
  String get partnerLivenessRecordingFailed =>
      'The video could not be recorded. Try again.';

  @override
  String get partnerLivenessPreviewTitle => 'Video preview';

  @override
  String get partnerLivenessRetake => 'Record again';

  @override
  String get partnerLivenessVerificationFailed =>
      'Video verification failed. Record the video again.';

  @override
  String get partnerMapConfirmationRequired =>
      'Confirm the store location on the map first.';

  @override
  String get partnerMapConfirmed => 'Store location confirmed';

  @override
  String get partnerMapOpen => 'Confirm location on map';

  @override
  String get partnerMapConfirmInstruction =>
      'Press the arrow button to save this location.';

  @override
  String get partnerMapHint => 'The pin is fixed; move the map underneath it.';

  @override
  String get partnerMapTitle => 'Confirm store location';

  @override
  String get partnerMapSubtitle =>
      'Move the map until the pin is exactly over the store.';

  @override
  String get partnerMapCoordinatesUnavailable =>
      'Initial coordinates are unavailable.';

  @override
  String get partnerRegistrationImageSourceGallery => 'Gallery';

  @override
  String get partnerRegistrationImageSourceCamera => 'Camera';

  @override
  String get partnerRegistrationImageSourceTitle => 'Choose image source';

  @override
  String get partnerIdentityResultPageTitle => 'Identity inquiry result';

  @override
  String get partnerIdentityResultMatchedSubtitle =>
      'Identity information was received and the mobile number matches the national ID.';

  @override
  String get partnerIdentityResultMismatchSubtitle =>
      'The mobile number does not match the national ID. Edit the information and try again.';

  @override
  String get partnerIdentityEditInformation => 'Edit information';

  @override
  String get partnerIdentityNationalCardImage =>
      'Applicant national ID card image';

  @override
  String get partnerIdentityNationalCardImageRequiredSubtitle =>
      'Required; the image must be captured live with the camera.';

  @override
  String get partnerIdentityNationalCardImageValidation =>
      'A live image of the applicant\'s national ID card is required.';

  @override
  String get partnerIdentityNationalCardCameraTitle =>
      'Capture national ID card';

  @override
  String get partnerIdentityNationalCardCameraInstruction =>
      'Place the entire card flat and clearly inside the frame.';

  @override
  String get partnerDocumentCameraUnavailable =>
      'The camera is unavailable or camera permission was not granted.';

  @override
  String get partnerDocumentCaptureFailed =>
      'The image could not be captured. Try again.';

  @override
  String get partnerLivenessProcessingVideo => 'Preparing the video preview...';

  @override
  String get partnerOwnershipDocumentImage =>
      'Ownership deed, lease, or goodwill document image';

  @override
  String get partnerOwnershipDocumentImageRequired =>
      'Required; tap to add an image.';

  @override
  String get partnerOwnershipDocumentImageValidation =>
      'An ownership deed, lease, or goodwill document image is required.';

  @override
  String get partnerSignboardCameraInstruction =>
      'Place the entire store sign clearly inside the frame.';

  @override
  String get partnerLicenseCameraInstruction =>
      'Place the entire activity license flat and clearly inside the frame.';

  @override
  String get partnerOwnershipDocumentCameraInstruction =>
      'Place the main page of the deed, lease, or goodwill document clearly inside the frame.';

  @override
  String get partnerApplicationSubmitFinal => 'Submit application';

  @override
  String get partnerApplicationReviewTitle => 'Review partner application';

  @override
  String get partnerApplicationReviewSubtitle =>
      'Review the information before submission. A tracking code will be issued after registration.';

  @override
  String get partnerApplicationActivitySection => 'Partnership type';

  @override
  String get partnerApplicationCategory => 'Activity group';

  @override
  String get partnerApplicationApplicantType => 'Applicant type';

  @override
  String get partnerApplicationIdentitySection => 'Identity information';

  @override
  String get partnerApplicationApplicantName => 'Applicant name';

  @override
  String get partnerApplicationStoreSection => 'Business location';

  @override
  String get partnerApplicationMapStatus => 'Location status';

  @override
  String get partnerApplicationMapConfirmed => 'Map location confirmed';

  @override
  String get partnerApplicationMapNotConfirmed => 'Map location not confirmed';

  @override
  String get partnerApplicationDocumentsSection => 'Verification and documents';

  @override
  String get partnerApplicationVerified => 'Verified';

  @override
  String get partnerApplicationSubmissionNotice =>
      'Submitting registers the information for review by the Address partnership team.';

  @override
  String get partnerApplicationSuccessTitle => 'Partner application submitted';

  @override
  String get partnerApplicationSuccessMessage =>
      'Your application was submitted successfully. Keep the tracking code below.';

  @override
  String get partnerApplicationAlreadySubmittedMessage =>
      'This application was already submitted and the same tracking code was restored.';

  @override
  String get partnerApplicationViewMyApplications => 'My partner applications';

  @override
  String get partnerApplicationTrackingCode => 'Tracking code';

  @override
  String get partnerApplicationCopyTrackingCode => 'Copy tracking code';

  @override
  String get partnerApplicationTrackingCodeCopied => 'Tracking code copied.';

  @override
  String get partnerApplicationStatusSubmitted => 'Submitted';

  @override
  String get partnerApplicationStatusUnderReview => 'Under review';

  @override
  String get partnerApplicationStatusNeedsCorrection => 'Needs correction';

  @override
  String get partnerApplicationStatusApproved => 'Approved';

  @override
  String get partnerApplicationStatusRejected => 'Rejected';

  @override
  String get partnerApplicationStatusUnknown => 'Unknown';

  @override
  String get partnerApplicationsTitle => 'My partner applications';

  @override
  String get partnerApplicationsSubtitle =>
      'View and track your submitted partnership requests.';

  @override
  String get partnerApplicationsEmpty =>
      'You have not submitted a partner application yet.';

  @override
  String get partnerApplicationRetry => 'Try again';

  @override
  String get partnerApplicationDetailsTitle => 'Partner application details';

  @override
  String get partnerApplicationCurrentStatus => 'Current status';

  @override
  String get partnerApplicationSubmittedAt => 'Submitted at';

  @override
  String get partnerApplicationStatusHistory => 'Status history';

  @override
  String get partnerApplicationNoStatusHistory =>
      'No status history is available for this application.';

  @override
  String get partnerApplicationFormIncomplete =>
      'Please correct the incomplete or invalid form fields.';

  @override
  String get partnerApplicationVerificationExpired =>
      'Identity or liveness verification is incomplete. Restart the registration from the verification step.';

  @override
  String get partnerApplicationUnexpectedFailure =>
      'An unexpected error occurred while submitting the application. Please try again.';

  @override
  String get authEntryTitle => 'Sign in or register';

  @override
  String get authEntrySubtitle =>
      'Enter your mobile number to sign in or create an account';

  @override
  String get registrationTitle => 'Complete Address registration';

  @override
  String get registrationSubtitle =>
      'Enter your basic information and choose how to start.';

  @override
  String get registrationFirstName => 'First name';

  @override
  String get registrationLastName => 'Last name';

  @override
  String get registrationVerifiedPhone => 'Verified mobile number';

  @override
  String get registrationStartQuestion => 'How would you like to start?';

  @override
  String get registrationServicesTitle => 'Use Address services';

  @override
  String get registrationServicesSubtitle =>
      'Taxi, shopping, delivery, booking, and city services';

  @override
  String get registrationPartnerTitle => 'Partner with Address';

  @override
  String get registrationPartnerSubtitle =>
      'Store, driver, supplier, and other partnerships';

  @override
  String get registrationTermsAcceptance =>
      'I accept the Address terms of use and privacy policy.';

  @override
  String get registrationAction => 'Complete registration';

  @override
  String get registrationChangePhone => 'Change mobile number';

  @override
  String get registrationExitAction => 'Cancel registration';

  @override
  String get registrationExitTitle => 'Exit registration?';

  @override
  String get registrationExitMessage =>
      'Your registration is not complete. If you exit, the information entered on this page will not be saved, and you can register again later.';

  @override
  String get registrationExitContinue => 'Continue registration';

  @override
  String get registrationExitConfirm => 'Exit registration';

  @override
  String get registrationTermsRequired =>
      'You must accept the terms and privacy policy to continue.';

  @override
  String get registrationNameValidation =>
      'This field must contain at least two characters.';

  @override
  String get registrationSessionExpired =>
      'Your sign-in session is invalid. Please sign in again.';

  @override
  String get registrationTryAgainLater => 'Please try again shortly.';

  @override
  String get registrationSubmitFailed =>
      'Registration could not be completed. Please try again.';

  @override
  String get partnerApplicationHistorySubmittedByApplicant =>
      'The application was submitted by the applicant.';

  @override
  String get partnerReusableIdentityBannerTitle =>
      'Your identity has already been verified';

  @override
  String get partnerReusableIdentityBannerSubtitle =>
      'For this new activity, your verified identity and liveness data will be reused. Only activity-specific information is required.';

  @override
  String get profileTitle => 'My profile';

  @override
  String get profileSubtitle =>
      'Manage your account information and partner activities.';

  @override
  String get profilePersonalInfo => 'Personal information';

  @override
  String get profileEmailOptional => 'Email (optional)';

  @override
  String get profileBirthDateOptional => 'Birth date (optional)';

  @override
  String get profileVerifiedPhone => 'Verified mobile number';

  @override
  String get profileAccountStatus => 'Account status';

  @override
  String get profileAccountActive => 'Active';

  @override
  String get profilePartnerIdentity => 'Partner identity';

  @override
  String get profileIdentityVerified => 'Partner identity is verified';

  @override
  String get profileIdentityNotVerified =>
      'Partner identity is not verified yet';

  @override
  String get profileIdentityValidUntil => 'Valid until';

  @override
  String get profileActivities => 'Partner activities and applications';

  @override
  String get profileNoActivities => 'No activity has been registered yet.';

  @override
  String get profileAddActivity => 'Add a new activity';

  @override
  String get profileSave => 'Save changes';

  @override
  String get profileSaved => 'Profile saved successfully.';

  @override
  String get profileSaveFailed => 'Could not save the profile.';

  @override
  String get profileLoadFailed => 'Could not load the profile.';

  @override
  String get profileInvalidEmail => 'Enter a valid email address.';

  @override
  String get profileAvatarOptional => 'Profile photo is optional.';

  @override
  String get profileRemoveAvatar => 'Remove photo';

  @override
  String get profileAvatarSaved => 'Profile photo saved.';

  @override
  String get profileAvatarRemoved => 'Profile photo removed.';

  @override
  String get profileAvatarUploadFailed => 'Could not save the profile photo.';

  @override
  String get profileImageTooLarge => 'The photo must be smaller than 2 MB.';

  @override
  String get profileUnsupportedImage => 'The photo must be JPEG, PNG, or WebP.';

  @override
  String get registrationAvatarOptional => 'Profile photo (optional)';

  @override
  String get registrationAvatarUploadSkipped =>
      'Registration completed, but the profile photo could not be uploaded. You can add it later from your profile.';

  @override
  String get partnerApplicationRevision => 'Application revision';

  @override
  String get partnerApplicationCorrectionTitle => 'Correct application';

  @override
  String get partnerApplicationCorrectionInstructions =>
      'Update the information and documents according to the reviewer note, then resubmit the application.';

  @override
  String get partnerApplicationCorrectionNoteTitle =>
      'Items requiring correction';

  @override
  String get partnerApplicationStartCorrection => 'Correct application';

  @override
  String get partnerApplicationResubmitFinal => 'Resubmit application';

  @override
  String get partnerApplicationResubmittedMessage =>
      'The corrected application was resubmitted successfully.';

  @override
  String get partnerApplicationHistoryResubmittedByApplicant =>
      'The corrected application was resubmitted by the applicant.';

  @override
  String get partnerSelectiveCorrectionTitle => 'Correct selected items';

  @override
  String get partnerSelectiveCorrectionSubtitle =>
      'Only the items selected by the reviewer can be edited on this page.';

  @override
  String get partnerSelectiveCorrectionSelectedItems =>
      'Items selected for correction';

  @override
  String get partnerSelectiveCorrectionOnlySelected =>
      'Correct only the items below. All other application data will remain unchanged.';

  @override
  String get partnerSelectiveCorrectionItemsUnavailable =>
      'The correction item list was not received. Refresh the page.';

  @override
  String get partnerSelectiveCorrectionNewFileRequired =>
      'A new file is required for this item.';

  @override
  String get partnerSelectiveCorrectionOtherNotice =>
      'For “Other”, all sections are shown. Change only the item described by the reviewer.';

  @override
  String get partnerSelectiveCorrectionLivenessRequired =>
      'A new liveness video has not been recorded yet.';

  @override
  String get partnerSelectiveCorrectionLivenessDone =>
      'The new liveness video was recorded.';

  @override
  String get partnerSelectiveCorrectionLivenessAction =>
      'Record liveness video again';

  @override
  String get partnerSelectiveCorrectionMapRequired =>
      'The new map location has not been confirmed yet.';

  @override
  String get partnerSelectiveCorrectionMapDone =>
      'The new map location was confirmed.';

  @override
  String get partnerSelectiveCorrectionMapAction => 'Correct map location';

  @override
  String get partnerSelectiveCorrectionPostalLookupRequired =>
      'Look up the address after changing the postal code.';

  @override
  String get partnerSelectiveCorrectionSelectionRequired =>
      'Select at least one activity type.';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsSubtitle =>
      'View the latest updates and important account messages here.';

  @override
  String get notificationsBack => 'Back';

  @override
  String get notificationsUnread => 'Unread';

  @override
  String get notificationsMarkAllRead => 'Mark all read';

  @override
  String get notificationsEmpty => 'No notifications';

  @override
  String get notificationsEmptyDescription =>
      'New notifications and important account updates will appear here.';

  @override
  String get notificationsLoadFailed => 'Could not load notifications';

  @override
  String get notificationsLoadFailedDescription =>
      'The notification inbox could not be reached. Try again.';

  @override
  String get notificationsRefreshFailed =>
      'Notifications could not be refreshed. Previously loaded information is shown.';

  @override
  String get notificationsReadFailed =>
      'The notification could not be marked as read.';

  @override
  String get notificationsMarkAllFailed =>
      'Notifications could not be marked as read.';

  @override
  String get notificationPartnerReviewStartedTitle =>
      'Application review started';

  @override
  String get notificationPartnerReviewStartedBody =>
      'A reviewer has started reviewing your partner application.';

  @override
  String get notificationPartnerNeedsCorrectionTitle =>
      'Application needs correction';

  @override
  String get notificationPartnerNeedsCorrectionBody =>
      'Open the application details to review and correct the requested items.';

  @override
  String get notificationPartnerApprovedTitle => 'Partner application approved';

  @override
  String get notificationPartnerApprovedBody =>
      'Your partner application has been approved successfully.';

  @override
  String get notificationPartnerRejectedTitle => 'Partner application rejected';

  @override
  String get notificationPartnerRejectedBody =>
      'Open the application details to review the rejection reason.';

  @override
  String get partnerApplicationRejectionReasonTitle => 'Final rejection reason';

  @override
  String get partnerApplicationRejectionReasonFallback =>
      'The rejection reason is not available yet. Refresh the page.';

  @override
  String get notificationUnknownTitle => 'New notification';

  @override
  String get notificationUnknownBody =>
      'A new update was recorded for your account.';
}
