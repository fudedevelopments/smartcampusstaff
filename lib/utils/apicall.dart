import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:smartcampusstaff/model/newonduty.dart';

class OndutyController extends GetxController {
  final Dio _dio = Dio();
  final String baseUrl =
      'https://zlj8ylwti7.execute-api.ap-south-1.amazonaws.com/ondutyquery';

  var onDutyList = <OnDutyModel>[].obs;
  var lastEvaluatedKey = Rxn<String>();
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
        lastEvaluatedKey.value = lastKey.toString();
      } else {
        lastEvaluatedKey.value = null;
      }

      List<OnDutyModel> newData =
          jsonResponse.map((e) => OnDutyModel.fromMap(e)).toList();
      if (isPagination) {
        onDutyList.addAll(newData); 
      } else {
        onDutyList.assignAll(newData);
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

  Future<void> updateProctor({
    required String token,
    required String id,
    required String value,
  }) async {
    final dio = Dio();
    final String url =
        "https://zlj8ylwti7.execute-api.ap-south-1.amazonaws.com/proctor-status-update";

    final Map<String, dynamic> data = {
      "id": id,
      "proctorstatus": value,
    };

    try {
       await dio.put(
        url,
        data: data,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );
    } catch (e) {
      safePrint("Error making request: $e");
      rethrow;
    }
  }

  Future<void> updateAC({
    required String token,
    required String id,
    required String value,
  }) async {
    final dio = Dio();
    final String url =
        "https://zlj8ylwti7.execute-api.ap-south-1.amazonaws.com/ac-status-update";

    final Map<String, dynamic> data = {
      "id": id,
      "AcStatus": value,
    };

    try {
      await dio.put(
        url,
        data: data,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );
 
    } catch (e) {
      safePrint("Error making request: $e");
      rethrow;
    }
  }

  Future<void> updateHOD({
    required String token,
    required String id,
    required String value,
  }) async {
    final dio = Dio();
    final String url =
        "https://zlj8ylwti7.execute-api.ap-south-1.amazonaws.com/hod-status-update";

    final Map<String, dynamic> data = {
      "id": id,
      "HodStatus": value,
    };

    try {
      await dio.put(
        url,
        data: data,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );
    } catch (e) {
      safePrint("Error making request: $e");
      rethrow;
    }
  }
}
