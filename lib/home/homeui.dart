import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartcampusstaff/components/errorsnack.dart';
import 'package:smartcampusstaff/home/addevents.dart';
import 'package:smartcampusstaff/home/apicallevent.dart';
import 'package:smartcampusstaff/home/eventcard.dart';
import 'package:smartcampusstaff/model/eventmodel.dart';
import 'package:smartcampusstaff/models/Events.dart';
import 'package:smartcampusstaff/utils/authservices.dart';
import 'package:smartcampusstaff/utils/utils.dart';

class Home extends StatelessWidget {
  final EventController controller = Get.put(EventController());
  final ScrollController _scrollController = ScrollController();
  final AuthService authService = AuthService();

  Home({super.key});

  // Function to show delete confirmation dialog
  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, EventModel event) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this event?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // No
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Yes
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      final request = ModelMutations.deleteById(
          Events.classType, EventsModelIdentifier(id: event.id));
      final response = await Amplify.API.mutate(request: request).response;
      if (response.data != null) {
        if (response.hasErrors) {
          showErrorSnackBar(
              context, "Error in delete : ${response.errors[0].message}");
        } else {
          await controller.reload();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initial fetch with parameters
    controller.fetchData(
      tablename: "Events-2jskpek75veajd4yfnqjmkppmu-NONE",
      indexname: "eventsByModelAndCreatedAt",
      token: authService.idToken!,
      limit: 5,
      partitionKey: "model",
      partitionKeyValue: "Events",
      isPagination: false,
    );

    // Pagination listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !controller.isFetchingMore.value) {
        controller.fetchData(
          tablename: "Events-2jskpek75veajd4yfnqjmkppmu-NONE",
          indexname: "eventsByModelAndCreatedAt",
          token: authService.idToken!,
          limit: 5,
          partitionKey: "model",
          partitionKeyValue: "Events",
          isPagination: true,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Events List"),
        actions: [
          IconButton(
            onPressed: () => controller.reload(),
            icon: const Icon(Icons.replay_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigationpush(context, CreateEventScreen()),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          controller: _scrollController,
          itemCount: controller.eventList.length +
              (controller.isFetchingMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.eventList.length) {
              return const Center(child: CircularProgressIndicator());
            }
            final event = controller.eventList[index];
            return EventCard(
              event: event,
              onDelete: () => _showDeleteConfirmationDialog(
                  context, event), // Trigger dialog
            );
          },
        );
      }),
    );
  }
}
