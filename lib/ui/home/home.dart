import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:mobile_app_theraphy/config/app_config.dart';
import 'package:mobile_app_theraphy/config/navBar.dart';
import 'package:mobile_app_theraphy/data/model/appointment.dart';
import 'package:mobile_app_theraphy/data/model/consultation.dart';
import 'package:mobile_app_theraphy/data/model/patient.dart';
import 'package:mobile_app_theraphy/data/model/physiotherapist.dart';
import 'package:mobile_app_theraphy/data/remote/http_helper.dart';
import 'package:mobile_app_theraphy/ui/patients/patient-profile.dart';
import 'package:mobile_app_theraphy/ui/security/patient-register.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePhysiotherapist extends StatefulWidget {
  const HomePhysiotherapist({super.key});

  @override
  State<HomePhysiotherapist> createState() => _HomePhysiotherapistState();
}

class _HomePhysiotherapistState extends State<HomePhysiotherapist> {
  HttpHelper? _httpHelper;
  List<Patient>? myPatients = [];
  List<Appointment>? myAppointments = [];
  List<Consultation>? myConsultations = [];
  List<Physiotherapist>? physiotherapists;
  List<Physiotherapist>? physioterapist;

  int? id;
  Physiotherapist? physiotherapistLogged;
  bool _showAppointments = true;

  LocationData? currentLocation;
  bool isCitizen = false;
  bool isSerenity = false;

  Future<void> _requestLocationPermission() async {
    var status = await Permission.locationWhenInUse.status;

    if (status.isDenied) {
      await Permission.locationWhenInUse.request();
    }

    if (status.isGranted) {
      _getCurrentLocation();
    }
  }

  void _getCurrentLocation() {
    Location location = Location();
    location.getLocation().then((locationData) {
      setState(() {
        currentLocation = locationData;
        print(currentLocation);
      });
    }).catchError((error) {
      print("Error al obtener la ubicación: $error");
    });
  }

  Future initialize() async {
    _requestLocationPermission();
    _getCurrentLocation();

    //Get user logged
    //id = await _httpHelper?.getPhysiotherapistLogged();
    physiotherapistLogged = await _httpHelper?.getPhysiotherapist();
    id = physiotherapistLogged?.id;

    // Get Lists
    // ignore: sdk_version_since
    physiotherapists = List.empty();
    myPatients = List.empty();
    myPatients = await _httpHelper?.getMyPatients(id!) ?? [];
    myAppointments = List.empty();
    myAppointments =
        await _httpHelper?.getAllAppointmentsByPhysiotherapistIdNoDone(id!) ??
            [];
    myConsultations = List.empty();
    myConsultations = await _httpHelper?.getMyConsultationsNoDone(id!) ?? [];

    //Update lists
    setState(() {
      id = id;
      physiotherapistLogged = physiotherapistLogged;
      physiotherapists = physiotherapists;
      myPatients = myPatients;
      myAppointments = myAppointments;
      myConsultations = myConsultations;
    });
  }

  @override
  void initState() {
    _httpHelper = HttpHelper();
    initialize();
    super.initState();
  }

  String upcomingText = 'appointments';
  Color colorUpcomingCards = const Color(0xFFC7B6E4);
  String selectedCategory = 'appointments';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Hello, ${physiotherapistLogged?.user.firstname}",
            style: TextStyle(color: AppConfig.primaryColor),
          ),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0,
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                const Padding(
                  padding: EdgeInsets.only(left: 15, top: 25, bottom: 15),
                  child: Text(
                    'Patients',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ]),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 120.0,
                child: ImageCarousel(myPatients: myPatients),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                const Padding(
                  padding: EdgeInsets.only(left: 15, top: 10, bottom: 5),
                  child: Row(
                    children: [
                      Text(
                        'Categories',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(
                  height: 15.0,
                ),
              ]),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            upcomingText = 'appointments';
                            _showAppointments = true;
                            colorUpcomingCards = const Color(0xFFC7B6E4);
                            selectedCategory = 'appointments';
                          });
                        },
                        child: Card(
                          color: const Color(0xFFC7B6E4), // Color de Card 1
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 15.0, top: 10.0),
                                  child: Text(
                                    'Appointments',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, top: 5.0),
                                  child: Text(
                                    myAppointments!.length.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(0),
                                child: Image.asset('assets/appointments3.png'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showAppointments = false;
                            upcomingText = 'consultations';
                            colorUpcomingCards = const Color(0xFFB1D7F3);
                            selectedCategory = 'consultations';
                          });
                        },
                        child: Card(
                          color: const Color(0xFFB1D7F3), // Color de Card 2
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 15.0, top: 10.0),
                                  child: Text(
                                    'Consultations',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, top: 5.0),
                                  child: Text(
                                    myConsultations!.length.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(0),
                                child: Image.asset('assets/consultation.png'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(
                  height: 15.0,
                ),
              ]),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 10, bottom: 5),
                  child: Text(
                    'Upcoming $upcomingText',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ]),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(
                  height: 15.0,
                ),
              ]),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (_showAppointments) {
                    return AppointmentItem(appointment: myAppointments![index]);
                  } else {
                    return ConsultationItem(
                        consultation: myConsultations![index]);
                  }
                },
                childCount: _showAppointments
                    ? myAppointments?.length
                    : myConsultations?.length,
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(
                  height: 15.0,
                ),
              ]),
            ),
          ],
        ),
        bottomNavigationBar: NavBar(currentIndex: 0));
  }
}

