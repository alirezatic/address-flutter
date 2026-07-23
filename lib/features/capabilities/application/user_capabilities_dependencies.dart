import 'package:address/features/capabilities/data/repositories/user_capabilities_repository_impl.dart';
import 'package:address/features/capabilities/domain/repositories/user_capabilities_repository.dart';

abstract final class UserCapabilitiesDependencies {
  static final UserCapabilitiesRepository repository =
      UserCapabilitiesRepositoryImpl();
}
