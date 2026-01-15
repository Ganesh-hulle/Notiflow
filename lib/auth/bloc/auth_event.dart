part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  const LoginRequested(this.email);

  @override
  List<Object> get props => [email];
}

class ProfileSubmitted extends AuthEvent {
  final String name;
  final UserRole role;
  final int colorValue;

  const ProfileSubmitted({
    required this.name,
    required this.role,
    required this.colorValue,
  });

  @override
  List<Object> get props => [name, role, colorValue];
}

class LogoutRequested extends AuthEvent {}
