import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/user_model.dart';


part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState.initial()) {
    on<LoginRequested>(_onLoginRequested);
    on<ProfileSubmitted>(_onProfileSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  void _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) {
    // Determine if user exists or needs setup. 
    // For this Mock phase, ALWAYS go to Profile Setup if not logged in.
    // In future, check Firebase.
    emit(AuthState.profileSetup(event.email));
  }

  void _onProfileSubmitted(ProfileSubmitted event, Emitter<AuthState> emit) {
    if (state.pendingEmail == null) return;

    final newUser = AppUser(
      id: const Uuid().v4(), // Need to add uuid package or just random string
      email: state.pendingEmail!,
      name: event.name,
      role: event.role,
      colorValue: event.colorValue,
    );
    
    emit(AuthState.authenticated(newUser));
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) {
    emit(const AuthState.initial());
  }
}

// Mock Uuid for now to avoid dependency add if not present
class Uuid {
  const Uuid();
  String v4() => DateTime.now().millisecondsSinceEpoch.toString();
}
