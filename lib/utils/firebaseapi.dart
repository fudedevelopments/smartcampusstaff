import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:smartcampusstaff/models/StaffUserProfile.dart';
import 'package:smartcampusstaff/bloc/repo/userprofilerepo.dart';

class FirebaseApi {
  static final FirebaseApi _instance = FirebaseApi._internal();
  factory FirebaseApi() => _instance;

  FirebaseApi._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? _fcmToken;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    _fcmToken = await _firebaseMessaging.getToken();

    // Listen for token refreshes
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      print('FCM Token refreshed: $newToken');
    });
  }

  /// Checks if the device token in the user profile matches the current FCM token
  /// If they don't match, updates the token in the backend
  Future<void> checkAndUpdateDeviceToken(StaffUserProfile userProfile) async {
    try {
      // Get the current device token
      final currentDeviceToken = _fcmToken;

      // If token is null or same as stored, no need to update
      if (currentDeviceToken == null ||
          currentDeviceToken == userProfile.deviceToken) {
        return;
      }

      // Create updated user profile with new token
      final updatedProfile =
          userProfile.copyWith(deviceToken: currentDeviceToken);

      // Update the token in the backend
      await UserProfileRepo()
          .updateUserProfileStaff(userprofile: updatedProfile);

      print('Device token updated successfully');
    } catch (e) {
      print('Error updating device token: $e');
      // Silently fail to avoid disturbing UI
    }
  }

  String? get token => _fcmToken;
}
