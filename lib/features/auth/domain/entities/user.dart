import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.displayName,
    required this.nativeLanguage,
  });

  final String id;
  final String email;
  final String displayName;
  final String nativeLanguage;

  @override
  List<Object> get props => [id, email, displayName, nativeLanguage];
}
