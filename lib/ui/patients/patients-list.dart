import 'package:flutter/material.dart';
import 'package:mobile_app_theraphy/config/app_config.dart';
import 'package:mobile_app_theraphy/config/navBar.dart';
import 'package:mobile_app_theraphy/data/model/patient.dart';
import 'package:mobile_app_theraphy/data/remote/http_helper.dart';
import 'package:mobile_app_theraphy/ui/patients/patient-profile.dart';
import 'package:mobile_app_theraphy/ui/patients/prueba.dart';
import 'package:mobile_app_theraphy/ui/profile/physiotherapist_profile.dart';

class PatientsList extends StatefulWidget {
  const PatientsList({super.key});

  @override
  State<PatientsList> createState() => _PatientsListState();
}

class _PatientsListState extends State<PatientsList> {
  int selectedIndex = 1;
  HttpHelper? _httpHelper;
  List<Patient>? myPatients = [];
  List<Patient>? filteredPatients = [];
  int? id;
  bool _withTherapy = false;
  bool _onlyConsultation = false;
  int itemsQuantity = 0;

  List<Widget> pages = const [
    PatientsList(),
    ProfilePage(),
    ProfilePage(),
    ProfilePage(),
    ProfilePage(),
    //HomePhysiotherapist(),

    //ListAppointments(),
    //ListTreatments(),
  ];

  Future initialize() async {
    //Get user logged
    id = await _httpHelper?.getPhysiotherapistLogged();

    // Get Lists
    // ignore: sdk_version_since
    myPatients = List.empty();
    myPatients = await _httpHelper?.getMyPatients(id!);

    //Update lists
    setState(() {
      id = id;
      myPatients = myPatients;
      filteredPatients = myPatients;
      itemsQuantity = filteredPatients!.length;
    });
  }

  TextEditingController searchController =
      TextEditingController(); // Controlador del campo de búsqueda

