import 'package:flutter/material.dart';
import 'package:mobile_app_theraphy/data/model/available_hour.dart';
import 'package:mobile_app_theraphy/data/remote/services/availableHour/available_hour_service.dart';
import 'package:mobile_app_theraphy/ui/profile/physiotherapist_profile.dart';

class AvailabilityPage extends StatefulWidget {
  const AvailabilityPage({super.key});
  //final void Function() initialize;
  @override
  State<AvailabilityPage> createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends State<AvailabilityPage> {
  AvailableHourService? _availableHourService;
  List<AvailableHour>? _availableHours;

  Future initialize() async {
    _availableHours = List.empty();
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

  DateTime now = DateTime.now();
  //DateTime date = DateTime(now.year, now.month, now.day);
  //String dayName = DateFormat('EEEE', 'es').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Aquí puedes definir la lógica para evitar el retroceso si selectedDay no es nulo.
        if (selectedDay != "") {
          return false; // No permitir retroceso
        }
        return true; // Permitir retroceso
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Enter your available hours"),
          backgroundColor: Colors.blue,
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "For a week", // Título "For a week"
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  "${now.year}-${now.month}-${now.day}    ${now.year}-${now.month}-${now.day + 6} xD",
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  // Fila para el primer conjunto de texto y menú desplegable
                  children: [
                    const Text(
                      "Select a day of the week:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                        width:
                            20), // Espacio entre el texto y el menú desplegable
                    DropdownButton<String>(
                      value: selectedDay,
                      items: daysOfWeek.map((day) {
                        return DropdownMenuItem<String>(
                          value: day,
                          child:
                              Text(day, style: const TextStyle(fontSize: 16)),
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
                  // Fila para el segundo conjunto de texto y menú desplegable
                  children: [
                    const Text(
                      "Enter an available hour:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                        width:
                            20), // Espacio entre el texto y el menú desplegable
                    SizedBox(
                      width: 110, // Ancho del campo de entrada de texto
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: "E.g., 7-19",
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
                  onPressed: () {
                    // Aquí puedes usar la variable "selectedDay" y "enteredHour" para guardar la información.
                    print(selectedDay);
                    print(enteredHour);
                    String day = selectedDay;
                    String hour = enteredHour;
                    // setState(() {

                    // });
                    _availableHourService?.createAvailableHour(0, hour, day, 1);
                    setState(() {
                      daysOfWeek.remove(selectedDay);
                      selectedDay =
                          daysOfWeek.isNotEmpty ? daysOfWeek.first : "";
                      if (selectedDay == "") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfilePage(),
                          ),
                        );
                      }
                      print(daysOfWeek);
                    });
                    // selectedDay = daysOfWeek.first;
                    // selectedDay = day;
                    //Navigator.pop(context);
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
