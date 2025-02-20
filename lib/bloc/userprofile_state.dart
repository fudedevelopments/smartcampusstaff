part of 'userprofile_bloc.dart';

@immutable
sealed class UserprofileState {}

final class UserprofileInitial extends UserprofileState {}

class UserProfileLoadingState extends UserprofileState {}

class UserProfileSucessState extends UserprofileState {
  final StaffUserProfile userProfile;

  UserProfileSucessState({required this.userProfile});
}

class UserProfileFailedState extends UserprofileState {
  final String error;

  UserProfileFailedState({required this.error});
}

class UserProfileEmptyState extends UserprofileState {
  final String userid;
  final String email;

  UserProfileEmptyState({required this.userid, required this.email});
}

class CreateUserProfilestaffsuccessState extends UserprofileState {}

class CreateUserProfilestaffLoadingState extends UserprofileState {}

class CreateUserProfilestaffFailedState extends UserprofileState {
  final String error;

  CreateUserProfilestaffFailedState({required this.error});
}