  @override
  void initState() {
    _httpHelper = HttpHelper();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(
                top: 20), // Ajusta la cantidad de espacio según tus necesidades
            child: Text(
              "My Patients",
              style: TextStyle(
                color: AppConfig.primaryColor,
                fontSize: 24,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          automaticallyImplyLeading: false,
          elevation: 0,
        ),
        body: Container(
          color: Colors.white, // Fondo blanco
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(22.0, 22.0, 22.0, 0),
                child: Container(
                  width: 360,
                  child: TextField(
                    cursorColor: AppConfig.primaryColor,
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        filteredPatients = myPatients
                            ?.where((patient) =>
                                ('${patient.user.firstname} ${patient.user.lastname}')
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                            .toList();

                        itemsQuantity = filteredPatients!.length;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppConfig.primaryColor,
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppConfig.primaryColor, width: 2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppConfig.primaryColor, width: 2.2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelStyle: TextStyle(
                        color: AppConfig.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22.0, 5, 22.0, 10),
                child: Row(
                  children: [
                    if (_withTherapy == false)
                      ElevatedButton(
                        onPressed: () async {
                          filteredPatients =
                              await _httpHelper?.getMyPatientsWithTheraphy(id!);
                          setState(() {
                            filteredPatients = filteredPatients;
                            _withTherapy = true;
                            _onlyConsultation = false;

                            itemsQuantity = filteredPatients!.length;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.white), // Fondo blanco
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Bordes redondeados en todos los lados
                            ),
                          ),
                          elevation:
                              MaterialStateProperty.all(0), // Sin elevación
                          side: MaterialStateProperty.all(BorderSide(
                            color: AppConfig.primaryColor, // Color azul
                            width: 1.5, // Ancho del borde
                          )),
                          minimumSize: MaterialStateProperty.all(
                              Size(110, 30)), // Ancho mínimo del botón
                        ),
                        child: Text(
                          'With Therapy',
                          style: TextStyle(color: AppConfig.primaryColor),
                        ),
                      ),
                    if (_withTherapy == true)
                      ElevatedButton(
                        onPressed: () async {
                          filteredPatients =
                              await _httpHelper?.getMyPatients(id!);
                          setState(() {
                            filteredPatients = filteredPatients;
                            _withTherapy = false;
                            itemsQuantity = filteredPatients!.length;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              AppConfig.primaryColor), // Fondo blanco
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Bordes redondeados en todos los lados
                            ),
                          ),
                          elevation:
                              MaterialStateProperty.all(0), // Sin elevación
                          minimumSize: MaterialStateProperty.all(
                              Size(110, 30)), // Ancho mínimo del botón
                        ),
                        child: Text(
                          'With Therapy',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    Container(width: 10, color: AppConfig.primaryColor),
                    if (_onlyConsultation == false)
                      ElevatedButton(
                        onPressed: () async {
                          filteredPatients = await _httpHelper
                              ?.getMyPatientsOnlyConsultation(id!);
                          setState(() {
                            filteredPatients = filteredPatients;
                            _onlyConsultation = true;
                            _withTherapy = false;
                            itemsQuantity = filteredPatients!.length;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.white), // Fondo blanco
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Bordes redondeados en todos los lados
                            ),
                          ),
                          elevation:
                              MaterialStateProperty.all(0), // Sin elevación
                          side: MaterialStateProperty.all(BorderSide(
                            color: AppConfig.primaryColor, // Color azul
                            width: 1.5, // Ancho del borde
                          )),
                          minimumSize: MaterialStateProperty.all(
                              Size(110, 30)), // Ancho mínimo del botón
                        ),
                        child: Text(
                          'Only Consultation',
                          style: TextStyle(color: AppConfig.primaryColor),
                        ),
                      ),
                    if (_onlyConsultation == true)
                      ElevatedButton(
                        onPressed: () async {
                          filteredPatients =
                              await _httpHelper?.getMyPatients(id!);
                          setState(() {
                            filteredPatients = filteredPatients;
                            _onlyConsultation = false;
                            itemsQuantity = filteredPatients!.length;
                          });
                          ;
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              AppConfig.primaryColor), // Fondo blanco
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Bordes redondeados en todos los lados
                            ),
                          ),
                          elevation:
                              MaterialStateProperty.all(0), // Sin elevación
                          minimumSize: MaterialStateProperty.all(
                              Size(110, 30)), // Ancho mínimo del botón
                        ),
                        child: Text(
                          'Only Consultation',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    Container(
                      width: 38,
                      color: Colors.white, //AppConfig.primaryColor
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 17,
                          color: AppConfig.primaryColor,
                        ),
                        children: [
                          TextSpan(
                            text: '$itemsQuantity',
                            style: TextStyle(
                              fontSize: 17, // Tamaño más grande para el valor
                              fontWeight: FontWeight
                                  .bold, // Opcional: para hacer el valor en negrita
                            ),
                          ),
                          TextSpan(
                            text: ' results',
                            style: TextStyle(
                              fontSize: 11, // Tamaño del texto
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: filteredPatients == null || filteredPatients!.isEmpty
                    ? const Center(
                        child: Text(
                          'No patients found',
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredPatients!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                             padding: EdgeInsets.only(top: 5, bottom: 5.0), 
                              // Ajusta el valor del padding según sea necesario
                              child: PatientItem(
                                  patient: filteredPatients![index]));
                        },
                      ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: NavBar(currentIndex: 1));
  }
}

class PatientItem extends StatefulWidget {
  const PatientItem({super.key, required this.patient});
  final Patient patient;

  @override
  State<PatientItem> createState() => _PatientItemState();
}

class _PatientItemState extends State<PatientItem> {
  @override
  Widget build(BuildContext context) {
    String fullName =
        "${widget.patient.user.firstname} ${widget.patient.user.lastname}";
    String displayName;

    int maxDisplayNameLength = 20;

    if (fullName.length > maxDisplayNameLength) {
      displayName =
          "${widget.patient.user.firstname} ${widget.patient.user.lastname[0]}.";
    } else {
      displayName = fullName;
    }

    return FractionallySizedBox(
      widthFactor: 0.9,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white,
        elevation: 4,
        child: Column(
          children: [
            Row(
              children: [
                Hero(
                  tag: widget.patient.id,
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    constraints: const BoxConstraints(
                      minWidth: 120.0,
                      maxWidth: 120.0,
                      minHeight: 120,
                      maxHeight: 120,
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
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
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
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${widget.patient.age}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
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
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${widget.patient.location}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 1),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Acción a realizar cuando se presiona el botón "View Profile"
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PatientProfile(
                              patient: widget.patient,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConfig.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "View Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
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
    );
  }
}
