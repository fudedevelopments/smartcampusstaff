import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:smartcampusstaff/model/eventmodel.dart';
import 'package:smartcampusstaff/models/Events.dart';

Future<GraphQLResponse> createEvent(Events eventModel) async {
  try {
    final request = ModelMutations.create(eventModel);
    final response = await Amplify.API.mutate(request: request).response;

    if (response.hasErrors) {
      throw Exception(response.errors.map((e) => e.message).join(", "));
    }

    return response;
  } catch (e) {
    safePrint("Error creating event: $e");
    return GraphQLResponse(
      data: null,
      errors: [GraphQLResponseError(message: e.toString())],
    );
  }
}



class EventController extends GetxController {
  final Dio _dio = Dio();
  final String baseUrl =
      'https://zlj8ylwti7.execute-api.ap-south-1.amazonaws.com/ondutyquery';

  // Reactive variables
  var lastEvaluatedKey = Rxn<String>();
  var isLoading = false.obs;
  var isFetchingMore = false.obs;
  var eventList = <EventModel>[].obs;

  // Stored fetch parameters
  String? _tablename;
  String? _indexname;
  String? _token;
  int? _limit;
  String? _partitionKey;
  String? _partitionKeyValue;

  @override
  void onInit() {
    super.onInit();
    // Optionally call reload here if parameters are set
  }

  // Reload function using stored parameters
  Future<void> reload() async {
    if (_tablename == null ||
        _indexname == null ||
        _token == null ||
        _limit == null ||
        _partitionKey == null ||
        _partitionKeyValue == null) {
      print("Error: Fetch parameters not set. Call fetchData first.");
      return;
    }

    // Reset pagination and list
    lastEvaluatedKey.value = null;
    eventList.clear();
    // Fetch initial data with stored parameters
    await fetchData(
      tablename: _tablename!,
      indexname: _indexname!,
      token: _token!,
      limit: _limit!,
      partitionKey: _partitionKey!,
      partitionKeyValue: _partitionKeyValue!,
      isPagination: false,
    );
  }

  // Fetch data function with parameter storage
  Future<void> fetchData({
    required String tablename,
    required String indexname,
    required String token,
    required int limit,
    required String partitionKey,
    required String partitionKeyValue,
    bool isPagination = false,
  }) async {
    // Store parameters on first call or if they change
    _tablename = tablename;
    _indexname = indexname;
    _token = token;
    _limit = limit;
    _partitionKey = partitionKey;
    _partitionKeyValue = partitionKeyValue;

    if (isPagination && lastEvaluatedKey.value == null) return; // No more data

    try {
      if (isPagination) {
        isFetchingMore.value = true;
      } else {
        isLoading.value = true;
      }

      final response = await _dio.get(
        baseUrl,
        queryParameters: {
          'table_name': tablename,
          'index_name': indexname,
          'partition_key_value': partitionKeyValue,
          'partition_key': partitionKey,
          'limit': limit,
          if (isPagination && lastEvaluatedKey.value != null)
            'last_evaluated_key': lastEvaluatedKey.value.toString(),
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      final decoded = jsonDecode(response.data);
      List jsonResponse = decoded['items'];
      final lastKey = decoded['last_evaluated_key'];
      if (lastKey != null) {
        lastEvaluatedKey.value = lastKey.toString();
      } else {
        lastEvaluatedKey.value = null;
      }
      List<EventModel> newData =
          jsonResponse.map((e) => EventModel.fromMap(e)).toList();
      if (isPagination) {
        eventList.addAll(newData); // Append new data
      } else {
        eventList.assignAll(newData); // Replace existing data
      }
      if (eventList.isNotEmpty) {
        print(eventList[0].eventName);
      }
    } on DioException catch (e) {
      print("DioError: ${e.response?.statusCode} - ${e.response?.data}");
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
      isFetchingMore.value = false;
    }
  }

  bool hasMoreData() => lastEvaluatedKey.value != null;

  // Optional: Update token if it changes (e.g., after re-authentication)
  void updateToken(String newToken) {
    _token = newToken;
  }
}