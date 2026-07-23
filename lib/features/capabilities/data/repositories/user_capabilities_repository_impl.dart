import 'package:address/features/capabilities/data/datasources/user_capabilities_remote_data_source.dart';
import 'package:address/features/capabilities/domain/entities/user_capabilities.dart';
import 'package:address/features/capabilities/domain/repositories/user_capabilities_repository.dart';

class UserCapabilitiesRepositoryImpl implements UserCapabilitiesRepository {
  UserCapabilitiesRepositoryImpl({
    UserCapabilitiesRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource =
           remoteDataSource ?? UserCapabilitiesRemoteDataSource();

  final UserCapabilitiesRemoteDataSource _remoteDataSource;

  @override
  Future<UserCapabilities> getCapabilities() {
    return _remoteDataSource.getCapabilities();
  }
}
