import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:smartcampusstaff/home/events_page.dart';
import 'package:smartcampusstaff/model/eventmodel.dart';
import 'package:smartcampusstaff/utils/authservices.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const EventsPage();
  }
}

class EventsController extends GetxController {
  final RxList<EventModel> eventList = <EventModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isFetchingMore = false.obs;

  Future<void> refreshData() async {
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 1));

    eventList.clear();

    isLoading.value = false;
  }

  void removeEvent(EventModel event) {
    eventList.removeWhere((e) => e.id == event.id);
  }
}
