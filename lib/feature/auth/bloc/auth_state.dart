part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class SucsessSignin extends AuthState {}

class SucsessSignUp extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
