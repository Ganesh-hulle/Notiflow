import '../models/notification_model.dart';

class NotificationRepository {
  Future<List<AppNotification>> getReceivedNotifications() async {
    await Future.delayed(const Duration(seconds: 1)); // Mock delay
    return [
      AppNotification(
        id: '1',
        senderName: 'Dr. Strange (Director)',
        senderColor: 0xFFF44336, // Red
        title: 'Emergency Meeting',
        body: 'All HODs please assemble in the conference room at 2 PM.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      AppNotification(
        id: '2',
        senderName: 'Prof. X (HOD)',
        senderColor: 0xFF2196F3, // Blue
        title: 'Syllabus Update',
        body: 'Please review the attached syllabus changes for next semester.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
       AppNotification(
        id: '3',
        senderName: 'Admin',
        senderColor: 0xFF9C27B0, // Purple
        title: 'Holiday Notice',
        body: 'The college will remain closed tomorrow due to heavy rain.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  Future<List<AppNotification>> getSentNotifications() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      AppNotification(
        id: '101',
        senderName: 'Me', // In real app, this wouldn't be displayed or would be "To: X"
        senderColor: 0xFF4CAF50, 
        title: 'Leave Application',
        body: 'I am requesting leave for 2 days.',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }
}
