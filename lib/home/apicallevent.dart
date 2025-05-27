import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:dio/dio.dart';
import 'package:smartcampusstaff/models/EventsModel.dart';
import 'package:smartcampusstaff/utils/authservices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future<GraphQLResponse> createEvent(EventsModel eventModel) async {
  try {
    final request = ModelMutations.create(eventModel);
    final response = await Amplify.API.mutate(request: request).response;
    print(response);
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

Future<GraphQLResponse> deleteEvent(EventsModel eventModel) async {
  try {
    // First delete all images from storage
    if (eventModel.images != null && eventModel.images!.isNotEmpty) {
      for (final imagePath in eventModel.images!) {
        try {
          await Amplify.Storage.remove(
            path: StoragePath.fromString(imagePath),
          ).result;
          safePrint('Successfully deleted image: $imagePath');
        } catch (e) {
          safePrint('Error deleting image: $e');
          // Continue with other images even if one fails
        }
      }
    }

    // Then delete the event from the database
    final request = ModelMutations.delete(eventModel);
    final response = await Amplify.API.mutate(request: request).response;

    if (response.hasErrors) {
      throw Exception(response.errors.map((e) => e.message).join(", "));
    }

    return response;
  } catch (e) {
    safePrint("Error deleting event: $e");
    return GraphQLResponse(
      data: null,
      errors: [GraphQLResponseError(message: e.toString())],
    );
  }
}

Future<GraphQLResponse> updateEvent(EventsModel eventModel) async {
  try {
    final request = ModelMutations.update(eventModel);
    final response = await Amplify.API.mutate(request: request).response;

    if (response.hasErrors) {
      throw Exception(response.errors.map((e) => e.message).join(", "));
    }

    return response;
  } catch (e) {
    safePrint("Error updating event: $e");
    return GraphQLResponse(
      data: null,
      errors: [GraphQLResponseError(message: e.toString())],
    );
  }
}

class EventApiService {
  static final EventApiService _instance = EventApiService._internal();
  final Dio _dio = Dio();
  final String _apiUrl =
      'https://zlj8ylwti7.execute-api.ap-south-1.amazonaws.com/getEvents';

  factory EventApiService() => _instance;

  EventApiService._internal();

  Future<Map<String, dynamic>> fetchEvents({String? lastEvaluatedKey}) async {
    try {
      final token = AuthService().idToken;

      // Check cache first if no pagination key is provided
      if (lastEvaluatedKey == null) {
        final cachedData = await _getCachedEvents();
        if (cachedData != null) {
          return cachedData;
        }
      }

      // Prepare query parameters for pagination
      Map<String, dynamic>? queryParams;
      if (lastEvaluatedKey != null && lastEvaluatedKey.isNotEmpty) {
        queryParams = {'lastEvaluatedKey': lastEvaluatedKey};
      }

      final response = await _dio.get(
        _apiUrl,
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        // Cache only the first page
        if (lastEvaluatedKey == null) {
          await _cacheEvents(data);
        }

        return data;
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioError) {
        print('Dio error: ${e.message}');
        if (e.response != null) {
          print('Error response data: ${e.response!.data}');
          print('Error response status: ${e.response!.statusCode}');
          throw Exception('API Error: ${e.response!.statusMessage}');
        }
      } else {
        print('Unexpected error: $e');
      }
      throw Exception('Failed to fetch events: $e');
    }
  }

  Future<void> _cacheEvents(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cached_events', jsonEncode(data));
      await prefs.setInt(
          'cache_timestamp', DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('Error caching events: $e');
    }
  }

  Future<Map<String, dynamic>?> _getCachedEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('cached_events');
      final cacheTimestamp = prefs.getInt('cache_timestamp');

      // Return null if no cached data or cache is older than 15 minutes
      if (cachedData == null || cacheTimestamp == null) return null;

      final cacheTime = DateTime.fromMillisecondsSinceEpoch(cacheTimestamp);
      final now = DateTime.now();
      if (now.difference(cacheTime).inMinutes > 15) return null;

      return jsonDecode(cachedData) as Map<String, dynamic>;
    } catch (e) {
      print('Error retrieving cached events: $e');
      return null;
    }
  }

  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('cached_events');
      await prefs.remove('cache_timestamp');
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }
}
