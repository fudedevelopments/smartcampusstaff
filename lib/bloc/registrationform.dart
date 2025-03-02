import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartcampusstaff/bloc/userprofile_bloc.dart';
import 'package:smartcampusstaff/models/ModelProvider.dart';
import 'package:smartcampusstaff/utils/firebaseapi.dart';
import 'package:smartcampusstaff/utils/utils.dart';

class StaffRegistrationForm extends StatelessWidget {
  final String userid;
  final String email;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _qualificationController =
      TextEditingController();

  StaffRegistrationForm({super.key, required this.userid, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 600),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Staff Registration',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32),
                  _buildNameField(),
                  SizedBox(height: 24),
                  _buildEmailField(),
                  SizedBox(height: 24),
                  _buildDepartmentField(),
                  SizedBox(height: 24),
                  _buildQualificationField(),
                  SizedBox(height: 32),
                  _buildSubmitButton(context),
                  SizedBox(height: 60),
                  Text(
                    'You are Logged in Wrong Email',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  SignOutButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Full Name',
        prefixIcon: Icon(Icons.person, color: Colors.blue[800]),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[800]!),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter full name';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email Address',
        prefixIcon: Icon(Icons.email, color: Colors.blue[800]),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[800]!),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter email address';
        }
        return null;
      },
    );
  }

  Widget _buildDepartmentField() {
    return TextFormField(
      controller: _departmentController,
      decoration: InputDecoration(
        labelText: 'Department',
        prefixIcon: Icon(Icons.business, color: Colors.blue[800]),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[800]!),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter department';
        }
        return null;
      },
    );
  }

  Widget _buildQualificationField() {
    return TextFormField(
      controller: _qualificationController,
      decoration: InputDecoration(
        labelText: 'Highest Qualification',
        prefixIcon: Icon(Icons.school, color: Colors.blue[800]),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[800]!),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter qualification';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[800],
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {
        final firebasetoken = FirebaseApi().token;
        if (_formKey.currentState!.validate()) {
          if (firebasetoken != null) {
            BlocProvider.of<UserprofileBloc>(context).add(
                UserprofileCreateEvent(
                    userProfile: StaffUserProfile(
                        id: userid,
                        name: _nameController.text,
                        email: _emailController.text,
                        department: _departmentController.text,
                        qualification: _qualificationController.text,
                        deviceToken: firebasetoken)));
          }
        }
      },
      child: BlocConsumer<UserprofileBloc, UserprofileState>(
        listener: (context, state) {
          if (state is CreateUserProfilestaffsuccessState) {
            showsnakbar(context, "You Profile Registered SuccessFully");
            BlocProvider.of<UserprofileBloc>(context)
                .add(GetUserProfileEvent(email: email, userid: userid));
          }
          if (state is CreateUserProfilestaffFailedState) {
            showsnakbar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is CreateUserProfilestaffLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Text(
              'REGISTER STAFF',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            );
          }
        },
      ),
    );
  }
}
