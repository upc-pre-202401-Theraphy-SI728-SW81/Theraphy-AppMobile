import 'package:flutter/material.dart';
import 'package:mobile_app_theraphy/config/app_config.dart';
import 'package:mobile_app_theraphy/data/model/medical_history.dart';
import 'package:mobile_app_theraphy/data/model/patient.dart';
import 'package:mobile_app_theraphy/data/remote/http_helper.dart';
import 'package:mobile_app_theraphy/ui/patients/patient-profile.dart';
import 'package:mobile_app_theraphy/ui/patients/patients-list.dart';

class RegisterMedicalHistory extends StatefulWidget {
  const RegisterMedicalHistory({Key? key, required this.patient})
      : super(key: key);
  final Patient patient;

  @override
  State<RegisterMedicalHistory> createState() => _RegisterMedicalHistoryState();
}

class _RegisterMedicalHistoryState extends State<RegisterMedicalHistory> {
  HttpHelper? _httpHelper;
  String? selectedGender = "";
  bool isMaleSelected = false;
  bool isFemaleSelected = false;

  //New Medical History Data
  String gender = "";
  double size = 0.0;
  double weight = 0.0;
  String birthplace = "";
  String hereditaryHistory = "";
  String nonPathologicalHistory = "";
  String pathologicalHistory = "";
  int patientId = 0;

  late FocusNode _focusNode;

  Future initialize() async {
    // Get Lists
    // ignore: sdk_version_since
    patientId = widget.patient.id;

    //Update lists
    setState(() {
      patientId = patientId;
    });
  }

  @override
  void initState() {
    _httpHelper = HttpHelper();
    initialize();
    super.initState();

    _focusNode = FocusNode();
  }

  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _birthPlaceController = TextEditingController();
  final TextEditingController _hereditaryHistoryController =
      TextEditingController();
  final TextEditingController _nonPathologicalHistoryController =
      TextEditingController();
  final TextEditingController _pathologicalHistoryController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    String fullName =
        "${widget.patient.user.firstname} ${widget.patient.user.lastname}";
    String displayName;

    int maxDisplayNameLength = 20;

