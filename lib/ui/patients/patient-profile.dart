import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_theraphy/config/app_config.dart';
import 'package:mobile_app_theraphy/data/model/diagnosis.dart';
import 'package:mobile_app_theraphy/data/model/medical_history.dart';
import 'package:mobile_app_theraphy/data/model/patient.dart';
import 'package:mobile_app_theraphy/data/model/therapy.dart';
import 'package:mobile_app_theraphy/data/remote/http_helper.dart';
import 'package:mobile_app_theraphy/ui/patients/patients-list.dart';
import 'package:mobile_app_theraphy/ui/patients/register-medical-history.dart';
import 'package:mobile_app_theraphy/ui/therapy/my-therapy.dart';
import 'package:mobile_app_theraphy/ui/therapy/new-therapy.dart';

class PatientProfile extends StatefulWidget {
  const PatientProfile({Key? key, required this.patient}) : super(key: key);
  final Patient patient;

  @override
  State<PatientProfile> createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  bool _isHereditaryHistoryPanelExpanded = false;
  bool _isNonPathologicalHistoryPanelExpanded = false;
  bool _isPathologicalHistoryPanelExpanded = false;
  Therapy? patientTherapy;
  MedicalHistory? patientMedicalHistory;

  int selectedIndex = 1;
  HttpHelper? _httpHelper;
  List<Diagnosis>? patientDiagnoses = [];

  List<Widget> pages = const [
    //HomePhysiotherapist(),
    PatientsList(),
    //ListAppointments(),
    //ListTreatments(),
    //PhysiotherapistProfile(),
  ];

  Future initialize() async {
    // Get Lists
    // ignore: sdk_version_since
    patientDiagnoses = List.empty();
    patientDiagnoses =
        await _httpHelper?.getPatientDiagnoses(widget.patient.id);

    patientTherapy = await _httpHelper?.getPatientTherapy(widget.patient.id);

    patientMedicalHistory =
        await _httpHelper?.getMedicalHistoryByPatientId(widget.patient.id);

    if (mounted) {
      setState(() {
        patientMedicalHistory = patientMedicalHistory;
        patientTherapy = patientTherapy;
        patientDiagnoses = patientDiagnoses;
      });
    }
  }

