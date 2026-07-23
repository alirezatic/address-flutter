import 'package:flutter/foundation.dart';

import 'package:address/features/admin_shop_access/application/admin_shop_access_dependencies.dart';
import 'package:address/features/admin_shop_access/domain/entities/admin_shop_access_failure.dart';
import 'package:address/features/admin_shop_access/domain/repositories/admin_shop_access_repository.dart';

enum AdminCapabilityState { idle, checking, allowed, denied, error }

class AdminCapabilityController extends ChangeNotifier {
  AdminCapabilityController({AdminShopAccessRepository? repository})
    : _repository = repository ?? AdminShopAccessDependencies.repository;

  final AdminShopAccessRepository _repository;

  AdminCapabilityState state = AdminCapabilityState.idle;
  AdminShopAccessFailure? failure;

  bool get isAdmin => state == AdminCapabilityState.allowed;

  bool get canRetry =>
      state == AdminCapabilityState.idle || state == AdminCapabilityState.error;

  Future<void> check() async {
    if (state == AdminCapabilityState.checking) {
      return;
    }

    state = AdminCapabilityState.checking;
    failure = null;
    notifyListeners();

    try {
      await _repository.getAccess();
      state = AdminCapabilityState.allowed;
    } on AdminShopAccessFailure catch (error) {
      failure = error;
      state = error.kind == AdminShopAccessFailureKind.forbidden
          ? AdminCapabilityState.denied
          : AdminCapabilityState.error;
    } finally {
      notifyListeners();
    }
  }
}
