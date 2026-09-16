import 'package:idiomatic_app/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.displayName,
    required super.nativeLanguage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['display_name'] as String,
      nativeLanguage: json['native_language'] as String,
    );
  }
}
