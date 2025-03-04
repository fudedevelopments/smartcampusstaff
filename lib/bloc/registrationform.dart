import 'dart:async';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartcampusstaff/bloc/repo/userprofilerepo.dart';
import 'package:smartcampusstaff/bloc/userprofile_bloc.dart';
import 'package:smartcampusstaff/models/ModelProvider.dart';
import 'package:smartcampusstaff/utils/firebaseapi.dart';
import 'package:smartcampusstaff/utils/utils.dart';

class StaffRegistrationForm extends StatefulWidget {
  final String userid;
  final String email;
  final StaffUserProfile? existingProfile;
  final bool isEditing;

  StaffRegistrationForm({
    super.key,
    required this.userid,
    required this.email,
    this.existingProfile,
    this.isEditing = false,
  });

  @override
  State<StaffRegistrationForm> createState() => _StaffRegistrationFormState();
}

class _StaffRegistrationFormState extends State<StaffRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _qualificationController =
      TextEditingController();

  bool _isLoading = false;
  bool _isRegistered = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
    if (widget.existingProfile != null) {
      _nameController.text = widget.existingProfile!.name;
      _departmentController.text = widget.existingProfile!.department;
      _qualificationController.text = widget.existingProfile!.qualification;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue[800]),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.isEditing ? 'Edit Profile' : 'Staff Registration',
          style: TextStyle(
            color: Colors.blue[800],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
                  if (!widget.isEditing) ...[
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
                  ],
                  _buildNameField(),
                  SizedBox(height: 24),
                  _buildEmailField(),
                  SizedBox(height: 24),
                  _buildDepartmentField(),
                  SizedBox(height: 24),
                  _buildQualificationField(),
                  SizedBox(height: 32),
                  _isRegistered
                      ? _buildContinueButton(context)
                      : _buildSubmitButton(context),
                  if (!widget.isEditing) ...[
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
      enabled: false, // Email should not be editable
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email Address',
        prefixIcon: Icon(Icons.email, color: Colors.blue[800]),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[800]!),
        ),
        filled: true,
        fillColor: Colors.grey[100],
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
      onPressed: _isLoading ? null : _handleSubmit,
      child: _isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              widget.isEditing ? 'UPDATE PROFILE' : 'REGISTER STAFF',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 48,
        ),
        SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            BlocProvider.of<UserprofileBloc>(context).add(
              GetUserProfileEvent(
                email: widget.email,
                userid: widget.userid,
              ),
            );
            Navigator.of(context).pop(true);
          },
          child: Text(
            'CONTINUE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    final firebasetoken = FirebaseApi().token;
    if (_formKey.currentState!.validate()) {
      if (firebasetoken != null) {
        setState(() {
          _isLoading = true;
        });

        try {
          final userProfile = StaffUserProfile(
            id: widget.userid,
            name: _nameController.text,
            email: _emailController.text,
            department: _departmentController.text,
            qualification: _qualificationController.text,
            deviceToken: firebasetoken,
          );

          if (widget.isEditing) {
            await UserProfileRepo()
                .updateUserProfileStaff(userprofile: userProfile);
            showsnakbar(context, "Profile Updated Successfully");
            Navigator.of(context).pop(true);
          } else {
            await UserProfileRepo()
                .createUserProfileStaff(userprofile: userProfile);
            setState(() {
              _isLoading = false;
              _isRegistered = true;
            });
            showsnakbar(context, "Your Profile Registered Successfully");
          }

          // Refresh the profile data
          BlocProvider.of<UserprofileBloc>(context).add(
            GetUserProfileEvent(
              email: widget.email,
              userid: widget.userid,
            ),
          );
        } catch (e) {
          setState(() {
            _isLoading = false;
          });
          showsnakbar(context, e.toString());
        }
      } else {
        showsnakbar(context, "Device token not available. Please try again.");
      }
    }
  }
}
