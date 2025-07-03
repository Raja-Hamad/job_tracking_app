
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_tracking_app/utils/extensions/app_colors.dart';
import 'package:job_tracking_app/views/all_resumes.dart';
import 'package:job_tracking_app/views/dashboard_view.dart';
import 'package:job_tracking_app/views/profile_view.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
 

  List<Widget> screens = [
    DashboardView(),
    AllResumes(),
    ProfileView(),
 
  ];

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      backgroundColor: AppColors.primary,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.primary,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        selectedLabelStyle: GoogleFonts.poppins(color: Colors.white),
        unselectedLabelStyle: GoogleFonts.poppins(color: Colors.white),
        items: [
       
          BottomNavigationBarItem(
            icon:Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner),
            label: "Resume",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }


}
