import 'package:equatable/equatable.dart';

class AppNotification extends Equatable {
  final String id;
  final String senderName;
  final int senderColor;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.senderName,
    required this.senderColor,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
  });

  @override
  List<Object?> get props => [id, senderName, senderColor, title, body, timestamp, isRead];
}
