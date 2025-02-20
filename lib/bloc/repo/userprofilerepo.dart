import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:get/get_connect/http/src/exceptions/exceptions.dart';
import 'package:smartcampusstaff/models/ModelProvider.dart';

class UserProfileRepo {
  Future<StaffUserProfile?> getUserProfile({required String userId}) async {
    try {
      final response = await Amplify.API
          .query(
            request: ModelQueries.get(
              StaffUserProfile.classType,
              StaffUserProfileModelIdentifier(id: userId),
            ),
          )
          .response;
      if (response.hasErrors) {
        throw response.errors.first;
      }
      return response.data;
    } on ApiException catch (e) {
      throw Exception("API Error: ${e.message}");
    } on UnauthorizedException {
      throw Exception("Unauthorized Access");
    } catch (e) {
      throw Exception("Unknown Error: $e");
    }
  }

  Future<void> createUserProfileStaff(
      {required StaffUserProfile userprofile}) async {
    try {
      final createStaffUser = ModelMutations.create(userprofile);
      final response =
          await Amplify.API.mutate(request: createStaffUser).response;

      if (response.errors.isNotEmpty) {
        throw Exception("API Error: ${response.errors.first.message}");
      }
    } catch (e) {
      throw Exception("Failed to create user profile. Please try again.");
    }
  }
}
