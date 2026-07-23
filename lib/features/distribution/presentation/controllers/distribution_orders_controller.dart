import 'package:flutter/foundation.dart';

import 'package:address/features/distribution/application/distribution_dependencies.dart';
import 'package:address/features/distribution/domain/entities/distribution_failure.dart';
import 'package:address/features/distribution/domain/entities/distribution_order_summary.dart';
import 'package:address/features/distribution/domain/repositories/distribution_repository.dart';

enum DistributionOrdersState { idle, loading, loaded, empty, error }

class DistributionOrdersController extends ChangeNotifier {
  DistributionOrdersController({DistributionRepository? repository})
    : _repository = repository ?? DistributionDependencies.repository;

  final DistributionRepository _repository;

  DistributionOrdersState state = DistributionOrdersState.idle;
  List<DistributionOrderSummary> orders = const <DistributionOrderSummary>[];
  DistributionFailure? failure;
  String? selectedState;
  String? selectedWalletState;
  String? selectedDeliveryState;

  bool get isLoading => state == DistributionOrdersState.loading;

  Future<void> load({int limit = 20}) async {
    state = DistributionOrdersState.loading;
    failure = null;
    notifyListeners();

    try {
      final page = await _repository.getOrders(
        limit: limit,
        state: selectedState,
        walletState: selectedWalletState,
        deliveryState: selectedDeliveryState,
      );

      orders = page.orders;
      state = orders.isEmpty
          ? DistributionOrdersState.empty
          : DistributionOrdersState.loaded;
    } on DistributionFailure catch (error) {
      failure = error;
      orders = const <DistributionOrderSummary>[];
      state = DistributionOrdersState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> setStateFilter(String? value) async {
    selectedState = _normalize(value);
    await load();
  }

  Future<void> setWalletStateFilter(String? value) async {
    selectedWalletState = _normalize(value);
    await load();
  }

  Future<void> setDeliveryStateFilter(String? value) async {
    selectedDeliveryState = _normalize(value);
    await load();
  }

  Future<void> clearFilters() async {
    selectedState = null;
    selectedWalletState = null;
    selectedDeliveryState = null;
    await load();
  }

  String? _normalize(String? value) {
    final normalized = value?.trim();

    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    return normalized;
  }
}
