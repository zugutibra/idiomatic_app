import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:idiomatic_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:idiomatic_app/features/auth/domain/usecases/login.dart';
import 'package:idiomatic_app/features/auth/domain/usecases/signup.dart';
import 'package:idiomatic_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:idiomatic_app/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this._signup,
    required this._login,
    required this._repository,
  }) : super(const AuthState()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthSignupRequested>(_onSignupRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  final Signup _signup;
  final Login _login;
  final AuthRepository _repository;

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = await _repository.currentCachedUser();
    if (user != null) {
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } else {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> _onSignupRequested(
    AuthSignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    final result = await _signup(
      SignupParams(
        email: event.email,
        password: event.password,
        displayName: event.displayName,
        nativeLanguage: event.nativeLanguage,
      ),
    );
    result.match(
      (failure) => emit(
        state.copyWith(isSubmitting: false, errorMessage: failure.message),
      ),
      (user) => emit(
        state.copyWith(
          isSubmitting: false,
          status: AuthStatus.authenticated,
          user: user,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    final result = await _login(
      LoginParams(email: event.email, password: event.password),
    );
    result.match(
      (failure) => emit(
        state.copyWith(isSubmitting: false, errorMessage: failure.message),
      ),
      (user) => emit(
        state.copyWith(
          isSubmitting: false,
          status: AuthStatus.authenticated,
          user: user,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _repository.logout();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
