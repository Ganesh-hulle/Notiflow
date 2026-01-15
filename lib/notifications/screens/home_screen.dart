import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notification_bloc.dart';
import '../../widgets/notification_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state is NotificationInitial) {
          context.read<NotificationBloc>().add(LoadNotifications());
          return const Center(child: CircularProgressIndicator());
        } else if (state is NotificationLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is NotificationError) {
          return Center(child: Text(state.message));
        } else if (state is NotificationLoaded) {
          if (state.received.isEmpty) {
            return const Center(child: Text('No notifications received'));
          }
          return RefreshIndicator(
            onRefresh: () async {
              context.read<NotificationBloc>().add(LoadNotifications());
            },
            child: ListView.builder(
              itemCount: state.received.length,
              itemBuilder: (context, index) {
                return NotificationCard(notification: state.received[index]);
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
