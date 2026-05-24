import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/notification_model.dart';
import '../repository/notification_repository.dart';

// Events
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object> get props => [];
}

class LoadNotifications extends NotificationEvent {}

class SendNotification extends NotificationEvent {
  final AppNotification notification;

  const SendNotification(this.notification);

  @override
  List<Object> get props => [notification];
}

// States
abstract class NotificationState extends Equatable {
  const NotificationState();
  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<AppNotification> received;
  final List<AppNotification> sent;

  const NotificationLoaded({required this.received, required this.sent});

  @override
  List<Object> get props => [received, sent];
}

class NotificationError extends NotificationState {
  final String message;
  const NotificationError(this.message);
  @override
  List<Object> get props => [message];
}

// Bloc
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;

  NotificationBloc({required this.repository}) : super(NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<SendNotification>(_onSendNotification);
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    try {
      final received = await repository.getReceivedNotifications();
      final sent = await repository.getSentNotifications();
      emit(NotificationLoaded(received: received, sent: sent));
    } catch (e) {
      emit(const NotificationError("Failed to load notifications"));
    }
  }

  Future<void> _onSendNotification(
    SendNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await repository.sendNotification(event.notification);
      final received = await repository.getReceivedNotifications();
      final sent = await repository.getSentNotifications();
      emit(NotificationLoaded(received: received, sent: sent));
    } catch (e) {
      emit(const NotificationError("Failed to send notification"));
    }
  }
}
