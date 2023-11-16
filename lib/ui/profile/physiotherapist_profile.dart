import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_app_theraphy/config/app_config.dart';
import 'package:mobile_app_theraphy/config/navBar.dart';
import 'package:mobile_app_theraphy/data/model/available_hour.dart';
import 'package:mobile_app_theraphy/data/model/physiotherapist.dart';
import 'package:mobile_app_theraphy/data/remote/http_helper.dart';
import 'package:mobile_app_theraphy/data/remote/services/availableHour/available_hour_service.dart';
import 'package:mobile_app_theraphy/data/remote/services/physiotherapist/physiotherapist_service.dart';
import 'package:mobile_app_theraphy/ui/patients/patients-list.dart';
import 'package:mobile_app_theraphy/ui/profile/available_hour.dart';
import 'package:mobile_app_theraphy/ui/profile/edit_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedIndex = 4;
  AvailableHourService? _availableHourService;
  List<AvailableHour>? _availableHours;
  PhysiotherapistService? _physiotherapistService;
  Physiotherapist? _physiotherapist;
  HttpHelper? _httpHelper;
  int? id;

  List<Widget> pages = const [
    PatientsList(),
    ProfilePage(),
    ProfilePage(),
    ProfilePage(),
    ProfilePage(),
  ];

  Future initialize() async {
    _availableHours = List.empty();
    id = await _httpHelper?.getPhysiotherapistLogged();
    _availableHours = await _availableHourService?.getByPhysiotherapistId(id!);

    _physiotherapist =
        await _physiotherapistService?.getPhysiotherapistById(id!);
    setState(() {
      _availableHours = _availableHours;
    });
  }

  @override
  void initState() {
    _availableHourService = AvailableHourService();
    _physiotherapistService = PhysiotherapistService();
    _httpHelper = HttpHelper();
    initialize();
    super.initState();
  }

  bool isButtonEnabled = true;
  final TextEditingController dayController = TextEditingController();
  final TextEditingController hourController = TextEditingController();
  int maxElementCount = 6;

  List<Color> cardColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
  ];

  bool isValidHourFormat(String hour) {
    // Verificar si la hora tiene uno de los formatos válidos usando una expresión regular
    RegExp regex = RegExp(
        r'^\d{1,2}:\d{2}-\d{1,2}:\d{2}$|^\d{1,2}:\d{2}\s*-\s*\d{1,2}:\d{2}$');
    return regex.hasMatch(hour);
  }

  @override
  Widget build(BuildContext context) {
    isButtonEnabled = (_availableHours?.length ?? 0) < maxElementCount;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              "My Profile",
              style: TextStyle(
                color: AppConfig.primaryColor,
                fontSize: 24,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          automaticallyImplyLeading: false,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        NetworkImage(_physiotherapist?.photoUrl ?? ""),
                    backgroundColor: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 2.5,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(_createRoute(_physiotherapist!.photoUrl));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _physiotherapist?.user.firstname ?? "",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _physiotherapist?.user.role ?? "",
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    _physiotherapist?.specialization ?? "",
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    _physiotherapist?.user.username ?? "",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  Visibility(
                    visible: _availableHours?.isNotEmpty == true,
                    child: const Text(
                      "Your available schedules: ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Visibility(
                    visible: _availableHours?.isNotEmpty == true,
                    child: SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _availableHours?.length ?? 0,
                        itemBuilder: (context, index) {
                          Color cardColor =
                              cardColors[index % cardColors.length];
                          return InkWell(
                            onTap: () {
                              dayController.text =
                                  _availableHours?[index].day ?? '';
                              hourController.text =
                                  _availableHours?[index].hours ?? '';
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Edit availability hour"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          controller: dayController,
                                          decoration: const InputDecoration(
                                              labelText: "Day"),
                                        ),
                                        TextFormField(
                                          controller: hourController,
                                          decoration: const InputDecoration(
                                              labelText: "Hour"),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Cierra el diálogo
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          final String updatedDay =
                                              dayController.text.isNotEmpty
                                                  ? dayController.text
                                                  : _availableHours![index].day;

                                          final String updatedHour =
                                              hourController.text.isNotEmpty
                                                  ? hourController.text
                                                  : _availableHours![index]
                                                      .hours;

                                          if (isValidHourFormat(updatedHour)) {
                                            _availableHourService
                                                ?.updateAvailableHour(
                                                    _availableHours![index].id,
                                                    updatedDay,
                                                    updatedHour)
                                                .then((value) {
                                              initialize();
                                              Fluttertoast.showToast(
                                                msg:
                                                    'Updated data successfully',
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 2,
                                                backgroundColor: Colors.green,
                                                textColor: Colors.white,
                                              );
                                              Navigator.of(context).pop();
                                            });
                                          } else {
                                            Fluttertoast.showToast(
                                              msg:
                                                  'Invalid hour format. Please use "hr:00-hr:00" or "hr:00 - hr:00" format.',
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 2,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                            );
                                          }
                                        },
                                        child: const Text("Save"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: 80,
                              height: 80,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${_availableHours?[index].day}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${_availableHours?[index].hours}",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditProfilePage()),
                      );
                    },
                    child: const Text("Edit Profile"),
                  ),
                  ElevatedButton(
                    onPressed: isButtonEnabled
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AvailabilityPage(id: id!),
                              ),
                            ).then((value) => initialize());
                          }
                        : null,
                    child: const Text("Enter your schedules"),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar:NavBar(currentIndex: 2)
      ),
    );
  }

  PageRouteBuilder _createRoute(String imageUrl) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return FullScreenImage(imageUrl: imageUrl);
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOut;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var fadeAnimation = animation.drive(tween);
        return FadeTransition(
          opacity: fadeAnimation,
          child: child,
        );
      },
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network(imageUrl),
          ),
        ),
      ),
    );
  }
}
