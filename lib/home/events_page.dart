import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartcampusstaff/home/addevents.dart';
import 'package:smartcampusstaff/home/components/event_card.dart';
import 'package:smartcampusstaff/home/components/loading_widget.dart';
import 'package:smartcampusstaff/home/controllers/events_controller.dart';
import 'package:smartcampusstaff/home/edit_event_screen.dart';
import 'package:smartcampusstaff/utils/utils.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  late EventsController controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller = Get.put(EventsController());
    _setupScrollListener();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // Load more when near the bottom
        controller.loadMore();
      }
    });
  }

  Future<void> _showDeleteConfirmationDialog(String eventId) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text(
              'Are you sure you want to delete this event? This will also delete all associated images.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Deleting event...'),
              ],
            ),
          );
        },
      );

      // Call API to delete event
      final success = await controller.removeEvent(eventId);

      // Close loading dialog
      Navigator.of(context).pop();

      // Show result message
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Event deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        // Refresh the list to ensure it's up to date
        controller.refreshData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to delete event: ${controller.errorMessage.value}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Events List",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => controller.refreshData(),
            icon: const Icon(
              Icons.refresh_rounded,
              color: Colors.black,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigationpush(context, CreateEventScreen()),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.eventList.isEmpty) {
          return const EventLoadingWidget();
        }

        if (controller.hasError.value && controller.eventList.isEmpty) {
          return EventErrorWidget(
            errorMessage: controller.errorMessage.value,
            onRetry: controller.refreshData,
          );
        }

        if (controller.eventList.isEmpty) {
          return EmptyEventsWidget(onRefresh: controller.refreshData);
        }

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: controller.eventList.length +
                (controller.hasMore.value ? 1 : 0),
            padding: const EdgeInsets.only(bottom: 80), // Add padding for FAB
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              // Show loading indicator at the bottom when loading more
              if (index == controller.eventList.length &&
                  controller.hasMore.value) {
                return const LoadingFooter();
              }

              // Show event card
              final event = controller.eventList[index];
              return EventCard(
                event: event,
                onDelete: () => _showDeleteConfirmationDialog(event.id),
                onEdit: () {
                  // Navigate to edit screen with the event data
                  navigationpush(context, EditEventScreen(eventId: event.id));
                },
              );
            },
          ),
        );
      }),
    );
  }
}

// Components for loading states

class EventLoadingWidget extends StatelessWidget {
  const EventLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading events...'),
        ],
      ),
    );
  }
}

class EventErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const EventErrorWidget({
    Key? key,
    required this.errorMessage,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Failed to load events',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class EmptyEventsWidget extends StatelessWidget {
  final VoidCallback onRefresh;

  const EmptyEventsWidget({Key? key, required this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.event_busy, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No events found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Try adding a new event or refresh the list',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRefresh,
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}

class LoadingFooter extends StatelessWidget {
  const LoadingFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
