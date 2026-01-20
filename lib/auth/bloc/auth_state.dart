part of 'auth_bloc.dart';

enum AuthStatus { initial, profileSetup, authenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final AppUser user;
  final String? pendingEmail; // Stored during profile setup
  final String? firebaseUid; // Firebase Auth UID for new users

  const AuthState._({
    this.status = AuthStatus.initial,
    this.user = const AppUser(
      id: '',
      email: '',
      name: '',
      role: UserRole.employee,
      colorValue: 0,
    ),
    this.pendingEmail,
    this.firebaseUid,
  });

  const AuthState.initial() : this._();

  const AuthState.profileSetup(String email, {required String firebaseUid})
    : this._(
        status: AuthStatus.profileSetup,
        pendingEmail: email,
        firebaseUid: firebaseUid,
      );

  const AuthState.authenticated(AppUser user)
    : this._(status: AuthStatus.authenticated, user: user);

  @override
  List<Object?> get props => [status, user, pendingEmail, firebaseUid];
}
