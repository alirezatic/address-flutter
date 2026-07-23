import 'package:address/core/storage/auth_token_storage.dart';
import 'package:address/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:address/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:address/features/auth/domain/repositories/auth_repository.dart';

abstract final class AuthDependencies {
  static final AuthTokenStorage tokenStorage = AuthTokenStorage();

  static final AuthRemoteDataSource remoteDataSource = AuthRemoteDataSource();

  static final AuthRepository repository = AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
  );
}
