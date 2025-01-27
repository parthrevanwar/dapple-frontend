part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  AuthSignUp({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });
}

final class AuthLogInWithEmail extends AuthEvent {
  final String email;
  final String password;

  AuthLogInWithEmail({
    required this.email,
    required this.password,
  });
}

final class AuthLogInWithGoogle extends AuthEvent {
  final bool isSignUp;

  AuthLogInWithGoogle(this.isSignUp);
}

final class AuthCurrentUser extends AuthEvent{}
