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
import 'package:smartcampusstaff/components/loadinguser.dart';
import 'package:smartcampusstaff/components/pleasewaitPage.dart';
import 'package:smartcampusstaff/components/splash_screen.dart';
import 'package:smartcampusstaff/firebase_options.dart';
import 'package:smartcampusstaff/landing_page/landiing_bloc/landing_page_bloc.dart';
import 'package:smartcampusstaff/landing_page/ui/landing_page.dart';
import 'package:smartcampusstaff/models/ModelProvider.dart';
import 'package:smartcampusstaff/utils/authservices.dart';
import 'package:smartcampusstaff/utils/firebaseapi.dart';
import 'package:smartcampusstaff/utils/image_cache_service.dart';
import 'package:get/get.dart';

// NEC brand colors
class NECColors {
  static const Color darkBlue = Color(0xFF1A237E);
  static const Color mediumBlue = Color(0xFF3949AB);
  static const Color lightBlue = Color(0xFF5C6BC0);
  static const Color paleBlue = Color(0xFFE8EAF6);
  static const Color accentBlue = Color(0xFFC5CAE9);
}

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

  ImageCacheService().clearAllCaches();

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
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();

    if (authService.isSignedIn &&
        authService.email != null &&
        authService.sub != null) {
      BlocProvider.of<UserprofileBloc>(context).add(GetUserProfileEvent(
          email: authService.email!, userid: authService.sub!));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define the app theme with NEC branding
    final theme = ThemeData(
      primarySwatch: Colors.indigo,
      primaryColor: NECColors.darkBlue,
      colorScheme: const ColorScheme.light(
        primary: NECColors.darkBlue,
        secondary: NECColors.mediumBlue,
        background: Colors.white,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Colors.black87,
        onSurface: Colors.black87,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: NECColors.darkBlue,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      cardTheme: CardTheme(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: NECColors.darkBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: NECColors.mediumBlue,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: NECColors.accentBlue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: NECColors.accentBlue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: NECColors.mediumBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        labelStyle: const TextStyle(color: NECColors.lightBlue),
        floatingLabelStyle: const TextStyle(color: NECColors.mediumBlue),
      ),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        displayLarge:
            TextStyle(fontWeight: FontWeight.bold, color: NECColors.darkBlue),
        displayMedium:
            TextStyle(fontWeight: FontWeight.bold, color: NECColors.darkBlue),
        displaySmall:
            TextStyle(fontWeight: FontWeight.bold, color: NECColors.darkBlue),
        headlineMedium:
            TextStyle(fontWeight: FontWeight.bold, color: NECColors.darkBlue),
        titleLarge:
            TextStyle(fontWeight: FontWeight.bold, color: NECColors.darkBlue),
      ),
    );

    return AuthenticatorWidget(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        builder: Authenticator.builder(),
        home: SplashScreen(
          nextScreen: _buildMainContent(),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return BlocBuilder<UserprofileBloc, UserprofileState>(
      builder: (context, state) {
        if (state is UserProfileLoadingState) {
          return Center(
            child: UserLoadingIndicator(),
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
            body: PleaseWaitPage(
              message: "Please Wait We are Getting Your Data",
            ),
          );
        }
      },
    );
  }
}
