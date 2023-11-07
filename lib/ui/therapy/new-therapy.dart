import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_theraphy/data/remote/http_helper.dart';

class NewTherapy extends StatefulWidget {
  const NewTherapy({super.key});

  @override
  State<NewTherapy> createState() => _NewTherapyState();
}

class _NewTherapyState extends State<NewTherapy> {
  HttpHelper? _httpHelper;

  TextEditingController titleController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController durationController =
      TextEditingController(); // Controlador para la duración

  final DateFormat format = DateFormat("yyyy-MM-dd");
  late DateTime dateTime1;

  String title = "";
  String descripction = "";
  int duration = 0;
  String startAt = "";
  String finishAt = "";
  int patientId = 2;

  Future initialize() async {
    int? id = await _httpHelper?.getPhysiotherapistLogged();
    dateTime1 = DateTime.now();
    startAt = format.format(dateTime1);

    setState(() {});
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
                  Navigator.of(context).pop();
                },
              ),
              const Text(
                "Therapy Creation",
                style: TextStyle(color: Color(0xFF014DBF)),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Alinea los elementos a la izquierda
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0), // Espaciado de 20 píxeles en los lados
                  child: Align(
                    alignment: Alignment
                        .centerLeft, // Justifica el texto a la izquierda
                    child: Text(
                      "Complete the field to create your therapy",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(
                      20.0), // Espaciado de 20 píxeles en todos los lados
                  child: Column(children: [
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
                          controller: titleController, // Asigna el controlador
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: "Therapy's Title",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              borderSide: const BorderSide(
                                color: Color(0xFF0166FE),
                                width: 1.5,
                              ),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                        ),
                        const SizedBox(height: 30.0),
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
                          controller:
                              descripcionController, // Asigna el controlador
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
                          maxLines: 6,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(250)
                          ],
                        ),
                        const SizedBox(height: 30.0),
                        const Text(
                          "Duration (days)",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          controller:
                              durationController, // Asigna el controlador
                          style: const TextStyle(color: Colors.black),
                          keyboardType: TextInputType
                              .number, // Especifica el teclado numérico
                          decoration: InputDecoration(
                            labelText: "Write here", // Etiqueta para el campo
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              borderSide: const BorderSide(
                                color: Color(0xFF0166FE),
                                width: 1.5,
                              ),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
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
                              descripction = descripcionController.text;
                              if (durationController.text.isNotEmpty) {
                                duration = int.tryParse(
                                        durationController.text) ??
                                    0; // Usamos ?? 0 para asignar 0 en caso de que la conversión falle
                                print(duration);
                                finishAt = format.format(
                                    dateTime1.add(Duration(days: duration)));
                                print(finishAt);
                              } else {
                                duration =
                                    0; // Asignamos 0 si el campo de entrada está vacío
                              }
                              if (title != "" &&
                                  descripction != "" &&
                                  duration != 0) {
                                _httpHelper?.addTherapy(title, descripction,
                                    "0", startAt, finishAt, patientId);

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
                                                "The new Therapy has been creted successfully",
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
                                  const Color(
                                      0xFF014DBF)), // Color de fondo personalizado para el botón "Create Virtual Treatment"
                            ),
                            child: const Text("Create New Therapy"),
                          ),
                        )
                      ],
                    ),
                  ]),
                ),
              ]),
          // Otros elementos si es necesario
        ));
  }
}
