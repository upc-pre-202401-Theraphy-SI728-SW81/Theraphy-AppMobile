import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_theraphy/data/model/therapy.dart';
import 'package:mobile_app_theraphy/ui/patients/patients-list.dart';
import 'package:mobile_app_theraphy/ui/profile/physiotherapist_profile.dart';
import 'package:mobile_app_theraphy/ui/security/sign-up.dart';
import 'package:mobile_app_theraphy/ui/therapy/my-therapy.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBar> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: const Color.fromARGB(255, 25, 118, 210),
        animationDuration: Duration(milliseconds: 300),
        items: [
          Icon(Icons.home),
          Icon(Icons.group),
          Icon(Icons.account_circle),
          Icon(Icons.calendar_month),
          Icon(Icons.video_library)
        ],
        onTap: (index) {
          switch (index) {
            case 0:
               Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUp(),
                    ));
              break;
            case 1:
               Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PatientsList(),
                    ));
              break;
            case 2:
               Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ));
              break;
            case 3:
               Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUp(),
                    ));
              break;
            case 4:
               Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyTherapy(),
                    ));
              break;
          }
        }
      ),
    );
  }
}