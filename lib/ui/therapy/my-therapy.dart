import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mobile_app_theraphy/config/app_config.dart';
import 'package:mobile_app_theraphy/config/navBar.dart';
import 'package:mobile_app_theraphy/data/model/patient.dart';
import 'package:mobile_app_theraphy/data/model/therapy.dart';
import 'package:mobile_app_theraphy/data/remote/http_helper.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_theraphy/ui/patients/patients-list.dart';
import 'package:mobile_app_theraphy/ui/therapy/new-appointment.dart';
import 'package:mobile_app_theraphy/ui/therapy/new-video.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class MyTherapy extends StatefulWidget {
  const MyTherapy({super.key});

  @override
  State<MyTherapy> createState() => _MyTherapyState();
}

class _MyTherapyState extends State<MyTherapy> {
  HttpHelper? _httpHelper;
  Therapy? therapies;

  bool isTreatment = false;

  String therapyName = "";
  String therapyDescription = "";

  List<String> days = [];
  int _currentIndex = 0;
  int patientId = 2;

  final DateFormat format = DateFormat("yyyy-MM-dd");
  late DateTime dateTime1;
  late DateTime dateTime2;
  late ChewieController _chewieController;
  late VideoPlayerController _videoPlayerController;

  int difference = 0;
  String dateShowed = "";

  Future initialize() async {
    int? id = await _httpHelper?.getPhysiotherapistLogged();

    therapies = await _httpHelper?.getTherapyByPhysioAndPatient(id!, patientId);

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
    });
  }

  @override
  void initState() {
    super.initState();
    _httpHelper = HttpHelper();
    initialize();
    // Inicializar el controlador de video
    // ignore: deprecated_member_use
    _videoPlayerController = VideoPlayerController.network(
        "https://www.youtube.com/watch?v=4BVZLYyuurk");

    // Inicializar el controlador de Chewie
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay:
          false, // Puedes cambiarlo a true si deseas reproducción automática
      looping: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white, // Fondo F5F5F8
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
              // margin: const EdgeInsets.only(left: 16.0, right: 16.0),
              //padding: const EdgeInsets.only(left: 4.0, right: 4.0),
              height: 60, // Altura del contenedor grande
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                    40.0), // Radio de borde para esquinas curvas
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                child: ClipRRect(
                  // borderRadius: BorderRadius.circular(
                  //     20.0), // Agrega un radio de 40 a los bordes izquierdo y derecho
                  child: Container(
                    // decoration: BoxDecoration(
                    //   border: Border(
                    //     left: BorderSide(
                    //       color: const Color(0xFF014DBF).withOpacity(0.9),
                    //       width: 20.0, // Ancho de la sombra izquierda
                    //     ),
                    //     right: BorderSide(
                    //       color: const Color(0xFF014DBF).withOpacity(0.9),
                    //       width: 20.0, // Ancho de la sombra derecha
                    //     ),
                    //   ),
                    // ),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: days.asMap().entries.map((entry) {
                        final index = entry.key;
                        final day = entry.value;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentIndex = index;
                              dateShowed = format.format(
                                  dateTime1.add(Duration(days: _currentIndex)));
                            });
                          },
                          child: Container(
                            width: 80,
                            height: 40,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
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
                                      ? Colors.white
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
                ),
              ),
            ),

            isTreatment && _chewieController != null
                ? Column(
                    children: [
                      //Chewie(
                      //controller: _chewieController,
                      //),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "sadadad",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "sadada",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Agregar lógica para manejar el botón (puede abrir resultados de IoT)
                        },
                        child: Text('View IoT Results'),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 30.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
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

                      const SizedBox(
                        height: 10.0,
                      ),
                      // Línea que dice "Create a Therapy Video"
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

                      // Botón "Add video" con color de fondo personalizado y ancho del 80%
                      FractionallySizedBox(
                        widthFactor: 0.7, // Ancho del 80%
                        child: ElevatedButton(
                          onPressed: () {
                            // Lógica para el botón "Add video"
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NewVideo(initialIndex: _currentIndex),
                                ));
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFF014DBF)),
                          ),
                          child: const Text(
                            "Add Video",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors
                                  .white, // Agrega esta línea para establecer el color del texto a negro
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      // Texto que dice "Schedule an Appointment"
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

                      // Botón "Add appointment" con color de fondo personalizado
                      FractionallySizedBox(
                        widthFactor: 0.7, // Ancho del 80%
                        child: ElevatedButton(
                          onPressed: () {
                            // Lógica para el botón "Add video"
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewAppointment(
                                      initialIndex: _currentIndex),
                                ));
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFF014DBF)),
                          ),
                          child: const Text(
                            "Add Appointment",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors
                                  .white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

            // Aquí puedes agregar el contenido adicional de tu página
          ],
        ),
      ),
      //bottomNavigationBar: NavBar(),
    );
  }
}
