import 'package:address/features/auth/domain/entities/auth_user.dart';

class AuthUserModel {
  const AuthUserModel({
    required this.id,
    required this.phone,
  });

  final String id;
  final String phone;

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final phone = json['phone'];

    if (id is! String || id.isEmpty || phone is! String || phone.isEmpty) {
      throw const FormatException('Invalid auth user response');
    }

    return AuthUserModel(id: id, phone: phone);
  }

  AuthUser toEntity() {
    return AuthUser(id: id, phone: phone);
  }
}
