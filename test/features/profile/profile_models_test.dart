import 'package:flutter_test/flutter_test.dart';

import 'package:address/features/auth/data/models/auth_user_model.dart';

void main() {
  test('parses Gateway v0.19.0 profile fields', () {
    final model = AuthUserModel.fromJson(<String, dynamic>{
      'id': 'user-1',
      'phone': '+989121234567',
      'firstName': 'Sara',
      'lastName': 'Ghorbani',
      'email': 'sara@example.com',
      'birthDate': '1992-05-20',
      'profileComplete': true,
      'registrationIntent': 'services',
      'roles': <String>['user'],
      'accountStatus': 'active',
      'hasAvatar': true,
      'avatarVersion': '2026-07-20T17:31:00.000Z',
    });

    final user = model.toEntity();

    expect(user.displayName, 'Sara Ghorbani');
    expect(user.email, 'sara@example.com');
    expect(user.birthDate, DateTime(1992, 5, 20));
    expect(user.accountStatus, 'active');
    expect(user.hasAvatar, isTrue);
    expect(user.avatarVersion, DateTime.utc(2026, 7, 20, 17, 31));
  });
}
