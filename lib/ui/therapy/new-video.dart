import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app_theraphy/data/model/patient.dart';
import 'package:mobile_app_theraphy/data/model/therapy.dart';
import 'package:mobile_app_theraphy/data/remote/http_helper.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_theraphy/data/remote/upload_Into_Firebase.dart';
import 'package:video_player/video_player.dart';

class NewVideo extends StatefulWidget {
  final int initialIndex;
  final int patientId;

  const NewVideo(
      {Key? key, required this.initialIndex, required this.patientId})
      : super(key: key);

  @override
  State<NewVideo> createState() => _NewVideoState(initialIndex: initialIndex);
}

class _NewVideoState extends State<NewVideo> {
  HttpHelper? _httpHelper;
  Therapy? therapies;

  TextEditingController titleController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();

  String therapyName = "";
  String therapyDescription = "";

  List<String> days = [];
  int _currentIndex = 0;

  final int initialIndex;

  final DateFormat format = DateFormat("yyyy-MM-dd");
  late DateTime dateTime1;
  late DateTime dateTime2;
  int difference = 0;
  String dateShowed = "";

  String title = "";
  String descripction = "";
  String video = "";

  VideoPlayerController? _videoController;
  String? _videoUrl;
  File? _videoFile;

  Future<void> _pickVideo() async {
    final imagePicker = ImagePicker();
    final pickedVideo = await imagePicker.getVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      final videoFile = File(pickedVideo.path);
      final videoUrl = await uploadVideo(videoFile);
      print("hola");
      setState(() {
        _videoFile = videoFile;
        _videoController = VideoPlayerController.file(_videoFile!);
        _videoController!.initialize();
        _videoUrl = videoUrl;
        print("AQUIIIIII BEB");
        print(_videoUrl);
        print("ANTESSSS");
      });
    }
  }

  _NewVideoState({required this.initialIndex});

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
      backgroundColor: const Color(0xFFF5F5F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F8),
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
              "Therapy",
              style: TextStyle(color: Color(0xFF014DBF)),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Elemento fijo arriba
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
            padding: const EdgeInsets.all(16.0),
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
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F8),
              borderRadius: BorderRadius.circular(40.0),
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
          // Elemento fijo abajo del carrusel de días
          // Puedes agregar más elementos según sea necesario
          Center(
            child: Padding(
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
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                          controller: titleController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: "Write here",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              borderSide: const BorderSide(
                                color: Color(0xFF0166FE),
                                width: 1.5,
                              ),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
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
                          controller: descripcionController,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              borderSide: const BorderSide(
                                color: Color(0xFF0166FE),
                                width: 1.5,
                              ),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            labelText: "Write here",
                          ),
                          maxLines: 3,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(250),
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
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
                                // Lógica para cargar el video
                                _pickVideo();
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color(0xFF014DBF),
                                ),
                              ),
                              child: const Text(
                                "Upload",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            if (_videoController != null)
                              AspectRatio(
                                aspectRatio:
                                    _videoController!.value.aspectRatio,
                                child: VideoPlayer(_videoController!),
                              ),
                            if (_videoUrl != null)
                              Text(
                                  'URL del Video en Firebase Storage: $_videoUrl'),
                            // Puedes agregar más elementos según sea necesario
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              // Lógica para crear el tratamiento virtual
                              title = titleController.text;
                              descripction = descripcionController.text;
                              video = "aea";

                              if (title != "" &&
                                  descripction != "" &&
                                  _videoUrl != null) {
                                _httpHelper?.addTreatment(therapies!.id, _videoUrl!,
                                    "30 min", title, descripction, dateShowed);
                                Navigator.of(context).pop();

                                // Muestra un diálogo emergente con el mensaje de éxito
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Center(
                                      child: SimpleDialog(
                                        title: const Column(
                                          children: [
                                            Icon(Icons.check,
                                                color: Colors.green,
                                                size:
                                                    80), // Icono de check más grande
                                            SizedBox(height: 10),
                                            Center(
                                              child: Text(
                                                "The new video has been uploaded successfully",
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
                                                const SizedBox(height: 10),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    // Cierra el diálogo emergente
                                                    Navigator.of(context).pop();
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty.all<
                                                                Color>(
                                                            const Color(
                                                                0xFF014DBF)), // Color de fondo personalizado para el botón "Cerrar"
                                                  ),
                                                  child: const Text("Close"),
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
                              backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFF014DBF),
                              ),
                            ),
                            child: const Text(
                              "Create Virtual Treatment",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }
}