    if (fullName.length > maxDisplayNameLength) {
      displayName =
          "${widget.patient.user.firstname} \n${widget.patient.user.lastname}";
    } else {
      displayName = fullName;
    }
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          titleSpacing: -10,
          title: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              "Create Medical History",
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
                    builder: (context) => PatientProfile(
                      patient: widget.patient,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(children: [
                  Center(
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(_createRoute(widget.patient.photoUrl));
                          },
                          child: Hero(
                            tag: widget.patient.id,
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              constraints: const BoxConstraints(
                                minWidth: 160.0,
                                maxWidth: 160.0,
                                minHeight: 150,
                                maxHeight: 150,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Image(
                                  image: NetworkImage(widget.patient.photoUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Age: ",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 121, 121, 121),
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${widget.patient.age}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Location: ",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 121, 121, 121),
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${widget.patient.location}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 10.0,
                        right: 10), // Añade el padding a la izquierda
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        Container(
                          alignment: Alignment.topLeft,
                          child: const Text(
                            "Gender",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            // Botón Male
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isMaleSelected = !isMaleSelected;
                                    isFemaleSelected = false;
                                    selectedGender =
                                        isMaleSelected ? "Male" : " ";
                                    gender = selectedGender!;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isMaleSelected
                                        ? Colors.white
                                        : const Color.fromARGB(
                                            255, 238, 238, 238),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isMaleSelected
                                          ? AppConfig.primaryColor
                                          : Colors.transparent,
                                      width: 2.2,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Theme(
                                        data: ThemeData(
                                          unselectedWidgetColor: Colors
                                              .grey, // Color de fondo cuando no está seleccionado
                                          checkboxTheme: CheckboxThemeData(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  4.0), // Ajusta el valor según tus preferencias para hacerlo más o menos redondeado
                                            ),
                                            visualDensity: VisualDensity
                                                .compact, // Ajusta el tamaño de la marca de verificación
                                          ),
                                        ),
                                        child: Checkbox(
                                          value: isMaleSelected,
                                          onChanged: (value) {
                                            setState(() {
                                              isMaleSelected = value ?? false;
                                              isFemaleSelected = false;
                                              selectedGender =
                                                  isMaleSelected ? "Male" : " ";
                                              gender = selectedGender!;
                                            });
                                          },
                                          activeColor: AppConfig.primaryColor,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        "Male",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                                width: 10), // Espacio entre los dos textos

                            // Botón Female
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isFemaleSelected = !isFemaleSelected;
                                    isMaleSelected = false;
                                    selectedGender =
                                        isFemaleSelected ? "Female" : " ";
                                    gender = selectedGender!;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isFemaleSelected
                                        ? Colors.white
                                        : const Color.fromARGB(
                                            255, 238, 238, 238),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isFemaleSelected
                                          ? AppConfig.primaryColor
                                          : Colors.transparent,
                                      width: 2.2,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Theme(
                                        data: ThemeData(
                                          unselectedWidgetColor: Colors
                                              .grey, // Color de fondo cuando no está seleccionado
                                          checkboxTheme: CheckboxThemeData(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  4.0), // Ajusta el valor según tus preferencias para hacerlo más o menos redondeado
                                            ),
                                            visualDensity: VisualDensity
                                                .compact, // Ajusta el tamaño de la marca de verificación
                                          ),
                                        ),
                                        child: Checkbox(
                                          value: isFemaleSelected,
                                          onChanged: (value) {
                                            setState(() {
                                              isFemaleSelected = value ?? false;
                                              isMaleSelected = false;
                                              selectedGender = isFemaleSelected
                                                  ? "Female"
                                                  : " ";
                                              gender = selectedGender!;
                                            });
                                          },
                                          activeColor: AppConfig.primaryColor,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        "Female",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Size",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 15),
                                Row(children: [
                                  SizedBox(
                                    height: 42.0,
                                    width:
                                        100, // Ajusta el valor según sea necesario
                                    child: TextField(
                                      controller: _sizeController,
                                      cursorColor: AppConfig.primaryColor,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10.0, horizontal: 15),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: const BorderSide(
                                            color: Colors
                                                .grey, // Color del borde cuando no está enfocado
                                            width: 2,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                            color: AppConfig
                                                .primaryColor, // Color del borde cuando está enfocado
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Column(
                                    children: [
                                      const SizedBox(height: 15),
                                      const Text(
                                        "m",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 20),
                                      ),
                                    ],
                                  )
                                ]),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Weight",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 15),
                                Row(children: [
                                  SizedBox(
                                    height: 42.0,
                                    width:
                                        100, // Ajusta el valor según sea necesario
                                    child: TextField(
                                      controller: _weightController,
                                      cursorColor: AppConfig.primaryColor,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10.0, horizontal: 15),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: const BorderSide(
                                            color: Colors
                                                .grey, // Color del borde cuando no está enfocado
                                            width: 2,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                            color: AppConfig
                                                .primaryColor, // Color del borde cuando está enfocado
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  const Column(
                                    children: [
                                      SizedBox(height: 15),
                                      Text(
                                        "kg",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 20),
                                      ),
                                    ],
                                  )
                                ]),
                              ],
                            ),
                          ),
                        ]),
                        const SizedBox(height: 20),
                        Row(children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Birth Place",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 15),
                                Row(children: [
                                  SizedBox(
                                    height: 42.0,
                                    width:
                                        332, // Ajusta el valor según sea necesario
                                    child: TextField(
                                      controller: _birthPlaceController,
                                      cursorColor: AppConfig.primaryColor,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10.0, horizontal: 15),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: const BorderSide(
                                            color: Colors
                                                .grey, // Color del borde cuando no está enfocado
                                            width: 2,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                            color: AppConfig.primaryColor,
                                            // Color del borde cuando está enfocado
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              ],
                            ),
                          ),
                        ]),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Hereditary History",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  SizedBox(
                                    width:
                                        350, // Ajusta el valor según sea necesario
                                    child: TextField(
                                      controller: _hereditaryHistoryController,
                                      cursorColor: AppConfig.primaryColor,
                                      obscureText: false,
                                      maxLines:
                                          null, // Permite múltiples líneas
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal: 15,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: const BorderSide(
                                            color: Colors
                                                .grey, // Color del borde cuando no está enfocado
                                            width: 2,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                            color: AppConfig
                                                .primaryColor, // Color del borde cuando está enfocado
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Non Pathological History",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  SizedBox(
                                    width:
                                        350, // Ajusta el valor según sea necesario
                                    child: TextField(
                                      controller:
                                          _nonPathologicalHistoryController,
                                      cursorColor: AppConfig.primaryColor,
                                      obscureText: false,
                                      maxLines:
                                          null, // Permite múltiples líneas
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal: 15,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: const BorderSide(
                                            color: Colors
                                                .grey, // Color del borde cuando no está enfocado
                                            width: 2,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                            color: AppConfig
                                                .primaryColor, // Color del borde cuando está enfocado
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Pathological History",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  SizedBox(
                                    width:
                                        350, // Ajusta el valor según sea necesario
                                    child: TextField(
                                      controller:
                                          _pathologicalHistoryController,
                                      cursorColor: AppConfig.primaryColor,
                                      obscureText: false,
                                      maxLines:
                                          null, // Permite múltiples líneas
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal: 15,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: const BorderSide(
                                            color: Colors
                                                .grey, // Color del borde cuando no está enfocado
                                            width: 2,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                            color: AppConfig
                                                .primaryColor, // Color del borde cuando está enfocado
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    1.0, 0.0, 1.0, 15.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Acción a realizar cuando se presiona el botón "Create Medical History"

                                    if (_sizeController.text.isNotEmpty) {
                                      size = double.tryParse(
                                          _sizeController.text)!;
                                    }

                                    if (_weightController.text.isNotEmpty) {
                                      weight = double.tryParse(
                                          _weightController.text)!;
                                    }

                                    birthplace = _birthPlaceController.text;
                                    hereditaryHistory =
                                        _hereditaryHistoryController.text;
                                    nonPathologicalHistory =
                                        _nonPathologicalHistoryController.text;
                                    pathologicalHistory =
                                        _pathologicalHistoryController.text;

                                    // Verificar si el widget está montado antes de llamar a setState
                                    if (mounted) {
                                      setState(() {
                                        _httpHelper?.createMedicalHistory(
                                            gender,
                                            size,
                                            weight,
                                            birthplace,
                                            hereditaryHistory,
                                            nonPathologicalHistory,
                                            pathologicalHistory,
                                            patientId);

                                        // Muestra un diálogo emergente con el mensaje de éxito
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return WillPopScope(
                                                onWillPop: () async {
                                                  // Redirige a una pantalla específica
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const PatientsList()),
                                                  );
                                                  return false; // Bloquea la navegación hacia atrás
                                                },
                                                child: Center(
                                                  child: SimpleDialog(
                                                    title: const Column(
                                                      children: [
                                                        Icon(
                                                          Icons.check,
                                                          color: Colors.green,
                                                          size: 80,
                                                        ),
                                                        SizedBox(height: 10),
                                                        Center(
                                                          child: Text(
                                                            "The Medical History has been created successfully",
                                                            textAlign: TextAlign
                                                                .center,
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
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            PatientProfile(
                                                                      patient:
                                                                          widget
                                                                              .patient,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty
                                                                        .all<
                                                                            Color>(
                                                                  const Color(
                                                                      0xFF014DBF),
                                                                ),
                                                              ),
                                                              child: const Text(
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
                                                ));
                                          },
                                        );
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppConfig.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: SizedBox(
                                    height:
                                        50, // Ajusta la altura según sea necesario
                                    child: Center(
                                      child: const Text(
                                        "Create Medical History",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]))));
  }

  PageRouteBuilder _createRoute(String imageUrl) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return FullScreenImage(imageUrl: imageUrl);
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOut;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var fadeAnimation = animation.drive(tween);
        return FadeTransition(
          opacity: fadeAnimation,
          child: child,
        );
      },
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8), // Fondo translúcido
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network(imageUrl),
          ),
        ),
      ),
    );
  }
}
