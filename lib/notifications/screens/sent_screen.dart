import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notification_bloc.dart';
import '../../widgets/notification_card.dart';

class SentScreen extends StatelessWidget {
  const SentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        // Assume loaded since Home triggers it, but good to handle reloading if separate
        if (state is NotificationLoaded) {
          if (state.sent.isEmpty) {
            return const Center(child: Text('No notifications sent'));
          }
          return RefreshIndicator(
            onRefresh: () async {
              context.read<NotificationBloc>().add(LoadNotifications());
            },
            child: ListView.builder(
              itemCount: state.sent.length,
              itemBuilder: (context, index) {
                return NotificationCard(
                  notification: state.sent[index],
                  isSent: true,
                );
              },
            ),
          );
        } else if (state is NotificationLoading) {
           return const Center(child: CircularProgressIndicator());
        }
         // Fallback if not loaded yet (e.g. went straight to tab? Unlikely if wrapped properly)
         return const Center(child: Text('Loading...'));
      },
    );
  }
}
