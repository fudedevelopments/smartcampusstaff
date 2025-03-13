import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smartcampusstaff/bloc/repo/userprofilerepo.dart';
import 'package:smartcampusstaff/models/ModelProvider.dart';
import 'package:smartcampusstaff/utils/firebaseapi.dart';
import 'package:smartcampusstaff/services/device_token_service.dart';
import 'package:smartcampusstaff/utils/token_sync_util.dart';

part 'userprofile_event.dart';
part 'userprofile_state.dart';

class UserprofileBloc extends Bloc<UserprofileEvent, UserprofileState> {
  final TokenSyncUtil _tokenSyncUtil = TokenSyncUtil();

  UserprofileBloc() : super(UserprofileInitial()) {
    on<GetUserProfileEvent>(getUserProfileEvent);
    on<UserprofileCreateEvent>(userprofileCreateEvent);
    on<UpdateDeviceTokenEvent>(updateDeviceTokenEvent);
  }

  Future<void> getUserProfileEvent(
      GetUserProfileEvent event, Emitter<UserprofileState> emit) async {
    emit(UserProfileLoadingState());
    try {
      final userProfile =
          await UserProfileRepo().getUserProfile(userId: event.userid);

      if (userProfile == null) {
        emit(UserProfileEmptyState(userid: event.userid, email: event.email));
      } else {
        // Check and update device token in the background without affecting UI
        _syncTokenInBackground(userProfile);

        emit(UserProfileSucessState(userProfile: userProfile));
      }
    } catch (e) {
      emit(UserProfileFailedState(error: e.toString()));
    }
  }

  Future<void> userprofileCreateEvent(
      UserprofileCreateEvent event, Emitter<UserprofileState> emit) async {
    try {
      emit(CreateUserProfilestaffLoadingState());

      await UserProfileRepo()
          .createUserProfileStaff(userprofile: event.userProfile);

      emit(CreateUserProfilestaffsuccessState());
    } catch (e) {
      emit(CreateUserProfilestaffFailedState(error: e.toString()));
    }
  }

  Future<void> updateDeviceTokenEvent(
      UpdateDeviceTokenEvent event, Emitter<UserprofileState> emit) async {
    try {
      // Don't emit loading state to avoid UI disruption
      final updatedProfile =
          event.userProfile.copyWith(deviceToken: event.newToken);

      await UserProfileRepo()
          .updateUserProfileStaff(userprofile: updatedProfile);

      // Only emit success state if we're explicitly waiting for it
      // For background updates, we don't emit any state
    } catch (e) {
      // Silently fail for background updates
      print('Error updating device token: $e');
    }
  }

  // Method to sync token in the background without affecting UI
  void _syncTokenInBackground(StaffUserProfile userProfile) {
    // Use Future.microtask to avoid blocking the UI thread
    Future.microtask(() async {
      await _tokenSyncUtil.syncDeviceToken(userProfile);
    });
  }
}
