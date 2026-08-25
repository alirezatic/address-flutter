abstract final class AppRoutePaths {
  static const String root = '/';
  static const String onboarding = '/onboarding';
  static const String registration = '/registration';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String notifications = '/notifications';
  static const String distributionOrders = '/distribution/orders';
  static const String distributionOrderDetails = '/distribution/order';
  static const String adminShopAccess = '/admin/shop-access';
  static const String addressPartners = '/partners';
  static const String addressPartnerCategory = '/partners/category/:categoryId';
  static const String addressPartnersSummary = '/partners/summary';
  static const String partnerRegistrationApplicantType =
      '/partners/registration/applicant-type';
  static const String partnerRegistrationBasicInfo =
      '/partners/registration/basic-info';
  static const String partnerRegistrationIdentityResult =
      '/partners/registration/identity-result';
  static const String partnerRegistrationLiveness =
      '/partners/registration/liveness';
  static const String partnerRegistrationApplicantDetails =
      '/partners/registration/applicant-details';
  static const String partnerRegistrationStoreInfo =
      '/partners/registration/store-info';
  static const String partnerRegistrationMapConfirmation =
      '/partners/registration/map-confirmation';

  static const String partnerApplicationCorrection =
      '/partners/registration/correction';
  static const String partnerApplications = '/partners/applications';
  static const String partnerApplicationDetails =
      '/partners/applications/:applicationId';

  static String addressPartnerCategoryLocation(String categoryId) {
    return '/partners/category/$categoryId';
  }

  static String partnerApplicationDetailsLocation(String applicationId) {
    return '/partners/applications/$applicationId';
  }
}
