import 'package:equatable/equatable.dart';

enum UserRole { director, hod, employee }

class AppUser extends Equatable {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final int colorValue; // Store color as int

  const AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.colorValue,
  });

  @override
  List<Object?> get props => [id, email, name, role, colorValue];

  factory AppUser.empty() {
    return const AppUser(
      id: '',
      email: '',
      name: '',
      role: UserRole.employee,
      colorValue: 0xFF2196F3, // Default Blue
    );
  }

  AppUser copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    int? colorValue,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      colorValue: colorValue ?? this.colorValue,
    );
  }
}
