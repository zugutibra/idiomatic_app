import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthSignupRequested extends AuthEvent {
  const AuthSignupRequested({
    required this.email,
    required this.password,
    required this.displayName,
    required this.nativeLanguage,
  });

  final String email;
  final String password;
  final String displayName;
  final String nativeLanguage;

  @override
  List<Object?> get props => [email, password, displayName, nativeLanguage];
}

class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
