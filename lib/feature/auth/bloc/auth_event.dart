part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class trySignUp extends AuthEvent {}

class trySignIn extends AuthEvent {}
