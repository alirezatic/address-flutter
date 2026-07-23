import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import 'package:address/app/route_paths.dart';
import 'package:address/features/admin_shop_access/presentation/screens/admin_shop_access_screen.dart';
import 'package:address/features/auth/application/auth_session_controller.dart';
import 'package:address/features/auth/presentation/screens/registration_screen.dart';
import 'package:address/features/capabilities/presentation/controllers/user_capabilities_controller.dart';
import 'package:address/features/distribution/presentation/screens/distribution_order_details_screen.dart';
import 'package:address/features/distribution/presentation/screens/distribution_orders_screen.dart';
import 'package:address/features/home/presentation/screens/home_screen.dart';
import 'package:address/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:address/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:address/features/partner_registration/domain/models/partner_registration_draft.dart';
import 'package:address/features/partner_registration/presentation/screens/partner_applicant_type_screen.dart';
import 'package:address/features/partner_registration/presentation/screens/partner_application_correction_screen.dart';
import 'package:address/features/partner_registration/presentation/screens/partner_application_details_screen.dart';
import 'package:address/features/partner_registration/presentation/screens/partner_applications_screen.dart';
import 'package:address/features/partner_registration/presentation/screens/partner_basic_info_screen.dart';
import 'package:address/features/partner_registration/presentation/screens/partner_identity_result_screen.dart';
import 'package:address/features/partner_registration/presentation/screens/partner_liveness_screen.dart';
import 'package:address/features/partner_registration/presentation/screens/partner_map_confirmation_screen.dart';
import 'package:address/features/partner_registration/presentation/screens/partner_store_info_screen.dart';
import 'package:address/features/partners/domain/models/partner_category.dart';
import 'package:address/features/partners/presentation/screens/address_partners_screen.dart';
import 'package:address/features/partners/presentation/screens/partner_category_screen.dart';
import 'package:address/features/partners/presentation/screens/partner_summary_screen.dart';
import 'package:address/features/profile/presentation/screens/profile_screen.dart';

abstract final class AppRouter {
  static const String rootPath = AppRoutePaths.root;
  static const String onboardingPath = AppRoutePaths.onboarding;
  static const String homePath = AppRoutePaths.home;
  static const String profilePath = AppRoutePaths.profile;
  static const String notificationsPath = AppRoutePaths.notifications;
  static const String registrationPath = AppRoutePaths.registration;
  static const String distributionOrdersPath = AppRoutePaths.distributionOrders;
  static const String distributionOrderDetailsPath =
      AppRoutePaths.distributionOrderDetails;
  static const String adminShopAccessPath = AppRoutePaths.adminShopAccess;
  static const String addressPartnersPath = AppRoutePaths.addressPartners;

  static final AuthSessionController _authSession =
      AuthSessionController.instance;
  static final UserCapabilitiesController _capabilities =
      UserCapabilitiesController.instance;

