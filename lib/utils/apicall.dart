import 'dart:convert';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:smartcampusstaff/model/newonduty.dart';

class OndutyController extends GetxController {
  final Dio _dio = Dio();
  final String baseUrl =
      'https://zlj8ylwti7.execute-api.ap-south-1.amazonaws.com/ondutyquery';

  var onDutyList = <OnDutyModel>[].obs; // Reactive list
  var lastEvaluatedKey = Rxn<String>(); // Nullable reactive variable
  var isLoading = false.obs;
  var isFetchingMore = false.obs;

  Future<void> fetchData({
    required String tablename,
    required String indexname,
    required String token,
    required int limit,
    required String partitionKey,
    required String partitionKeyValue,
    bool isPagination = false,
  }) async {
    if (isPagination && lastEvaluatedKey.value == null) return;

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
        lastEvaluatedKey.value =
            lastKey.toString(); // Explicitly convert to String
      } else {
        lastEvaluatedKey.value = null;
      }

      List<OnDutyModel> newData =
          jsonResponse.map((e) => OnDutyModel.fromMap(e)).toList();
      if (isPagination) {
        onDutyList.addAll(newData); // Append new data
      } else {
        onDutyList.assignAll(newData); // Replace existing data
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

  updateDynamoDBItem(
      {required String tablename,
      required String token,
      required String id,
      required String key,
      required String value,
      required String staffId,
      required String studentid}) async {
    final dio = Dio();
    final String url =
        "https://zlj8ylwti7.execute-api.ap-south-1.amazonaws.com/updateonduty";

  final Map<String, dynamic> data = {
      "table_name": tablename,
      "id": id,
      "value_key": key,
      "new_value": value,
      "staffId": staffId, // FIX: Change "staffid" to "staffId"
      "studentId": studentid // This is correct
    };


    try {
      final response = await dio.put(
        url,
        data: data,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );
      print(response);
      if (response.statusCode == 200) {
        print("Update successful: ${response.data}");
      } else {
        print("Failed to update item: ${response.statusCode}");
      }
    } catch (e) {
      print("Error making request: $e");
    }
  }
}
