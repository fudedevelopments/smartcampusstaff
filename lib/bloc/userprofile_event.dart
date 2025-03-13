part of 'userprofile_bloc.dart';

@immutable
sealed class UserprofileEvent {}

class GetUserProfileEvent extends UserprofileEvent {
  final String email;
  final String userid;

  GetUserProfileEvent({required this.email, required this.userid});
}

class UserprofileCreateEvent extends UserprofileEvent {
  final StaffUserProfile userProfile;

  UserprofileCreateEvent({required this.userProfile});
}

class UpdateDeviceTokenEvent extends UserprofileEvent {
  final StaffUserProfile userProfile;
  final String newToken;

  UpdateDeviceTokenEvent({required this.userProfile, required this.newToken});
}
