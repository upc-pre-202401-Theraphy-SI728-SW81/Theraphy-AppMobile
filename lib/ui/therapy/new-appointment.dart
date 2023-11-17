import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_theraphy/config/app_config.dart';
import 'package:mobile_app_theraphy/data/model/therapy.dart';
import 'package:mobile_app_theraphy/data/remote/http_helper.dart';
import 'package:mobile_app_theraphy/ui/therapy/my-therapy.dart';

class NewAppointment extends StatefulWidget {
  final int initialIndex;
  final int patientId;

  const NewAppointment(
      {Key? key, required this.initialIndex, required this.patientId})
      : super(key: key);

  @override
  State<NewAppointment> createState() =>
      _NewAppointmentState(initialIndex: initialIndex);
}

class _NewAppointmentState extends State<NewAppointment> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();

  List<String> hoursList = [];

  String selectedHour = "07:00";
  String title = "";

  final int initialIndex;

  HttpHelper? _httpHelper;
  Therapy? therapies;

  String therapyName = "";
  String therapyDescription = "";

  List<String> days = [];
  int _currentIndex = 0;

  final DateFormat format = DateFormat("yyyy-MM-dd");
  late DateTime dateTime1;
  late DateTime dateTime2;
  int difference = 0;
  String dateShowed = "";

  _NewAppointmentState({required this.initialIndex});

  Future initialize() async {
    int? id = await _httpHelper?.getPhysiotherapistLogged();
    _currentIndex = initialIndex;
    therapies = null;
    therapies =
        await _httpHelper?.getTherapyByPhysioAndPatient(id!, widget.patientId);

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
      dateShowed = format.format(dateTime1.add(Duration(days: _currentIndex)));

      hoursList = List.generate(13, (index) {
        int hour = 7 + index;
        String formattedHour = hour.toString().padLeft(2, '0');
        return '$formattedHour:00';
      });
      print(hoursList);
    });
  }

  @override
  void initState() {
    _httpHelper = HttpHelper();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final size = MediaQuery.of(context).size;
    return Scaffold(
  backgroundColor: const Color(0xFFF5F5F8),
  appBar: AppBar(
    backgroundColor: const Color(0xFFF5F5F8),
    elevation: 0,
    automaticallyImplyLeading: false,
    title: Row(
      children: <Widget>[
        IconButton(
          icon:  Icon(
            Icons.arrow_back,
            color: AppConfig.primaryColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        Text(
          "Add Appointment",
          style: TextStyle(color: AppConfig.primaryColor),
        ),
      ],
    ),
  ),
  body: SingleChildScrollView(
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.00,
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
            margin: const EdgeInsets.all(16.0),
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
              color: const Color(0xFFF5F5F8),
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              child: Stack(
                children: [
                  ListView(
                    scrollDirection: Axis.horizontal,
                    children: days.asMap().entries.map((entry) {
                      final index = entry.key;
                      final day = entry.value;
                      return GestureDetector(
                        onTap: () {
                          setState(() {});
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
                                    ? const Color(0xFFF5F5F8)
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
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      dateShowed,
                      textAlign: TextAlign.center,
                      style:  TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppConfig.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Complete the field to create your appointment",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Reason for consultation",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Write here",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:  BorderSide(
                            color: AppConfig.primaryColor,
                            width: 1.5,
                          ),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      "Time of appointment",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      height: 60.0,
                      child: DropdownButtonFormField<String>(
                        value: selectedHour,
                        menuMaxHeight: 240,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedHour = newValue!;
                          });
                        },
                        items: hoursList.map((String hour) {
                          return DropdownMenuItem<String>(
                            value: hour,
                            child: Text(hour),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: "Select Hour",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:  BorderSide(
                              color: AppConfig.primaryColor,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:  BorderSide(
                              color: AppConfig.primaryColor,
                              width: 1.5,
                            ),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          title = titleController.text;

                          if (title != "") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyTherapy(
                                  patientId: widget.patientId,
                                ),
                              ),
                            );
                            _httpHelper?.addAppointment(
                                title,
                                dateShowed,
                                selectedHour,
                                therapies!.patient.location,
                                therapies!.id);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Center(
                                  child: SimpleDialog(
                                    title: const Column(
                                      children: [
                                        Icon(Icons.check,
                                            color: Colors.green,
                                            size: 80),
                                        SizedBox(height: 10),
                                        Center(
                                          child: Text(
                                            "The new appointment was scheduled successfully",
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                    children: <Widget>[
                                      Center(
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 10),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all<Color>(AppConfig.primaryColor),
                                              ),
                                              child: const Text(
                                                "Close",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(AppConfig.primaryColor),
                        ),
                        child: Container(
                          height: 60.0,
                          child: const Center(
                            child: Text(
                              "Schedule appointment",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
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
