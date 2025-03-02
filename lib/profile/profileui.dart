import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartcampusstaff/bloc/userprofile_bloc.dart';
import 'package:smartcampusstaff/components/errorspage.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserprofileBloc, UserprofileState>(
      builder: (context, state) {
        if (state is UserProfileSucessState) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.blue.shade50
                  ], // Soft glossy gradient
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey.shade100,
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Profile Avatar with Border
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue.shade100,
                        child: CircleAvatar(
                            radius: 45,
                            backgroundImage:
                                AssetImage('assets/images/user.png')),
                      ),
                      SizedBox(height: 20),

                      // User Information List
                      _buildUserInfo(
                          Icons.perm_identity, "ID", state.userProfile.id),
                      _buildUserInfo(
                          Icons.person, "Name", state.userProfile.name),
                      _buildUserInfo(
                          Icons.email, "Email", state.userProfile.email),
                      _buildUserInfo(Icons.business, "Department",
                          state.userProfile.department),
                      _buildUserInfo(Icons.school, "Qualification",
                          state.userProfile.qualification),

                      SizedBox(height: 20),
                      // Edit Profile Button
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                        ),
                        child: Text(
                          "Edit Profile",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),

                      SizedBox(height: 20),
                      // Sign Out Button
                      SignOutButton()
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return ErrorPage(
              errorMessage: "Your Profile is not configured", onRetry: () {});
        }
      },
    );
  }

  Widget _buildUserInfo(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent.shade700, size: 22),
          SizedBox(width: 12),
          Text(
            "$title: ",
            style: TextStyle(
              color: Colors.blueGrey.shade800,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.blueGrey.shade900,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
