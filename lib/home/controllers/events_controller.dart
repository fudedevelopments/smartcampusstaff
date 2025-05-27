import 'package:get/get.dart';
import 'package:smartcampusstaff/home/apicallevent.dart';
import 'package:smartcampusstaff/model/eventmodel.dart';
import 'package:smartcampusstaff/models/EventsModel.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class EventsController extends GetxController {
  final RxList<EventModel> eventList = <EventModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool hasMore = true.obs;
  final RxBool isDeleting = false.obs;

  final EventApiService _apiService = EventApiService();
  String? _lastEvaluatedKey;

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  Future<void> fetchEvents({bool refresh = false}) async {
    try {
      if (refresh) {
        // Clear current data and reset pagination
        eventList.clear();
        _lastEvaluatedKey = null;
        hasMore.value = true;
        // Clear the cache if refreshing
        await _apiService.clearCache();
      }

      if (!refresh && isLoading.value) {
        // Initial loading
        isLoading.value = true;
      } else if (refresh) {
        isLoading.value = true;
      }

      hasError.value = false;
      errorMessage.value = '';

      final response =
          await _apiService.fetchEvents(lastEvaluatedKey: _lastEvaluatedKey);

      if (response.containsKey('items')) {
        final items = response['items'] as List<dynamic>;
        final newEvents = items
            .map((item) => EventModel.fromMap(item as Map<String, dynamic>))
            .toList();

        // Update lastEvaluatedKey for pagination
        _lastEvaluatedKey = response['lastEvaluatedKey'] as String?;
        hasMore.value = _lastEvaluatedKey != null;

        if (refresh) {
          eventList.assignAll(newEvents);
        } else {
          eventList.addAll(newEvents);
        }
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore.value) return;

    isLoadingMore.value = true;
    await fetchEvents();
  }

  Future<void> refreshData() async {
    await fetchEvents(refresh: true);
  }

  Future<bool> removeEvent(String eventId) async {
    try {
      isDeleting.value = true;

      // Find the event in the list
      final event = eventList.firstWhere((e) => e.id == eventId);

      // Convert to EventsModel for deletion
      final eventModel = EventsModel(
        id: event.id,
        eventname: event.eventName,
        location: event.location,
        date: TemporalDate(event.date),
        details: event.details,
        registeredUrl: event.registerUrl,
        images: event.images,
        createdAt: TemporalTimestamp.fromSeconds(
            event.createdAt.millisecondsSinceEpoch ~/ 1000),
        expiray: TemporalTimestamp.fromSeconds(
            event.expiry.millisecondsSinceEpoch ~/ 1000),
      );

      // Call API to delete
      final response = await deleteEvent(eventModel);

      if (response.hasErrors) {
        errorMessage.value = response.errors.map((e) => e.message).join(", ");
        hasError.value = true;
        return false;
      }

      // Remove from the local list
      eventList.removeWhere((e) => e.id == eventId);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      hasError.value = true;
      return false;
    } finally {
      isDeleting.value = false;
    }
  }

  Future<EventModel?> getEvent(String eventId) async {
    try {
      return eventList.firstWhere((e) => e.id == eventId);
    } catch (e) {
      // Event not found in list, try to fetch it from API
      errorMessage.value = "Event not found";
      return null;
    }
  }
}
