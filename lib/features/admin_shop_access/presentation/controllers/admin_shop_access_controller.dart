import 'package:flutter/foundation.dart';

import 'package:address/features/admin_shop_access/application/admin_shop_access_dependencies.dart';
import 'package:address/features/admin_shop_access/domain/entities/admin_shop_access_entry.dart';
import 'package:address/features/admin_shop_access/domain/entities/admin_shop_access_failure.dart';
import 'package:address/features/admin_shop_access/domain/entities/admin_shop_access_mutation.dart';
import 'package:address/features/admin_shop_access/domain/repositories/admin_shop_access_repository.dart';

enum AdminShopAccessState { idle, loading, loaded, empty, forbidden, error }

class AdminShopAccessController extends ChangeNotifier {
  AdminShopAccessController({AdminShopAccessRepository? repository})
    : _repository = repository ?? AdminShopAccessDependencies.repository;

  final AdminShopAccessRepository _repository;

  AdminShopAccessState state = AdminShopAccessState.idle;
  List<AdminShopAccessEntry> access = const <AdminShopAccessEntry>[];
  AdminShopAccessFailure? failure;
  AdminShopAccessFailure? mutationFailure;
  int? selectedShopId;
  bool includeInactive = false;
  bool isMutating = false;

  bool get isLoading => state == AdminShopAccessState.loading;

  Future<void> load() async {
    state = AdminShopAccessState.loading;
    failure = null;
    notifyListeners();

    try {
      access = await _repository.getAccess(
        shopId: selectedShopId,
        includeInactive: includeInactive,
      );

      state = access.isEmpty
          ? AdminShopAccessState.empty
          : AdminShopAccessState.loaded;
    } on AdminShopAccessFailure catch (error) {
      failure = error;
      access = const <AdminShopAccessEntry>[];

      state = error.kind == AdminShopAccessFailureKind.forbidden
          ? AdminShopAccessState.forbidden
          : AdminShopAccessState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> applyFilters({
    int? shopId,
    required bool includeInactive,
  }) async {
    selectedShopId = shopId;
    this.includeInactive = includeInactive;
    await load();
  }

  Future<AdminShopAccessMutation?> grant({
    required String phone,
    required int shopId,
  }) {
    return _mutate(
      action: () {
        return _repository.grant(phone: phone, shopId: shopId);
      },
    );
  }

  Future<AdminShopAccessMutation?> revoke({
    required String phone,
    required int shopId,
  }) {
    return _mutate(
      action: () {
        return _repository.revoke(phone: phone, shopId: shopId);
      },
    );
  }

  Future<AdminShopAccessMutation?> _mutate({
    required Future<AdminShopAccessMutation> Function() action,
  }) async {
    if (isMutating) {
      return null;
    }

    isMutating = true;
    mutationFailure = null;
    notifyListeners();

    try {
      final result = await action();

      try {
        access = await _repository.getAccess(
          shopId: selectedShopId,
          includeInactive: includeInactive,
        );

        state = access.isEmpty
            ? AdminShopAccessState.empty
            : AdminShopAccessState.loaded;
      } on AdminShopAccessFailure catch (error) {
        failure = error;
        state = error.kind == AdminShopAccessFailureKind.forbidden
            ? AdminShopAccessState.forbidden
            : AdminShopAccessState.error;
      }

      return result;
    } on AdminShopAccessFailure catch (error) {
      mutationFailure = error;

      if (error.kind == AdminShopAccessFailureKind.forbidden) {
        failure = error;
        state = AdminShopAccessState.forbidden;
      }

      return null;
    } finally {
      isMutating = false;
      notifyListeners();
    }
  }
}
