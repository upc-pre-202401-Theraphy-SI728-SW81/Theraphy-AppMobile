import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mobile_app_theraphy/config/app_config.dart';

import 'package:mobile_app_theraphy/config/navBar.dart';

import 'package:mobile_app_theraphy/data/model/appointment.dart';
import 'package:mobile_app_theraphy/data/model/iot_result.dart';

import 'package:mobile_app_theraphy/data/model/patient.dart';
import 'package:mobile_app_theraphy/data/model/therapy.dart';
import 'package:mobile_app_theraphy/data/model/treatment.dart';
import 'package:mobile_app_theraphy/data/remote/http_helper.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_theraphy/ui/patients/patients-list.dart';
import 'package:mobile_app_theraphy/ui/therapy/iot-results.dart';
import 'package:mobile_app_theraphy/ui/therapy/map-view.dart';
import 'package:mobile_app_theraphy/ui/therapy/new-appointment.dart';
import 'package:mobile_app_theraphy/ui/therapy/new-video.dart';
import 'package:chewie/chewie.dart';
import 'package:mobile_app_theraphy/ui/therapy/video-player.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class MyTherapy extends StatefulWidget {
  final int patientId;
  final int indexx;
  const MyTherapy({Key? key, required this.patientId, this.indexx = 0})
      : super(key: key);
  @override
  State<MyTherapy> createState() => _MyTherapyState();
}

class _MyTherapyState extends State<MyTherapy> {
  Key videoPlayerKey = UniqueKey(); // Add this line

  HttpHelper? _httpHelper;
  Therapy? therapies;
  Treatment? treatment;
  Appointment? appointment;
  bool isTreatment = false;
  bool isAppointment = false;
  String therapyName = "";
  String therapyDescription = "";
  List<String> days = [];
  int _currentIndex = 0;

  final DateFormat format = DateFormat("yyyy-MM-dd");
  late DateTime dateTime1;
  late DateTime dateTime2;
  int difference = 0;
  String dateShowed = "";
  String pastDateShowed = "";
  final String _cellNumber = "955110309";