  @override
  void initState() {
    _httpHelper = HttpHelper();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String fullName =
        "${widget.patient.user.firstname} ${widget.patient.user.lastname}";
    String displayName;

    int maxDisplayNameLength = 20;

    if (fullName.length > maxDisplayNameLength) {
      displayName =
          "${widget.patient.user.firstname} \n${widget.patient.user.lastname}";
      ;
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
              "Patient Profile",
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
                    builder: (context) => const PatientsList(),
                  ),
                );
              },
            ),
          ),
        ),
        body: Stack(children: [
          ListView(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
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
                  const SizedBox(height: 15),
                  if (patientMedicalHistory == null)
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.network(
                            'https://raw.githubusercontent.com/upc-pre-202302-IoTheraphy-SI572-SW71/ReportAssets/main/user-not-found-account-not-register-concept-illustration-flat-design-eps10-modern-graphic-element-for-landing-page-empty-state-ui-infographic-icon-vector-removebg-preview.png',
                            width:
                                200, // Ajusta el ancho de la imagen según tus necesidades
                            height:
                                200, // Ajusta el alto de la imagen según tus necesidades
                          ),
                          const Text(
                            "No medical history registered for this patient",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterMedicalHistory(
                                    patient: widget.patient,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppConfig.primaryColor,
                            ),
                            child: const Text(
                              "Create Medical History",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Column(
                      children: [
                        FractionallySizedBox(
                          // Usamos FractionallySizedBox para expandir horizontalmente
                          widthFactor:
                              1.0, // 1.0 significa el 100% del ancho disponible
                          child: Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: AppConfig.primaryColor,
                                  width: 1,
                                ),
                                bottom: BorderSide(
                                  color: AppConfig.primaryColor,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0, 5.0, 0, 5.0), // Padding para top y bottom
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Alinea el texto al inicio (izquierda)
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Gender ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      ),
                                      Text(
                                        "${patientMedicalHistory?.gender}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Size ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      ),
                                      Text(
                                        "${patientMedicalHistory?.size} m",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Weight ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      ),
                                      Text(
                                        "${patientMedicalHistory?.weight} kg",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Birth Place ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      ),
                                      Text(
                                        "${patientMedicalHistory?.birthplace}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Botón HereditaryHistory
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  if (mounted) {
                                    setState(() {
                                      _isHereditaryHistoryPanelExpanded =
                                          !_isHereditaryHistoryPanelExpanded;
                                    });
                                  }
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white, // Fondo blanco
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Hereditary History",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(
                                      _isHereditaryHistoryPanelExpanded
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: AppConfig.primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Panel que se expande o colapsa
                        if (_isHereditaryHistoryPanelExpanded)
                          Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: FractionallySizedBox(
                              widthFactor: 1.0,
                              child: Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Color.fromARGB(255, 127, 127, 127),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                          top: 10), // Separación superior mayor
                                      child: Text(
                                        "${patientMedicalHistory?.hereditaryHistory}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                        // Botón NonPathologicalHistory
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  if (mounted) {
                                    setState(() {
                                      _isNonPathologicalHistoryPanelExpanded =
                                          !_isNonPathologicalHistoryPanelExpanded;
                                    });
                                  }
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white, // Fondo blanco
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Non Pathological History",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(
                                      _isNonPathologicalHistoryPanelExpanded
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: AppConfig.primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Panel que se expande o colapsa
                        if (_isNonPathologicalHistoryPanelExpanded)
                          Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: FractionallySizedBox(
                              widthFactor: 1.0,
                              child: Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Color.fromARGB(255, 127, 127, 127),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                          top: 10), // Separación superior mayor
                                      child: Text(
                                        "${patientMedicalHistory?.nonPathologicalHistory}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                        // Botón PathologicalHistory
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  if (mounted) {
                                    setState(() {
                                      _isPathologicalHistoryPanelExpanded =
                                          !_isPathologicalHistoryPanelExpanded;
                                    });
                                  }
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white, // Fondo blanco
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Pathological History",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(
                                      _isPathologicalHistoryPanelExpanded
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: AppConfig.primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Panel que se expande o colapsa
                        if (_isPathologicalHistoryPanelExpanded)
                          Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: FractionallySizedBox(
                              widthFactor: 1.0,
                              child: Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Color.fromARGB(255, 127, 127, 127),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                          top: 10), // Separación superior mayor
                                      child: Text(
                                        "${patientMedicalHistory?.pathologicalHistory}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: AppConfig.primaryColor,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                margin: const EdgeInsets.only(
                                  right: 10,
                                  left:
                                      10.0, // Ajusta el margen izquierdo según tus necesidades
                                  top:
                                      20, // Ajusta el margen superior según tus necesidades
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10), // Ajusta el relleno
                                  child: Text(
                                    "Diagnoses",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        if (patientDiagnoses == null)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom:
                                      40), // Ajusta el valor según tus necesidades
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.network(
                                    'https://raw.githubusercontent.com/upc-pre-202302-IoTheraphy-SI572-SW71/ReportAssets/main/user-not-found-account-not-register-concept-illustration-flat-design-eps10-modern-graphic-element-for-landing-page-empty-state-ui-infographic-icon-vector-removebg-preview.png',
                                    width: 100,
                                    height: 100,
                                  ),
                                  const Text(
                                    "No found diagnoses for this patient",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 137, 137, 137),
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 15),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: ListView.builder(
                                itemCount: patientDiagnoses?.length,
                                itemBuilder: (context, index) {
                                  return DiagnosisItem(
                                    diagnosis: patientDiagnoses![index],
                                  );
                                },
                              ),
                            ),
                          ),
                        const SizedBox(height: 50),
                      ],
                    ),
                ],
              ),
            ),
          ]),
          if (patientTherapy == null)
            // Botón "Crear Terapia" superpuesto en la parte inferior
            Positioned(
              left: 0,
              right: 0,
              bottom: 1,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  child: const Text(
                    "Create Therapy",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewTherapy(
                          patientId: widget.patient.id,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: AppConfig.primaryColor, // Color de fondo azul
                    padding:
                        const EdgeInsets.all(16), // Ajusta el relleno del botón
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15), // Borde redondeado
                    ),
                  ),
                ),
              ),
            ),
          if (patientTherapy != null)
            // Botón "Crear Terapia" superpuesto en la parte inferior
            Positioned(
              left: 0,
              right: 0,
              bottom: 1,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  child: const Text(
                    "View Therapy",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyTherapy(
                          patientId: patientTherapy!.patient.id,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppConfig.primaryColor, // Color de fondo azul
                    padding:
                        const EdgeInsets.all(16), // Ajusta el relleno del botón
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15), // Borde redondeado
                    ),
                  ),
                ),
              ),
            )
        ]));
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

class DiagnosisItem extends StatefulWidget {
  const DiagnosisItem({super.key, required this.diagnosis});
  final Diagnosis diagnosis;

  @override
  State<DiagnosisItem> createState() => _DiagnosisItemState();
}

class _DiagnosisItemState extends State<DiagnosisItem> {
  @override
  Widget build(BuildContext context) {

    String formattedDate = '';

    try {
      DateTime parsedDate =
          DateFormat('yyyy-MM-dd').parse(widget.diagnosis.date);
      formattedDate = DateFormat('MMMM dd, yyyy').format(parsedDate);

    } catch (e) {
      print('Error parsing date: $e');
    }
    return Container(
      margin: const EdgeInsets.only(
          bottom: 16), // Ajusta el espacio entre las tarjetas
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Colors.white,
          elevation: 6,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    left: 17, right: 15, top: 25, bottom: 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        widget.diagnosis.diagnosis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10, // Ajusta la posición superior para la fecha
                right: 10, // Ajusta la posición derecha para la fecha
                child: Row(
                  children: [
                     Text(
                      "Date: ",
                      style: TextStyle(
                        color: Color.fromARGB(255, 111, 111, 111),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 111, 111, 111),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom:
                    10, // Ajusta la posición inferior para el nombre de usuario
                right:
                    10, // Ajusta la posición derecha para el nombre de usuario
                child: Row(
                  children: [
                    const Text(
                      "Dr. ",
                      style: TextStyle(
                        color: Color.fromARGB(255, 111, 111, 111),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      '${widget.diagnosis.physiotherapist.user.firstname} ${widget.diagnosis.physiotherapist.user.lastname}',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 111, 111, 111),
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                      ),
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
