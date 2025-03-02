import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';
import 'package:smartcampusstaff/components/customscaffold.dart';

class AuthenticatorWidget extends StatelessWidget {
  final Widget child;
  const AuthenticatorWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      authenticatorBuilder: (BuildContext context, AuthenticatorState state) {
        switch (state.currentStep) {
          case AuthenticatorStep.signIn:
            return CustomScaffold(
              state: state,
              body: Column(
                children: [
                  const SizedBox(height: 5),
                  const Text(
                    "Welcome to Smart Campus",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Staff SignIn",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  SignInForm(),
                ],
              ),
            );
          case AuthenticatorStep.resetPassword:
            return CustomScaffold(
              state: state,
              body: ResetPasswordForm(),
            );
          case AuthenticatorStep.confirmResetPassword:
            return CustomScaffold(
              state: state,
              body: const ConfirmResetPasswordForm(),
            );
          default:
            return null;
        }
      },
      child: child,
    );
  }
}
