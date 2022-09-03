part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class LoginAuthInitial extends AuthState {}

class LoggingInState extends AuthState {}

class LoggedInSuccess extends AuthState {}

class AuthenticationSuccess extends AuthState {}

class AuthenticationFailed extends AuthState {}

class LoggedOutSuccess extends AuthState {}

class LoggedInFailed extends AuthState {}
