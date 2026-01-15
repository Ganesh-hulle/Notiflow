part of 'auth_bloc.dart';

enum AuthStatus { initial, profileSetup, authenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final AppUser user;
  final String? pendingEmail; // Stored during profile setup

  const AuthState._({
    this.status = AuthStatus.initial,
    this.user = const AppUser(id: '', email: '', name: '', role: UserRole.employee, colorValue: 0),
    this.pendingEmail,
  });

  const AuthState.initial() : this._();

  const AuthState.profileSetup(String email) 
      : this._(status: AuthStatus.profileSetup, pendingEmail: email);

  const AuthState.authenticated(AppUser user) 
      : this._(status: AuthStatus.authenticated, user: user);

  @override
  List<Object?> get props => [status, user, pendingEmail];
}
