import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app_theraphy/config/app_config.dart';
import 'package:mobile_app_theraphy/data/model/patient.dart';
import 'package:mobile_app_theraphy/data/model/therapy.dart';
import 'package:mobile_app_theraphy/data/remote/http_helper.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_theraphy/data/remote/upload_Into_Firebase.dart';
import 'package:mobile_app_theraphy/ui/therapy/body-selector/body-selector-adapter.dart';
import 'package:mobile_app_theraphy/ui/therapy/body-selector/src/model/body_parts.dart';
import 'package:mobile_app_theraphy/ui/therapy/my-therapy.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  List<String> selectedParts = [];

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

  Future<List<String>> _loadSelectedParts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Recupera la cadena JSON de las partes seleccionadas
    String? partsJson = prefs.getString('selectedParts');

    if (partsJson != null) {
      // Decodifica la cadena JSON a una lista de partes seleccionadas

      print(List<String>.from(jsonDecode(partsJson)));
      return List<String>.from(jsonDecode(partsJson));
    }

    List<String> selectedPartsEmpty = [];
    return selectedPartsEmpty;
  }

  Future<void> _pickVideo() async {
    final imagePicker = ImagePicker();
    final pickedVideo = await imagePicker.pickVideo(source: ImageSource.gallery);
    //get-video
    print("aeaaa");

    if (pickedVideo != null) {
      final videoFile = File(pickedVideo.path);
      print("aea21");
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
    selectedParts = await _loadSelectedParts();

    setState(() {
      therapies = therapies;
      print(therapies?.id);
      therapyDescription = therapies!.description;
      therapyName = therapies!.therapyName;
      selectedParts = selectedParts;

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
    _loadSelectedParts();
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
              icon: Icon(
                Icons.arrow_back,
                color: AppConfig.primaryColor,
              ),
              onPressed: () {
                // Agrega lógica para retroceder
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyTherapy(
                      patientId: widget.patientId,
                    ),
                  ),
                );
              },
            ),
            Text(
              "Therapy",
              style: TextStyle(color: AppConfig.primaryColor),
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
                ),
              ]),
            ),
          ),
          // Elemento fijo abajo del carrusel de días
          // Puedes agregar más elementos según sea necesario

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
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: AppConfig.primaryColor,
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
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: AppConfig.primaryColor,
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
                                  AppConfig.primaryColor,
                                ),
                              ),
                              child: const Text(
                                "Upload",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            // Puedes agregar más elementos según sea necesario
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (_videoUrl != null)
                          const Text(
                            'Your video has been saved',
                            style: TextStyle(
                                color: Color.fromARGB(255, 53, 211, 29)),
                          ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text(
                                'Selected Body Parts:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            if (selectedParts.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      height:
                                          10), // Espacio entre el título y la lista
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: selectedParts
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        final index = entry.key;
                                        final part = entry.value;

                                        return Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 8),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 24,
                                                    height: 24,
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.check,
                                                        color: Colors.white,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    part,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (index <
                                                  selectedParts.length - 1)
                                                Divider(), // Línea separadora
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            if (selectedParts.isNotEmpty)
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BodySelectorAdapter(
                                          initialIndex: _currentIndex,
                                          patientId: widget.patientId),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    AppConfig.primaryColor,
                                  ),
                                ),
                                child: const Text(
                                  "Edit",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (selectedParts.isEmpty)
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BodySelectorAdapter(
                                          initialIndex: _currentIndex,
                                          patientId: widget.patientId),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    AppConfig.primaryColor,
                                  ),
                                ),
                                child: const Text(
                                  "Select Body Parts",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              // Elimina las partes seleccionadas antiguas
                              prefs.remove('selectedParts');
                              // Lógica para crear el tratamiento virtual
                              title = titleController.text;
                              descripction = descripcionController.text;
                              video = "aea";

                              if (title != "" &&
                                  descripction != "" &&
                                  _videoUrl != null) {
                                _httpHelper?.addTreatment(
                                    therapies!.id,
                                    _videoUrl!,
                                    "30 min",
                                    title,
                                    descripction,
                                    dateShowed);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyTherapy(
                                      patientId: widget.patientId,
                                    ),
                                  ),
                                );

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
                                                        MaterialStateProperty
                                                            .all<Color>(AppConfig
                                                                .primaryColor), // Color de fondo personalizado para el botón "Cerrar"
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
                              backgroundColor: MaterialStateProperty.all<Color>(
                                AppConfig.primaryColor,
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
                        ),
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
