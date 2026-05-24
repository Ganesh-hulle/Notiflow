import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/notification_card.dart';
import '../bloc/notification_bloc.dart';
import 'compose_notification_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state is NotificationInitial) {
          context.read<NotificationBloc>().add(LoadNotifications());
          return const Center(child: CircularProgressIndicator());
        }

        if (state is NotificationLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is NotificationError) {
          return _EmptyState(
            message: state.message,
            onRefresh: () =>
                context.read<NotificationBloc>().add(LoadNotifications()),
            onCompose: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ComposeNotificationScreen(),
                ),
              );
            },
          );
        }

        if (state is NotificationLoaded) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ComposeNotificationScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.send),
                        label: const Text('New notification'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        context.read<NotificationBloc>().add(
                          LoadNotifications(),
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: state.received.isEmpty
                    ? _EmptyState(
                        message: 'No notifications received',
                        compact: true,
                        onRefresh: () => context.read<NotificationBloc>().add(
                          LoadNotifications(),
                        ),
                        onCompose: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ComposeNotificationScreen(),
                            ),
                          );
                        },
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          context.read<NotificationBloc>().add(
                            LoadNotifications(),
                          );
                        },
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: state.received.length,
                          itemBuilder: (context, index) {
                            return NotificationCard(
                              notification: state.received[index],
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  final VoidCallback onRefresh;
  final VoidCallback onCompose;
  final bool compact;

  const _EmptyState({
    required this.message,
    required this.onRefresh,
    required this.onCompose,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final body = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.notifications_none,
          size: compact ? 44 : 56,
          color: Colors.grey[500],
        ),
        const SizedBox(height: 12),
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            FilledButton.icon(
              onPressed: onCompose,
              icon: const Icon(Icons.send),
              label: const Text('New notification'),
            ),
            OutlinedButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
            ),
          ],
        ),
      ],
    );

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: body,
      ),
    );
  }
}