  Future initialize() async {
    int? id = await _httpHelper?.getPhysiotherapistLogged();
    _currentIndex = widget.indexx;
    therapies =
        await _httpHelper?.getTherapyByPhysioAndPatient(id!, widget.patientId);
    appointment = await _httpHelper?.getApppointmentByTherapyAndDate(
        therapies!.id, therapies!.startAt);
    treatment = await _httpHelper?.getTreatmentByTherapyAndDate(
        therapies!.id, therapies!.startAt);
    setState(() {
      therapies = therapies;
      print(therapies?.id);
      therapyDescription = therapies!.description;
      therapyName = therapies!.therapyName;
      dateTime1 = format.parse(therapies!.startAt);
      dateTime2 = format.parse(therapies!.finishAt);
      difference = dateTime2.difference(dateTime1).inDays;
      days = List.generate(difference + 1, (index) => "Día ${index + 1}",
          growable: false);
      dateShowed = format.format(dateTime1);
      pastDateShowed = dateShowed;
      if (appointment == null) {
        if (treatment != null) {
          isTreatment = true;
        }
      } else {
        isAppointment = true;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _httpHelper = HttpHelper();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: -10,
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            "Therapy",
            style: TextStyle(
              color: AppConfig.primaryColor,
              fontSize: 24,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: AppConfig.primaryColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PatientsList(),
                ),
              );
            },
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                therapyName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.only(bottom: 16.0, right: 16.0, left: 16.0),
              child: Text(
                therapyDescription,
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                child: ClipRRect(
                  child: Container(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: days.asMap().entries.map((entry) {
                        final index = entry.key;
                        final day = entry.value;
                        return GestureDetector(
                          onTap: () async {
                            _currentIndex = index;
                            appointment = null;
                            treatment = null;
                            videoPlayerKey = UniqueKey();
                            dateShowed = format.format(
                                dateTime1.add(Duration(days: _currentIndex)));
                            appointment = await _httpHelper
                                ?.getApppointmentByTherapyAndDate(
                                    therapies!.id, dateShowed);
                            treatment =
                                await _httpHelper?.getTreatmentByTherapyAndDate(
                                    therapies!.id, dateShowed);
                            print("metooo");
                            print(dateShowed);
                            print(treatment);
                            setState(() {
                              if (appointment == null) {
                                if (treatment != null) {
                                  isTreatment = true;
                                }
                                isAppointment = false;
                              } else {
                                isAppointment = true;
                                isTreatment = false;
                              }
                              print(isTreatment);
                              print("metooo2");
                            });
                          },
                          child: Container(
                            width: 80,
                            height: 40,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              color: _currentIndex == index
                                  ? AppConfig.primaryColor
                                  : const Color(0xFFB0D0FF),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Center(
                              child: Text(
                                day,
                                style: TextStyle(
                                  color: _currentIndex == index
                                      ? Colors.white
                                      : AppConfig.primaryColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
                    child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: isTreatment && treatment != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Text(
                              dateShowed,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppConfig.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          elevation: 5,
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 4 / 3,
                                child: VideoPlayerWidget(
                                    key: videoPlayerKey, // Pass the key here

                                    videoUrl: treatment!.videoUrl),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        treatment!.title,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      treatment!.description,
                                      style: const TextStyle(fontSize: 16),
                                      textAlign: TextAlign.justify,
                                    ),
                                    const SizedBox(height: 8),
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => IotResults(
                                                  therapy: therapies!,
                                                  date: dateShowed),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                            'Physical Performance Summary'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : isAppointment && appointment != null
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: Text(
                                  dateShowed,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppConfig.primaryColor),
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 12.0),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 248,
                                            child: Text(
                                              "You have scheduled an Appointment Today:  ",
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: AppConfig.primaryColor,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              _makePhoneCall();

                                              // Lógica para el icono de teléfono
                                              // Agrega aquí el código que se ejecutará al presionar el icono de teléfono
                                            },
                                            icon: const Icon(
                                              Icons.phone,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12.0),
                                      Wrap(
                                        spacing: 16.0,
                                        children: [
                                          Center(
                                            child: CircleAvatar(
                                              radius: 50.0,
                                              backgroundImage: NetworkImage(
                                                  appointment!.therapy.patient
                                                      .photoUrl),
                                            ),
                                          ),
                                          const SizedBox(height: 16.0),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Text(
                                                    "Patient:  ",
                                                    style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "${appointment!.therapy.patient.user.firstname} ${appointment!.therapy.patient.user.lastname.split(' ')[0]}",
                                                    style: const TextStyle(
                                                        fontSize: 14.0),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Text(
                                                    "Hour:  ",
                                                    style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    appointment!.hour,
                                                    style: const TextStyle(
                                                        fontSize: 14.0),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Text(
                                                    "Place:  ",
                                                    style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    appointment!.place,
                                                    style: const TextStyle(
                                                        fontSize: 14.0),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Text(
                                                    "Topic:  ",
                                                    style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    appointment!.topic,
                                                    style: const TextStyle(
                                                        fontSize: 14.0),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 25.0),
                                      Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      String updatedDiagnosis =
                                                          appointment!
                                                              .diagnosis;
                                                      return Dialog(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      16.0),
                                                        ),
                                                        elevation: 0.0,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16.0),
                                                          ),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: <Widget>[
                                                              Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            16.0),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .blue,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            16.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            16.0),
                                                                  ),
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <Widget>[
                                                                    Text(
                                                                      'Send Diagnosis',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            20.0,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    IconButton(
                                                                      icon: Icon(
                                                                          Icons
                                                                              .close,
                                                                          color:
                                                                              Colors.white),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop(); // Cerrar el diálogo
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            16.0),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <Widget>[
                                                                    Text(
                                                                      'Diagnosis:',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            16.0,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Colors
                                                                            .black87,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            8.0),
                                                                    TextFormField(
                                                                      initialValue:
                                                                          appointment?.diagnosis
                                                                              ,
                                                                      onChanged:
                                                                          (value) {
                                                                        updatedDiagnosis =
                                                                            value;

                                                                        appointment!.diagnosis =
                                                                            updatedDiagnosis;
                                                                      },
                                                                      decoration:
                                                                          InputDecoration(
                                                                            hintText: "Type the diagnosis here",
                                                                        border:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10.0),
                                                                        ),
                                                                      ),
                                                                      maxLines:
                                                                          8,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: <Widget>[
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(); // Cerrar el diálogo
                                                                    },
                                                                    child: Text(
                                                                      'Cancel',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.blue),
                                                                    ),
                                                                  ),
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () async {
                                                                      await _httpHelper!.updateDiagnosis(
                                                                          appointment!
                                                                              .id,
                                                                          appointment!
                                                                              .diagnosis);
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      // Lógica para actualizar el diagnóstico
                                                                      // Agrega aquí el código que se ejecutará al presionar el botón "Update"
                                                                      // Puedes utilizar la variable `updatedDiagnosis` para obtener el nuevo diagnóstico
                                                                    },
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      primary:
                                                                          Colors
                                                                              .blue, // Cambia el color del botón
                                                                    ),
                                                                    child: Text(
                                                                      'Send',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 10.0),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                primary: AppConfig.primaryColor,
                                                onPrimary: Colors.white,
                                              ),
                                              child:
                                                  const Text("See Diagnosis"),
                                            ),
                                            const SizedBox(height: 10),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CitizenMap(
                                                            appointment:
                                                                appointment!,
                                                          )),
                                                );

                                                // Lógica para "Go to Map"
                                                // Agrega aquí el código que se ejecutará al presionar el botón "Go to Map"
                                              },
                                              style: ElevatedButton.styleFrom(
                                                primary: AppConfig.primaryColor,
                                                onPrimary: Colors.white,
                                              ),
                                              child: const Text("Go to Map"),
                                            ),
                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(
                              height: 16.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: Text(
                                dateShowed,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppConfig.primaryColor),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                "Create a Therapy Video",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: 0.7,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NewVideo(
                                          initialIndex: _currentIndex,
                                          patientId: widget.patientId,
                                        ),
                                      ));
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          AppConfig.primaryColor),
                                ),
                                child: const Text(
                                  "Add Video",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40.0,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                "Schedule an Appointment",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: 0.7,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NewAppointment(
                                          initialIndex: _currentIndex,
                                          patientId: widget.patientId,
                                        ),
                                      ));
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          AppConfig.primaryColor),
                                ),
                                child: const Text(
                                  "Add Appointment",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
            )))
          ],
        ),
      ),
    );
  }

  void _makePhoneCall() async {
    //IOS VESION

    /*final String phoneUrl = 'tel:$_cellNumber';
    
    if (await canLaunchUrl(Uri.parse(phoneUrl))) {
      await launchUrl(Uri.parse(phoneUrl));
    } else {
      throw 'Could not launch $phoneUrl';
    }*/

    //ANDROID VERSION
    String number = '955110309';
    FlutterPhoneDirectCaller.callNumber(number);
  }
}
