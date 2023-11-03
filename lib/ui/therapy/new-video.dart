import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mobile_app_theraphy/data/model/patient.dart';
import 'package:mobile_app_theraphy/data/model/therapy.dart';
import 'package:mobile_app_theraphy/data/remote/http_helper.dart';
import 'package:intl/intl.dart';


class NewVideo extends StatefulWidget {
  final int initialIndex;

  const NewVideo({Key? key, required this.initialIndex}) : super(key: key);

  @override
  State<NewVideo> createState() => _NewVideoState(initialIndex: initialIndex);
}

class _NewVideoState extends State<NewVideo> {

  HttpHelper? _httpHelper;
  Therapy? therapies;

  String therapyName = "";
  String therapyDescription = "";

  List<String> days = [];
  int _currentIndex = 0;
  int patientId = 1;

  final int initialIndex;


  final DateFormat format = DateFormat("yyyy-MM-dd");
  late DateTime dateTime1;
  late DateTime dateTime2;
  int difference = 0;
  String dateShowed = "";

  _NewVideoState({required this.initialIndex});


  Future initialize() async {
    int? id = await _httpHelper?.getPhysiotherapistLogged();
    _currentIndex = initialIndex;
    therapies = null;
    therapies = await _httpHelper?.getTherapyByPhysioAndPatient(patientId, id!);
   
    setState(() {
      therapies = therapies;
      print(therapies?.id);
      therapyDescription = therapies!.description;
      therapyName = therapies!.therapyName;

      dateTime1 = format.parse(therapies!.startAt);
      dateTime2= format.parse(therapies!.finishAt);

      difference = dateTime2.difference(dateTime1).inDays;

      days = List.generate(
      difference + 1, (index) => "Día ${index + 1}", growable: false);
      dateShowed = format.format(dateTime1.add(Duration(days: _currentIndex)));
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
              },
            ),
            const Text(
              "Therapy",
              style: TextStyle(color: Color(0xFF014DBF)),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16.0),
              child:  Text(
                therapyName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(bottom: 16.0),
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
              margin: const EdgeInsets.only(left: 16.0, right: 16.0),
              padding: const EdgeInsets.only(left: 4.0, right: 4.0),
              height: 60, // Altura del contenedor grande
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F8),
                borderRadius: BorderRadius.circular(40.0), // Radio de borde para esquinas curvas
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0), // Agrega un radio de 40 a los bordes izquierdo y derecho
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: const Color(0xFFB0D0FF).withOpacity(0.9),
                          width: 20.0, // Ancho de la sombra izquierda
                        ),
                        right: BorderSide(
                          color: const Color(0xFFB0D0FF).withOpacity(0.9),
                          width: 20.0, // Ancho de la sombra derecha
                        ),
                      ),
                    ),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: days.asMap().entries.map((entry) {
                        final index = entry.key;
                        final day = entry.value;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              
                            });
                          },
                          child: Container(
                            width: 80,
                            height: 40,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              color: _currentIndex == index ? const Color(0xFF013D98) : const Color(0xFFB0D0FF),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Center(
                              child: Text(
                                day,
                                style: TextStyle(
                                  color: _currentIndex == index ? const Color(0xFFF5F5F8) : const Color(0xFF013D98),
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
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
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
                  
                  // Título y campo de entrada para el título del video
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Video's Title",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                    TextFormField(
                      style: TextStyle(color: Colors.black), // Cambia el color del texto
                      decoration: InputDecoration(
                        labelText: "Write here", // Etiqueta (label) personalizada
                        enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular( 1.0),
                                      borderSide: const BorderSide(
                                      color: Color(0xFF0166FE), // Color del borde
                                        width: 1.5,
                                      ),
                                    ),
                        floatingLabelBehavior: FloatingLabelBehavior.never, // No se desplaza hacia arriba
                      ),
                    )

                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  // Título y campo de entrada para la descripción
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextField(
                        style: const TextStyle(color: Colors.black), // Cambia el color del texto
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular( 1.0),
                                      borderSide: const BorderSide(
                                      color: Color(0xFF0166FE), // Color del borde
                                        width: 1.5,
                                      ),
                                    ),
                          floatingLabelBehavior: FloatingLabelBehavior.never, // No se desplaza hacia arrib
                          labelText: "Write here", // Etiqueta (label) personalizada
                        ),
                        maxLines: 3, // Altura de 40 (dos líneas)
                        inputFormatters: [LengthLimitingTextInputFormatter(250)], // Limitación de 250 palabras
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          const Text(
                              "Video of Treatment:                ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                              ),
                              ),
                          ElevatedButton(
                            onPressed: () {
                              // Agrega aquí la lógica para adjuntar videos
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF014DBF)), // Color de fondo personalizado
                            ),
                            child: const Text("Upload"),
                          ),
                        ],
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Agrega aquí la lógica para crear un tratamiento virtual
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF014DBF)), // Color de fondo personalizado
                          ),
                          child: const Text("Create Virtual Treatment"),
                        ),
                      )

                    ],
                    
                  ),
                ],
              ),
              
            ),
          )




            


            // Aquí puedes agregar el contenido adicional de tu página
          ],
        ),
      ),
    );






  }
}