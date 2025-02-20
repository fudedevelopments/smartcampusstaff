import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smartcampusstaff/bloc/repo/userprofilerepo.dart';
import 'package:smartcampusstaff/models/ModelProvider.dart';

part 'userprofile_event.dart';
part 'userprofile_state.dart';

class UserprofileBloc extends Bloc<UserprofileEvent, UserprofileState> {
  UserprofileBloc() : super(UserprofileInitial()) {
    on<GetUserProfileEvent>(getUserProfileEvent);
    on<UserprofileCreateEvent>(userprofileCreateEvent);
  }

  Future<void> getUserProfileEvent(
      GetUserProfileEvent event, Emitter<UserprofileState> emit) async {
    emit(UserProfileLoadingState());
    try {
      final userProfile = await UserProfileRepo().getUserProfile(userId: event.userid);

      if (userProfile == null) {
        emit(UserProfileEmptyState(userid: event.userid, email: event.email));
      } else {
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

      await UserProfileRepo().createUserProfileStaff(userprofile: event.userProfile);

      emit(CreateUserProfilestaffsuccessState());
    } catch (e) {
      emit(CreateUserProfilestaffFailedState(error: e.toString()));
    }
  }


   
    
}

