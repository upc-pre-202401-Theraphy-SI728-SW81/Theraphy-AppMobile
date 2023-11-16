import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
        backgroundColor: const Color(0xFFF5F5F8), // Fondo F5F5F8
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5F5F8), // Fondo F5F5F8
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF014DBF),
                ),
                onPressed: () {
                  // Agrega lógica para retroceder
                  Navigator.of(context).pop();
                },
              ),
              const Text(
                "Add Appointment",
                style: TextStyle(color: Color(0xFF014DBF)),
              ),
            ],
          ),
        ),
        body: Padding(
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
                    //padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.all(16.0),
                    child: Text(
                      therapyDescription,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  // Carrusel de días
                  Container(
                    //margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                    //padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                    height: 60, // Altura del contenedor grande
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F8),
                      borderRadius: BorderRadius.circular(
                          40.0), // Radio de borde para esquinas curvas
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Stack(children: [
                        Container(
                          child: ListView(
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
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    color: _currentIndex == index
                                        ? const Color(0xFF013D98)
                                        : const Color(0xFFB0D0FF),
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      day,
                                      style: TextStyle(
                                        color: _currentIndex == index
                                            ? const Color(0xFFF5F5F8)
                                            : const Color(0xFF013D98),
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
                      ]),
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  child: Text(
                                    dateShowed,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF013D98),
                                    ),
                                  ),
                                ),
                              ]))),

                  SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Alinea los elementos a la izquierda
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical:
                                    0.0), // Espaciado de 20 píxeles en los lados
                            child: Align(
                              alignment: Alignment
                                  .centerLeft, // Justifica el texto a la izquierda
                              child: Text(
                                "Complete the field to create your appointment",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(
                                  20.0), // Espaciado de 20 píxeles en todos los lados
                              child: Column(children: [
                                // Título y campo de entrada para el título del video
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        controller:
                                            titleController, // Asigna el controlador
                                        style: const TextStyle(
                                            color: Colors.black),
                                        decoration: InputDecoration(
                                          labelText: "Write here",
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(1.0),
                                            borderSide: const BorderSide(
                                              color: Color(0xFF0166FE),
                                              width: 1.5,
                                            ),
                                          ),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.never,
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
                                        height:
                                            60.0, // Establece la altura deseada
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
                                            labelText:
                                                "Select Hour", // Etiqueta para el campo desplegable
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(1.0),
                                              borderSide: const BorderSide(
                                                color: Color(0xFF0166FE),
                                                width: 1.5,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(1.0),
                                              borderSide: const BorderSide(
                                                color: Color(0xFF0166FE),
                                                width: 1.5,
                                              ),
                                            ),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30.0,
                                      ),
                                      Center(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            // Agrega aquí la lógica para crear un tratamiento virtual
                                            title = titleController.text;

                                            if (title != "") {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyTherapy(
                                                          patientId:
                                                              widget.patientId,
                                                         ),
                                                ),
                                              );
                                              _httpHelper?.addAppointment(
                                                  title,
                                                  dateShowed,
                                                  selectedHour,
                                                  therapies!.patient.location,
                                                  therapies!.id);
                                              // Muestra un diálogo emergente con el mensaje de éxito
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Center(
                                                    child: SimpleDialog(
                                                      title: const Column(
                                                        children: [
                                                          Icon(Icons.check,
                                                              color:
                                                                  Colors.green,
                                                              size:
                                                                  80), // Icono de check más grande
                                                          SizedBox(height: 10),
                                                          Center(
                                                            child: Text(
                                                              "The new appointment was scheduled successfully",
                                                              textAlign: TextAlign
                                                                  .center, // Alinea el texto al centro
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      children: <Widget>[
                                                        Center(
                                                          child: Column(
                                                            children: [
                                                              const SizedBox(
                                                                  height: 10),
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  // Cierra el diálogo emergente
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                style:
                                                                    ButtonStyle(
                                                                  backgroundColor: MaterialStateProperty.all<
                                                                          Color>(
                                                                      const Color(
                                                                          0xFF014DBF)), // Color de fondo personalizado para el botón "Cerrar"
                                                                ),
                                                                child:
                                                                    const Text(
                                                                  "Close",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
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
                                            backgroundColor: MaterialStateProperty
                                                .all<Color>(const Color(
                                                    0xFF014DBF)), // Color de fondo personalizado para el botón "Schedule appointment"
                                          ),
                                          child: Container(
                                            height:
                                                60.0, // Establece el alto deseado para el botón
                                            child: const Center(
                                              child: Text(
                                                "Schedule appointment",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors
                                                      .white, // Agrega esta línea para establecer el color del texto a negro
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ])
                              ])),
                        ]),
                  )
                ])));
  }
}
