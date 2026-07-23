import 'package:flutter/foundation.dart';

import 'package:address/features/distribution/application/distribution_dependencies.dart';
import 'package:address/features/distribution/domain/entities/distribution_failure.dart';
import 'package:address/features/distribution/domain/entities/distribution_order_details.dart';
import 'package:address/features/distribution/domain/repositories/distribution_repository.dart';

enum DistributionOrderDetailsState { idle, loading, loaded, error }

class DistributionOrderDetailsController extends ChangeNotifier {
  DistributionOrderDetailsController({DistributionRepository? repository})
    : _repository = repository ?? DistributionDependencies.repository;

  final DistributionRepository _repository;

  DistributionOrderDetailsState state = DistributionOrderDetailsState.idle;
  DistributionOrderDetails? order;
  DistributionFailure? failure;

  bool get isLoading => state == DistributionOrderDetailsState.loading;

  Future<void> load(String name) async {
    state = DistributionOrderDetailsState.loading;
    failure = null;
    order = null;
    notifyListeners();

    try {
      order = await _repository.getOrder(name);
      state = DistributionOrderDetailsState.loaded;
    } on DistributionFailure catch (error) {
      failure = error;
      state = DistributionOrderDetailsState.error;
    } finally {
      notifyListeners();
    }
  }
}
