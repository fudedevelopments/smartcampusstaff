import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartcampusstaff/amplify_outputs.dart';
import 'package:smartcampusstaff/bloc/registrationform.dart';
import 'package:smartcampusstaff/bloc/userprofile_bloc.dart';
import 'package:smartcampusstaff/components/authenticator_widget.dart';
import 'package:smartcampusstaff/components/errorspage.dart';
import 'package:smartcampusstaff/firebase_options.dart';
import 'package:smartcampusstaff/landing_page/landiing_bloc/landing_page_bloc.dart';
import 'package:smartcampusstaff/landing_page/ui/landing_page.dart';
import 'package:smartcampusstaff/models/ModelProvider.dart';
import 'package:smartcampusstaff/utils/authservices.dart';
import 'package:smartcampusstaff/utils/firebaseapi.dart';

Future<void> _configureAmplify() async {
  try {
    final api = AmplifyAPI(
        options: APIPluginOptions(modelProvider: ModelProvider.instance));
    final auth = AmplifyAuthCognito();
    final storage = AmplifyStorageS3();
    await Amplify.addPlugins([auth, api, storage]);
    await Amplify.configure(amplifyConfig);
  } on Exception catch (e) {
    safePrint('An error occurred configuring Amplify: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureAmplify();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotification();
  await AuthService().fetchIdToken();
  await AuthService().fetchUserAttributes();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => LandingPageBloc(),
      ),
      BlocProvider(
        create: (context) => UserprofileBloc(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    fetchCurrentUserAttributes();
  }

  Future<void> fetchCurrentUserAttributes() async {
    try {
      final result = await Amplify.Auth.fetchUserAttributes();

      String? email;
      String? sub;

      for (final element in result) {
        if (element.userAttributeKey.key == 'email') {
          email = element.value;
        } else if (element.userAttributeKey.key == 'sub') {
          sub = element.value;
        }
      }
      BlocProvider.of<UserprofileBloc>(context)
          .add(GetUserProfileEvent(email: email!, userid: sub!));
    } on AuthException catch (e) {
      safePrint('Error fetching user attributes: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthenticatorWidget(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: Authenticator.builder(),
        home: BlocBuilder<UserprofileBloc, UserprofileState>(
          builder: (context, state) {
            if (state is UserProfileLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is UserProfileEmptyState) {
              return StaffRegistrationForm(
                userid: state.userid,
                email: state.email,
              );
            }
            if (state is UserProfileSucessState) {
              return LandingPage();
            }
            if (state is UserProfileFailedState) {
              return ErrorPage(errorMessage: state.error, onRetry: () {});
            } else {
              return Scaffold(
                body: Center(child: Text("Please Wait Your State is Loading")),
              );
            }
          },
        ),
      ),
    );
  }
}
