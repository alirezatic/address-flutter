import 'package:address/features/capabilities/domain/entities/user_capabilities.dart';

abstract interface class UserCapabilitiesRepository {
  Future<UserCapabilities> getCapabilities();
}
