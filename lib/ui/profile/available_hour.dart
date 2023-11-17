import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_app_theraphy/data/model/available_hour.dart';
import 'package:mobile_app_theraphy/data/remote/services/availableHour/available_hour_service.dart';
import 'package:mobile_app_theraphy/ui/profile/physiotherapist_profile.dart';

class AvailabilityPage extends StatefulWidget {
  const AvailabilityPage({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<AvailabilityPage> createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends State<AvailabilityPage> {
  AvailableHourService? _availableHourService;
  List<AvailableHour>? _availableHours;

  Future<void> initialize() async {
    _availableHours = await _availableHourService?.getAll();
    setState(() {
      _availableHours = _availableHours;
    });
  }

  @override
  void initState() {
    _availableHourService = AvailableHourService();
    initialize();
    super.initState();
  }

  List<String> daysOfWeek = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];
  String selectedDay = "Monday";
  String enteredHour = "";

  String getFormattedDate() {
    DateTime now = DateTime.now();

    // Sumar 6 días a la fecha actual, saltando los domingos
    DateTime endDate = now.add(Duration(days: 6 + _countSundays(now, 6)));

    // Ajustar mes y año si es necesario
    while (endDate.day > 30 || endDate.month > 12) {
      if (endDate.day > 30) {
        endDate = endDate.add(Duration(days: 1));
      }
      if (endDate.month > 12) {
        endDate = DateTime(endDate.year + 1, 1, endDate.day);
      }
    }

    return "${now.year}-${now.month}-${now.day}    ${endDate.year}-${endDate.month}-${endDate.day}";
  }

  String getDayNumber(String day) {
    String formattedDate = getFormattedDate();
    List<String> days = formattedDate.split("    ");
    String startDay =
        days[0].split("-")[2]; // Extraer el día de la fecha de inicio

    switch (day) {
      case "Monday":
        return startDay;
      case "Tuesday":
        return (int.parse(startDay) + 1).toString();
      case "Wednesday":
        return (int.parse(startDay) + 2).toString();
      case "Thursday":
        return (int.parse(startDay) + 3).toString();
      case "Friday":
        return (int.parse(startDay) + 4).toString();
      case "Saturday":
        return (int.parse(startDay) + 5).toString();
      default:
        return "";
    }
  }

  int _countSundays(DateTime startDate, int days) {
    int count = 0;
    for (int i = 0; i < days; i++) {
      DateTime currentDate = startDate.add(Duration(days: i));
      if (currentDate.weekday == DateTime.sunday) {
        count++;
      }
    }
    return count;
  }

  bool isValidHourFormat(String hour) {
    // Verificar si la hora tiene el formato "hr-hr" usando una expresión regular
    RegExp regex = RegExp(
        r'^\d{1,2}:\d{2}-\d{1,2}:\d{2}$|^\d{1,2}:\d{2}\s*-\s*\d{1,2}:\d{2}$');
    return regex.hasMatch(hour);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (selectedDay != "") {
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Enter your available hours"),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 10),
                Text(
                  getFormattedDate(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      "Select a day of the week:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: selectedDay,
                      items: daysOfWeek.map((day) {
                        return DropdownMenuItem<String>(
                          value: day,
                          child: Row(
                            children: [
                              Text(day, style: const TextStyle(fontSize: 15)),
                              const SizedBox(width: 6),
                              Text(
                                getDayNumber(day),
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDay = value!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text(
                      "Enter an available hour:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 110,
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: "E.g., 7:00-19:00",
                        ),
                        onChanged: (value) {
                          setState(() {
                            enteredHour = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // Validar que el campo de la hora no esté vacío
                    if (enteredHour.isEmpty) {
                      Fluttertoast.showToast(
                        msg: 'Please enter the available time',
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                      return; // Salir de la función si la hora está vacía
                    }

                    // Validar el formato de la hora
                    if (!isValidHourFormat(enteredHour)) {
                      Fluttertoast.showToast(
                        msg:
                            'Please enter a valid hour format (e.g., 7:00-19:00)',
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                      return; // Salir de la función si el formato no es válido
                    }

                    // Use selectedDay and enteredHour to save the information
                    String day = selectedDay;
                    String hour = enteredHour;

                    await _availableHourService?.createAvailableHour(
                      0,
                      hour,
                      day,
                      widget.id,
                    );

                    setState(() {
                      daysOfWeek.remove(selectedDay);
                      selectedDay =
                          daysOfWeek.isNotEmpty ? daysOfWeek.first : "";

                      if (selectedDay == "") {
                        // Show a success message
                        Fluttertoast.showToast(
                          msg: 'Successful data',
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                        );

                        // Update the UI after a delay (optional)
                        Future.delayed(const Duration(seconds: 2));

                        // Navigate back to the profile page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfilePage(),
                          ),
                        ).then((value) => initialize());
                      }
                    });
                  },
                  child: const Text("Save"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