class ConsultationItem extends StatefulWidget {
  const ConsultationItem({super.key, required this.consultation});
  final Consultation consultation;

  @override
  State<ConsultationItem> createState() => _ConsultationItemState();
}

class _ConsultationItemState extends State<ConsultationItem> {
  @override
  Widget build(BuildContext context) {
    String fullName =
        "${widget.consultation.patient.user.firstname} ${widget.consultation.patient.user.lastname}";
    String displayName;

    int maxDisplayNameLength = 20;

    if (fullName.length > maxDisplayNameLength) {
      displayName =
          "${widget.consultation.patient.user.firstname} ${widget.consultation.patient.user.lastname[0]}.";
    } else {
      displayName = fullName;
    }

    String formattedDate = '';
    String formattedTime = '';

    try {
      // Formatear fecha
      DateTime parsedDate =
          DateFormat('dd-MM-yyyy').parse(widget.consultation.date);
      formattedDate = DateFormat('MMMM dd, yyyy').format(parsedDate);

      // Formatear hora
      DateTime parsedTime = DateFormat('HH:mm').parse(widget.consultation.hour);
      formattedTime = DateFormat('h:mm a').format(parsedTime);
    } catch (e) {
      print('Error parsing date or time: $e');
    }
    return FractionallySizedBox(
      widthFactor: 0.9,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: Colors.white,
        elevation: 1,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: AppConfig.primaryColor,
                width: 7,
                style: BorderStyle.solid,
              ),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Hero(
                          tag: widget.consultation.id,
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            constraints: const BoxConstraints(
                              minWidth: 80.0,
                              maxWidth: 80.0,
                              minHeight: 80,
                              maxHeight: 80,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image(
                                image: NetworkImage(
                                    widget.consultation.patient.photoUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppConfig.primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "$formattedDate  |  $formattedTime",
                                  style: const TextStyle(
                                    color: Color(0xFFB1D7F3),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Divider(
                  color: Color(0xFFB1D7F3),
                  height: 10,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB1D7F3),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            "Topic: ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.consultation.topic,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB1D7F3),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            "At: ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.consultation.place,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppointmentItem extends StatefulWidget {
  const AppointmentItem({super.key, required this.appointment});
  final Appointment appointment;

  @override
  State<AppointmentItem> createState() => _AppointmentItemState();
}

class _AppointmentItemState extends State<AppointmentItem> {
  @override
  Widget build(BuildContext context) {
String fullName =
        "${widget.appointment.therapy.patient.user.firstname} ${widget.appointment.therapy.patient.user.lastname}";
    String displayName;

    int maxDisplayNameLength = 20;

    if (fullName.length > maxDisplayNameLength) {
      displayName =
          "${widget.appointment.therapy.patient.user.firstname} ${widget.appointment.therapy.patient.user.lastname[0]}.";
    } else {
      displayName = fullName;
    }

    String formattedDate = '';
    String formattedTime = '';

    try {
      // Formatear fecha
      DateTime parsedDate =
          DateFormat('yyyy-MM-dd').parse(widget.appointment.date);
      formattedDate = DateFormat('MMMM dd, yyyy').format(parsedDate);

      // Formatear hora
      DateTime parsedTime = DateFormat('HH:mm').parse(widget.appointment.hour);
      formattedTime = DateFormat('h:mm a').format(parsedTime);
    } catch (e) {
      print('Error parsing date or time: $e');
    }

    return FractionallySizedBox(
      widthFactor: 0.9,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: Colors.white,
        elevation: 1,
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Color.fromARGB(255, 174, 82, 190),
                width: 7,
                style: BorderStyle.solid,
              ),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Hero(
                          tag: widget.appointment.id,
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            constraints: const BoxConstraints(
                              minWidth: 80.0,
                              maxWidth: 80.0,
                              minHeight: 80,
                              maxHeight: 80,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image(
                                image: NetworkImage(widget
                                    .appointment.therapy.patient.photoUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 174, 82, 190),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "$formattedDate  |  $formattedTime",
                                  style: const TextStyle(
                                    color: Color(0xFFC7B6E4),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Divider(
                  color: Color(0xFFC7B6E4),
                  height: 10,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC7B6E4),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            "Topic: ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.appointment.topic,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC7B6E4),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            "At: ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.appointment.place,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageCarousel extends StatelessWidget {
  final List<Patient>? myPatients;

  const ImageCarousel({Key? key, required this.myPatients}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: myPatients?.length ?? 0,
      itemBuilder: (context, index) {
        final patient = myPatients?[index];

        if (patient == null) {
          return Container();
        }

        return Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Row(
            children: [
              Card(
                color: Colors.transparent,
                elevation: 0.0,
                child: GestureDetector(
                  onTap: () {
                    // Navegar a la vista del perfil del paciente al tocar la imagen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientProfile(
                          patient: patient,
                        ), //PatientProfileView(patient: patient),
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'image_hero_${patient.id}',
                    child: Container(
                      height: 180.0,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2.0),
                            constraints: const BoxConstraints(
                              minWidth: 80.0,
                              maxWidth: 80.0,
                              minHeight: 80,
                              maxHeight: 80,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue,
                                width: 2.0,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Image(
                                image: NetworkImage(patient.photoUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: 80.0,
                            child: SizedBox(
                              height: 20.0,
                              child: Center(
                                child: Text(
                                  patient.user.firstname,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
