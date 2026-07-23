import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:address/app/route_paths.dart';
import 'package:address/features/partner_registration/data/partner_verification_repository.dart';
import 'package:address/features/partner_registration/presentation/controller/partner_registration_controller.dart';
import 'package:address/features/partners/domain/models/partner_category.dart';

abstract final class PartnerRegistrationStartCoordinator {
  static Future<void> open({
    required BuildContext context,
    required PartnerSelectionResult selection,
  }) async {
    final repository = PartnerVerificationRepository();
    final identity = await repository.findReusableIdentity();

    if (!context.mounted) {
      return;
    }

    if (identity == null) {
      await context.push(
        AppRoutePaths.partnerRegistrationApplicantType,
        extra: selection,
      );
      return;
    }

    final controller = PartnerRegistrationController.fromReusableIdentity(
      selection: selection,
      identity: identity,
    );

    await context.push(
      AppRoutePaths.partnerRegistrationStoreInfo,
      extra: controller.draft,
    );
  }
}
