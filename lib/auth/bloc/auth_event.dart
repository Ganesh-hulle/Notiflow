part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  const LoginRequested();

  @override
  List<Object> get props => [];
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

/// Event to update user's display name
class UpdateName extends AuthEvent {
  final String newName;

  const UpdateName(this.newName);

  @override
  List<Object> get props => [newName];
}

class LogoutRequested extends AuthEvent {}
