import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth/bloc/auth_bloc.dart';
import 'notifications/bloc/notification_bloc.dart';
import 'notifications/repository/notification_repository.dart';
import 'auth/screens/login_screen.dart';
import 'auth/screens/profile_setup_screen.dart';
import 'main_wrapper.dart';

void main() {
  runApp(const NotiFlowApp());
}

class NotiFlowApp extends StatelessWidget {
  const NotiFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Repository Providers
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => NotificationRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc()),
          BlocProvider(
            create: (context) => NotificationBloc(
              repository: context.read<NotificationRepository>(),
            )..add(LoadNotifications()),
          ),
        ],
        child: MaterialApp(
          title: 'NotiFlow',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
            textTheme: GoogleFonts.interTextTheme(),
          ),
          home: const AuthGate(),
        ),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          return const MainWrapper();
        } else if (state.status == AuthStatus.profileSetup) {
          return const ProfileSetupScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
