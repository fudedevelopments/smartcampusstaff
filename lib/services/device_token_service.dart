import 'package:smartcampusstaff/models/StaffUserProfile.dart';
import 'package:smartcampusstaff/utils/firebaseapi.dart';
import 'package:smartcampusstaff/bloc/repo/userprofilerepo.dart';

/// Service responsible for managing device token updates in the background
class DeviceTokenService {
  static final DeviceTokenService _instance = DeviceTokenService._internal();
  factory DeviceTokenService() => _instance;

  DeviceTokenService._internal();

  /// Checks if the current device token matches the one in the user profile
  /// If not, updates it in the background without affecting the UI
  Future<void> checkAndUpdateDeviceToken(StaffUserProfile userProfile) async {
    // Run in a microtask to avoid blocking the UI thread
    Future.microtask(() async {
      try {
        final currentToken = FirebaseApi().token;

        // If token is null or same as stored, no need to update
        if (currentToken == null || currentToken == userProfile.deviceToken) {
          return;
        }

        // Create updated user profile with new token
        final updatedProfile = userProfile.copyWith(deviceToken: currentToken);

        // Update the token in the backend
        await UserProfileRepo()
            .updateUserProfileStaff(userprofile: updatedProfile);

        print('Device token updated successfully in background');
      } catch (e) {
        print('Error updating device token in background: $e');
        // Silently fail to avoid disturbing UI
      }
    });
  }
}
