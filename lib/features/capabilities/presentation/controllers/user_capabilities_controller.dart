import 'package:flutter/foundation.dart';

import 'package:address/features/capabilities/application/user_capabilities_dependencies.dart';
import 'package:address/features/capabilities/domain/entities/user_capabilities.dart';
import 'package:address/features/capabilities/domain/entities/user_capabilities_failure.dart';
import 'package:address/features/capabilities/domain/repositories/user_capabilities_repository.dart';

enum UserCapabilitiesState { idle, checking, loaded, denied, error }

class UserCapabilitiesController extends ChangeNotifier {
  UserCapabilitiesController({UserCapabilitiesRepository? repository})
    : _repository = repository ?? UserCapabilitiesDependencies.repository;

  static final UserCapabilitiesController instance =
      UserCapabilitiesController();

  final UserCapabilitiesRepository _repository;

  UserCapabilitiesState state = UserCapabilitiesState.idle;
  UserCapabilities? capabilities;
  UserCapabilitiesFailure? failure;

  bool get isAdmin =>
      state == UserCapabilitiesState.loaded &&
      capabilities?.isPlatformAdmin == true;

  bool get canRetry =>
      state == UserCapabilitiesState.idle ||
      state == UserCapabilitiesState.error ||
      state == UserCapabilitiesState.denied;

  Future<void> check() async {
    if (state == UserCapabilitiesState.checking) {
      return;
    }

    state = UserCapabilitiesState.checking;
    capabilities = null;
    failure = null;
    notifyListeners();

    try {
      capabilities = await _repository.getCapabilities();
      state = UserCapabilitiesState.loaded;
    } on UserCapabilitiesFailure catch (error) {
      failure = error;
      state =
          error.kind == UserCapabilitiesFailureKind.unauthorized ||
              error.kind == UserCapabilitiesFailureKind.forbidden
          ? UserCapabilitiesState.denied
          : UserCapabilitiesState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> ensureLoaded() async {
    if (state != UserCapabilitiesState.loaded) {
      await check();
    }

    return state == UserCapabilitiesState.loaded;
  }

  void clear() {
    if (state == UserCapabilitiesState.idle &&
        capabilities == null &&
        failure == null) {
      return;
    }

    state = UserCapabilitiesState.idle;
    capabilities = null;
    failure = null;
    notifyListeners();
  }
}
