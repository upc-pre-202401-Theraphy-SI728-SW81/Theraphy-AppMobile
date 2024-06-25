import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_theraphy/config/app_config.dart';
import 'package:mobile_app_theraphy/data/model/therapy.dart';
import 'package:mobile_app_theraphy/ui/consultations/consultation_list.dart';
import 'package:mobile_app_theraphy/ui/home/home.dart';
import 'package:mobile_app_theraphy/ui/iot_devices/iot-devices-list.dart';
import 'package:mobile_app_theraphy/ui/patients/patients-list.dart';
import 'package:mobile_app_theraphy/ui/profile/physiotherapist_profile.dart';
import 'package:mobile_app_theraphy/ui/security/sign-up.dart';
import 'package:mobile_app_theraphy/ui/therapy/my-therapy.dart';
class NavBar extends StatefulWidget {
  final int currentIndex;

  const NavBar({super.key, required this.currentIndex});

  @override
  State<NavBar> createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.white,
      color: AppConfig.primaryColor,
      animationDuration: const Duration(milliseconds: 300),
      items: const [
        Icon(Icons.home, color: Colors.white),
        Icon(Icons.group, color: Colors.white),
        Icon(Icons.account_circle, color: Colors.white),
        Icon(Icons.calendar_month, color: Colors.white),
        Icon(Icons.router_rounded, color: Colors.white),
      ],
      index: widget.currentIndex, // Utiliza el valor proporcionado en el constructor
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePhysiotherapist(),
              ),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PatientsList(),
              ),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfilePage(),
              ),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ConsultationsList(),
              ),
            );
            break;
          case 4:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const IotdevicesList(),
              ),
            );
            break;
        }
      },
    );
  }
}
