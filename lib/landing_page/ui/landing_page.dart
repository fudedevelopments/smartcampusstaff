// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartcampusstaff/bloc/userprofile_bloc.dart';
import 'package:smartcampusstaff/home/homeui.dart';
import 'package:smartcampusstaff/landing_page/landiing_bloc/landing_page_bloc.dart';
import 'package:smartcampusstaff/onduty/ui/ondutyUI.dart';
import 'package:smartcampusstaff/profile/profileui.dart';
import 'package:smartcampusstaff/utils/image_cache_service.dart';
import 'package:get/get.dart';
import 'package:smartcampusstaff/utils/authservices.dart';
import 'package:smartcampusstaff/utils/apicall.dart';
import 'package:smartcampusstaff/home/apicallevent.dart';

List<BottomNavigationBarItem> bottomnavItem = [
  const BottomNavigationBarItem(
    icon: Icon(Icons.dashboard_rounded),
    label: "Dashboard",
    activeIcon: Icon(Icons.dashboard_rounded, size: 28),
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.assignment_outlined),
    label: "Permission",
    activeIcon: Icon(Icons.assignment, size: 28),
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.person_outline),
    label: "Profile",
    activeIcon: Icon(Icons.person, size: 28),
  ),
];

List<Widget> bottomnaviScreen = [
  const Home(),
  const OndutyUI(),
  const UserProfilePage(),
];

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  // Method to clear image cache and refresh data
  void _refreshApp(BuildContext context, int currentTabIndex) {
    // Clear image caches
    ImageCacheService().clearAllCaches();

    final authService = AuthService();

    // Refresh the current tab's data based on index
    switch (currentTabIndex) {
      case 0: // Home tab
        // Use GetX to find and refresh the EventController
        if (Get.isRegistered<EventController>()) {
          Get.find<EventController>().refreshData();
        }
        break;
      case 1: // OndutyUI tab
        // Use GetX to find and refresh the OndutyController
        if (Get.isRegistered<OndutyController>()) {
          Get.find<OndutyController>().refreshData(
            tablename: "onDutyModel-2jskpek75veajd4yfnqjmkppmu-NONE",
            indexname:
                "onDutyModelsByProctorAndCreatedAt", // Default to Proctor
            token: authService.idToken!,
            limit: 5,
            partitionKey: "Proctor",
            partitionKeyValue: authService.sub!,
          );
        }
        break;
      case 2: // Profile tab
        // Refresh user profile if needed
        if (context.read<UserprofileBloc>().state is UserProfileSucessState) {
          final state =
              context.read<UserprofileBloc>().state as UserProfileSucessState;
          context.read<UserprofileBloc>().add(
                GetUserProfileEvent(
                  email: state.userProfile.email,
                  userid: state.userProfile.id,
                ),
              );
        }
        break;
    }

    // Show a snackbar to indicate refresh
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Refreshed data and cleared image cache'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserprofileBloc, UserprofileState>(
      builder: (context, userState) {
        return BlocConsumer<LandingPageBloc, LandingPageState>(
          listener: (context, state) {},
          builder: (context, state) {
            String staffName = '';
            if (userState is UserProfileSucessState) {
              staffName = userState.userProfile.name;
            }

            return Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(60.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.asset(
                              'assets/images/icon.jpeg',
                              height: 35,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Smart Campus Staff',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              if (staffName.isNotEmpty)
                                Text(
                                  staffName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () => _refreshApp(context, state.tabindex),
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined),
                          onPressed: () {
                            // TODO: Implement notifications
                          },
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
              ),
              body: Container(
                color: Colors.grey[50],
                child: bottomnaviScreen.elementAt(state.tabindex),
              ),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: BottomNavigationBar(
                  items: bottomnavItem,
                  currentIndex: state.tabindex,
                  selectedItemColor: Theme.of(context).primaryColor,
                  unselectedItemColor: Colors.grey,
                  showUnselectedLabels: true,
                  type: BottomNavigationBarType.fixed,
                  selectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  onTap: (index) {
                    BlocProvider.of<LandingPageBloc>(context)
                        .add(TabChangeEvent(tabindex: index));
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
