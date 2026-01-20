import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/user_model.dart';
import '../repository/user_repository.dart';
import '../../services/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository;

  AuthBloc({UserRepository? userRepository})
    : _userRepository = userRepository ?? UserRepository(),
      super(const AuthState.initial()) {
    on<LoginRequested>(_onLoginRequested);
    on<ProfileSubmitted>(_onProfileSubmitted);
    on<UpdateName>(_onUpdateName);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final (user, isNew) = await AuthService.signInWithGoogle();
      if (user != null && user.email != null) {
        // Check if user already exists in Firestore
        final existingUser = await _userRepository.getUser(user.uid);

        if (existingUser != null) {
          // Returning user - skip profile setup
          emit(AuthState.authenticated(existingUser));
        } else {
          // New user - show profile setup
          // Store the Firebase Auth UID for later use when saving
          emit(AuthState.profileSetup(user.email!, firebaseUid: user.uid));
        }
      }
    } catch (e) {
      // Handle error (maybe emit error state in future)
      print("Login failed: $e");
    }
  }

  Future<void> _onProfileSubmitted(
    ProfileSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    if (state.pendingEmail == null || state.firebaseUid == null) return;

    final newUser = AppUser(
      id: state.firebaseUid!, // Use Firebase Auth UID as document ID
      email: state.pendingEmail!,
      name: event.name,
      role: event.role,
      colorValue: event.colorValue,
    );

    // Save to Firestore
    try {
      await _userRepository.saveUser(newUser);
      emit(AuthState.authenticated(newUser));
    } catch (e) {
      print("Failed to save user profile: $e");
      // Still authenticate locally even if Firestore save fails
      emit(AuthState.authenticated(newUser));
    }
  }

  Future<void> _onUpdateName(UpdateName event, Emitter<AuthState> emit) async {
    if (state.status != AuthStatus.authenticated) return;

    final updatedUser = state.user.copyWith(name: event.newName);

    // Update in Firestore
    try {
      await _userRepository.saveUser(updatedUser);
      emit(AuthState.authenticated(updatedUser));
    } catch (e) {
      print("Failed to update name: $e");
      // Still update locally
      emit(AuthState.authenticated(updatedUser));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await AuthService.signOut();
    emit(const AuthState.initial());
  }
}
