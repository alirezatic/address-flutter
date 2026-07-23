import 'package:address/features/distribution/data/repositories/distribution_repository_impl.dart';
import 'package:address/features/distribution/domain/repositories/distribution_repository.dart';

abstract final class DistributionDependencies {
  static final DistributionRepository repository =
      DistributionRepositoryImpl();
}