  static final GoRouter router = GoRouter(
    initialLocation: rootPath,
    refreshListenable: Listenable.merge(<Listenable>[
      _authSession,
      _capabilities,
    ]),
    redirect: (context, state) async {
      final location = state.matchedLocation;

      if (!_authSession.isAuthenticated) {
        _capabilities.clear();

        if (location == onboardingPath) {
          return null;
        }

        return onboardingPath;
      }

      if (!_authSession.isRegistrationComplete) {
        return location == registrationPath ? null : registrationPath;
      }

      if (location == rootPath || location == onboardingPath) {
        return homePath;
      }

      if (location == registrationPath) {
        return null;
      }

      if (location == adminShopAccessPath) {
        await _capabilities.ensureLoaded();

        if (!_capabilities.isAdmin) {
          return homePath;
        }
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: rootPath,
        redirect: (context, state) {
          if (!_authSession.isAuthenticated) {
            return onboardingPath;
          }

          return _authSession.isRegistrationComplete
              ? homePath
              : registrationPath;
        },
      ),
      GoRoute(
        path: onboardingPath,
        builder: (context, state) {
          return OnboardingScreen(onAuthenticated: _authSession.signIn);
        },
      ),
      GoRoute(
        path: registrationPath,
        builder: (context, state) => const RegistrationScreen(),
      ),
      GoRoute(path: homePath, builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: notificationsPath,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: profilePath,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: distributionOrdersPath,
        builder: (context, state) => const DistributionOrdersScreen(),
      ),
      GoRoute(
        path: distributionOrderDetailsPath,
        builder: (context, state) {
          return DistributionOrderDetailsScreen(
            orderName: state.uri.queryParameters['name'] ?? '',
          );
        },
      ),
      GoRoute(
        path: addressPartnersPath,
        builder: (context, state) => const AddressPartnersScreen(),
      ),
      GoRoute(
        path: AppRoutePaths.addressPartnerCategory,
        redirect: (context, state) {
          final value = state.pathParameters['categoryId'];
          return value == null || PartnerCategoryId.tryParse(value) == null
              ? addressPartnersPath
              : null;
        },
        builder: (context, state) {
          final categoryId = PartnerCategoryId.tryParse(
            state.pathParameters['categoryId']!,
          )!;
          return PartnerCategoryScreen(categoryId: categoryId);
        },
      ),
      GoRoute(
        path: AppRoutePaths.addressPartnersSummary,
        redirect: (context, state) {
          return state.extra is PartnerSelectionResult
              ? null
              : addressPartnersPath;
        },
        builder: (context, state) {
          return PartnerSummaryScreen(
            result: state.extra! as PartnerSelectionResult,
          );
        },
      ),
      GoRoute(
        path: AppRoutePaths.partnerRegistrationApplicantType,
        redirect: (context, state) {
          return state.extra is PartnerSelectionResult
              ? null
              : addressPartnersPath;
        },
        builder: (context, state) {
          final selection = state.extra;
          if (selection is! PartnerSelectionResult) {
            return const AddressPartnersScreen();
          }

          return PartnerApplicantTypeScreen(selection: selection);
        },
      ),
      GoRoute(
        path: AppRoutePaths.partnerRegistrationBasicInfo,
        redirect: (context, state) {
          final draft = state.extra;
          return draft is PartnerRegistrationDraft &&
                  draft.applicantType != null
              ? null
              : addressPartnersPath;
        },
        builder: (context, state) {
          final draft = state.extra;
          if (draft is! PartnerRegistrationDraft ||
              draft.applicantType == null) {
            return const AddressPartnersScreen();
          }

          return PartnerBasicInfoScreen(draft: draft);
        },
      ),
      GoRoute(
        path: AppRoutePaths.partnerRegistrationIdentityResult,
        redirect: (context, state) {
          return state.extra is PartnerIdentityResultArgs
              ? null
              : addressPartnersPath;
        },
        builder: (context, state) {
          final args = state.extra;
          if (args is! PartnerIdentityResultArgs) {
            return const AddressPartnersScreen();
          }

          return PartnerIdentityResultScreen(args: args);
        },
      ),
      GoRoute(
        path: AppRoutePaths.partnerRegistrationLiveness,
        redirect: (context, state) {
          final draft = state.extra;
          return draft is PartnerRegistrationDraft &&
                  draft.applicantType != null &&
                  draft.identityVerified &&
                  draft.identityVerificationId.isNotEmpty
              ? null
              : addressPartnersPath;
        },
        builder: (context, state) {
          final draft = state.extra;
          if (draft is! PartnerRegistrationDraft ||
              draft.applicantType == null ||
              !draft.identityVerified ||
              draft.identityVerificationId.isEmpty) {
            return const AddressPartnersScreen();
          }

          return PartnerLivenessScreen(draft: draft);
        },
      ),
      GoRoute(
        path: AppRoutePaths.partnerRegistrationStoreInfo,
        redirect: (context, state) {
          final draft = state.extra;
          return draft is PartnerRegistrationDraft &&
                  draft.applicantType != null &&
                  draft.identityVerified &&
                  draft.livenessVerified
              ? null
              : addressPartnersPath;
        },
        builder: (context, state) {
          final draft = state.extra;
          if (draft is! PartnerRegistrationDraft ||
              draft.applicantType == null ||
              !draft.identityVerified ||
              !draft.livenessVerified) {
            return const AddressPartnersScreen();
          }

          return PartnerStoreInfoScreen(draft: draft);
        },
      ),
      GoRoute(
        path: AppRoutePaths.partnerRegistrationMapConfirmation,
        redirect: (context, state) {
          return state.extra is PartnerMapConfirmationArgs
              ? null
              : addressPartnersPath;
        },
        builder: (context, state) {
          final args = state.extra;
          if (args is! PartnerMapConfirmationArgs) {
            return const AddressPartnersScreen();
          }

          return PartnerMapConfirmationScreen(args: args);
        },
      ),
      GoRoute(
        path: AppRoutePaths.partnerApplicationCorrection,
        redirect: (context, state) {
          final draft = state.extra;
          return draft is PartnerRegistrationDraft &&
                  draft.isSelectiveCorrection
              ? null
              : addressPartnersPath;
        },
        builder: (context, state) {
          final draft = state.extra;

          if (draft is! PartnerRegistrationDraft ||
              !draft.isSelectiveCorrection) {
            return const AddressPartnersScreen();
          }

          return PartnerApplicationCorrectionScreen(draft: draft);
        },
      ),
      GoRoute(
        path: AppRoutePaths.partnerApplications,
        builder: (context, state) {
          final args = state.extra;

          return PartnerApplicationsScreen(
            args: args is PartnerApplicationsScreenArgs ? args : null,
          );
        },
      ),
      GoRoute(
        path: AppRoutePaths.partnerApplicationDetails,
        builder: (context, state) {
          final applicationId = state.pathParameters['applicationId'] ?? '';

          return PartnerApplicationDetailsScreen(applicationId: applicationId);
        },
      ),
      GoRoute(
        path: adminShopAccessPath,
        builder: (context, state) => const AdminShopAccessScreen(),
      ),
    ],
  );
}
