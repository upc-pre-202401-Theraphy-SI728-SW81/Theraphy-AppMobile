import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_theraphy/config/app_config.dart';
import 'package:mobile_app_theraphy/config/navBar.dart';
import 'package:mobile_app_theraphy/data/model/iot_device.dart';
import 'package:mobile_app_theraphy/data/model/patient.dart';
import 'package:mobile_app_theraphy/data/model/user.dart';
import 'package:mobile_app_theraphy/data/remote/http_helper.dart';
import 'package:mobile_app_theraphy/ui/iot_devices/iot_device.dart';
import 'package:mobile_app_theraphy/ui/patients/patient-profile.dart';
import 'package:mobile_app_theraphy/ui/patients/prueba.dart';
import 'package:mobile_app_theraphy/ui/profile/physiotherapist_profile.dart';

class IotdevicesList extends StatefulWidget {
  const IotdevicesList({super.key});

  @override
  State<IotdevicesList> createState() => _IotdevicesListState();
}

class _IotdevicesListState extends State<IotdevicesList> {
  int selectedIndex = 4;

  HttpHelper? _httpHelper;
  List<IotDevice>? myIotDevices = [];

  List<IotDevice>? filteredIotDevices = [];

  List<Patient>? myPatientsWithTherapy = [];

  List<Patient>? patientsAvailableForAssignment = [];

  int? id;
  bool _withTherapy = false;
  bool _onlyConsultation = false;
  String formattedDate = DateFormat('MMMM dd, yyyy').format(DateTime.now());

 

  Patient? selectedPatient;
  List<Widget> pages = const [
    ProfilePage(),
    ProfilePage(),
    ProfilePage(),
    ProfilePage(),
    IotdevicesList(),
    //HomePhysiotherapist(),

    //ListAppointments(),
    //ListTreatments(),
  ];

  Future initialize() async {
    //Get user logged
    id = await _httpHelper?.getPhysiotherapistLogged();

    // Get Lists
    // ignore: sdk_version_since
    myIotDevices = List.empty();
    myIotDevices = await _httpHelper?.getMyIotDevices(id!) ?? [];

    myPatientsWithTherapy = List.empty();
    myPatientsWithTherapy =
        await _httpHelper?.getMyPatientsWithTheraphy(id!) ?? [];

    //Update lists
    setState(() {
      id = id;
      myIotDevices = myIotDevices;
      filteredIotDevices = myIotDevices;
      myPatientsWithTherapy = myPatientsWithTherapy;
      patientsAvailableForAssignment = myPatientsWithTherapy?.where((patient) {
        // Filtrar pacientes que no estén en myIotDevices
        return !myIotDevices!.any((iotDevice) =>
            iotDevice.therapy?.patient.id == patient.id &&
            (iotDevice.therapy?.finished == false));
      }).toList();
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
            "My IoT Devices",
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
      body: Stack(
        children: [
          Container(
            color: Colors.white, // Fondo blanco
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(22.0, 22.0, 22.0, 22.0),
                  child: Container(
                    width: 360,
                    child: TextField(
                      cursorColor: AppConfig.primaryColor,
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          filteredIotDevices = myIotDevices
                              ?.where((iotDevice) =>
                                  ('${iotDevice.therapy?.patient.user.firstname} ${iotDevice.therapy?.patient.user.lastname}')
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                              .toList();
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
                          borderSide: BorderSide(
                              color: AppConfig.primaryColor, width: 2),
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
                Expanded(
                  child:
                      filteredIotDevices == null || filteredIotDevices!.isEmpty
                          ? const Center(
                              child: Text(
                                'No patients with assigned IoT devices found',
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredIotDevices!.length,
                              itemBuilder: (context, index) {
                                bool isLastItem =
                                    index == filteredIotDevices!.length - 1;

                                return Padding(
                                  padding: isLastItem
                                      ? EdgeInsets.only(bottom: 60.0)
                                      : EdgeInsets
                                          .zero, // Ajusta el valor del padding según sea necesario
                                  child: PatientItem(
                                    iotDevice: filteredIotDevices![index],
                                    patientsAvailableForAssignment:
                                        patientsAvailableForAssignment,
                                    id: id,
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 25.0, // Ajusta según sea necesario
            left: MediaQuery.of(context).size.width / 2 +
                30, // Centra el botón horizontalmente
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Container(
                          width: MediaQuery.of(context)
                              .size
                              .width, // Ancho total de la pantalla
                          height: 400, // Altura del contenedor
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(35),
                              topRight: Radius.circular(35),
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              // Icono y texto en la esquina superior izquierda
                              Positioned(
                                top: 25,
                                left: 30,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.people,
                                        size: 28), // Icono más grande
                                    SizedBox(height: 4),
                                    Text(
                                      '0 uses',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Icono y texto en la esquina superior derecha
                              Positioned(
                                top: 25,
                                right: 30,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.favorite_rounded,
                                        size: 28), // Icono más grande
                                    SizedBox(height: 4),
                                    Text(
                                      '100%',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Contenido principal
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/iot.png',
                                      height: 150,
                                      width: 150,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Assign to",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width:
                                          320, // Ancho deseado para la lista desplegable
                                      child: DropdownButtonFormField<Patient>(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide:
                                                BorderSide(color: Colors.blue),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide:
                                                BorderSide(color: Colors.blue),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          suffixIcon: Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors
                                                  .blue), // Color del icono de flecha
                                        ),
                                        icon: Icon(Icons.keyboard_arrow_down,
                                            color: Colors
                                                .transparent), // Oculta el icono predeterminado
                                        value: selectedPatient,
                                        onChanged: (Patient? newValue) {
                                          setState(() {
                                            selectedPatient = newValue;
                                          });
                                        },
                                        items: patientsAvailableForAssignment
                                                    ?.isEmpty ??
                                                true
                                            ? [
                                                DropdownMenuItem<Patient>(
                                                  value: null,
                                                  child: Text(
                                                    'No patients available for selection',
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                              ]
                                            : patientsAvailableForAssignment
                                                ?.map((Patient patient) {
                                                String fullName =
                                                    "${patient.user.firstname} ${patient.user.lastname}";
                                                String displayName;

                                                int maxDisplayNameLength = 20;

                                                if (fullName.length >
                                                    maxDisplayNameLength) {
                                                  displayName =
                                                      "${patient.user.firstname} ${patient.user.lastname[0]}.";
                                                } else {
                                                  displayName = fullName;
                                                }
                                                return DropdownMenuItem<
                                                    Patient>(
                                                  value: patient,
                                                  child: Row(
                                                    children: <Widget>[
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: Image(
                                                          image: NetworkImage(
                                                              patient.photoUrl),
                                                          width: 40,
                                                          height: 40,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text(displayName),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: "Assignment date: ",
                                          ),
                                          TextSpan(
                                            text: formattedDate,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: selectedPatient != null
                                            ? Color.fromARGB(255, 74, 194, 100)
                                            : Colors.white,
                                        onPrimary: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 15),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          side: selectedPatient != null
                                              ? BorderSide.none
                                              : BorderSide(
                                                  color: AppConfig
                                                      .primaryColor, // Color del borde
                                                  width: 0.5, // Ancho del borde
                                                ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (selectedPatient != null) {
                                          await _httpHelper?.creatIoTDevice(
                                              id!, selectedPatient!.id);

                                          String fullName =
                                              "${selectedPatient?.user.firstname} ${selectedPatient?.user.lastname}";
                                          String displayNameConfirmation;

                                          int maxDisplayNameLength = 20;

                                          if (fullName.length >
                                              maxDisplayNameLength) {
                                            displayNameConfirmation =
                                                "${selectedPatient?.user.firstname} ${selectedPatient?.user.lastname[0]}.";
                                          } else {
                                            displayNameConfirmation = fullName;
                                          }
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            builder: (BuildContext context2) {
                                              return ClipPath(
                                                clipper: TriangleClipper(),
                                                child: Container(
                                                  height: MediaQuery.of(
                                                              context2)
                                                          .size
                                                          .height *
                                                      0.65, // Altura del 75% de la pantalla
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                  ),
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .check_circle_outline_rounded,
                                                          color: Colors.white,
                                                          size: 100,
                                                        ),
                                                        SizedBox(height: 20),
                                                        Text(
                                                          'IoT Device assigned successfully',
                                                          style: TextStyle(
                                                            fontSize: 24,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Text(
                                                          'The device was assigned to ${displayNameConfirmation}',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.white,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ).whenComplete(() {
                                            // Navigate to the new view when the modal is closed
                                            WidgetsBinding.instance!
                                                .addPostFrameCallback((_) {
                                              if (context != null) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          IotdevicesList()),
                                                );
                                              }
                                            });
                                          });
                                        }
                                      },
                                      child: Center(
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            style: TextStyle(
                                              color: selectedPatient != null
                                                  ? Colors.white
                                                  : Colors.grey,
                                              fontSize: 14,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: "Assign New IoT Device",
                                              ),
                                            ],
                                          ),
                                        ),
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
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: AppConfig.primaryColor,
                  borderRadius:
                      BorderRadius.circular(30), // Bordes más redondeados
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Cambia la posición de la sombra
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 12,
                      child: Icon(
                        Icons.add,
                        color: AppConfig.primaryColor,
                        size: 16,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'New IoT Device',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavBar(currentIndex: 4),
    );
  }
}

class PatientItem extends StatefulWidget {
  const PatientItem(
      {super.key,
      required this.iotDevice,
      required this.patientsAvailableForAssignment,
      required this.id});
  final IotDevice iotDevice;
  final List<Patient>? patientsAvailableForAssignment;
  final int? id;

  @override
  State<PatientItem> createState() => _PatientItemState();
}

class _PatientItemState extends State<PatientItem> {
  Patient? selectedPatient;
  HttpHelper? _httpHelper;

  @override
  void initState() {
    _httpHelper = HttpHelper();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String deviceStatus = "";
    String displayName;
    String formattedDate = DateFormat('MMMM dd, yyyy').format(DateTime.now());
    if (widget.iotDevice.therapy?.id != 0 &&
        widget.iotDevice.therapy?.finished != true) {
      deviceStatus = "Assigned";
    } else {
      deviceStatus = "Available";
    }
    String fullName =
        "${widget.iotDevice.therapy?.patient.user.firstname} ${widget.iotDevice.therapy?.patient.user.lastname}";

    int maxDisplayNameLength = 20;

    if (fullName.length > maxDisplayNameLength) {
      displayName =
          "${widget.iotDevice.therapy?.patient.user.firstname} ${widget.iotDevice.therapy?.patient.user.lastname[0]}.";
    } else {
      displayName = fullName;
    }
    return FractionallySizedBox(
        widthFactor: 0.9,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 20.0,
                  bottom: 12), // Ajusta el espacio en la parte superior
              child: Card(
                shadowColor: Colors.black
                    .withOpacity(0.2), // Color de la sombra con opacidad
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10.0), // Bordes redondeados
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white, // Fondo blanco para el Container
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                            0.2), // Color de la sombra con opacidad
                        spreadRadius: 2, // Radio de difusión de la sombra
                        blurRadius: 4, // Radio de desenfoque de la sombra
                        offset: Offset(0, 2), // Desplazamiento de la sombra
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "IoT Device ${widget.iotDevice.id}",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person),
                                  SizedBox(width: 8),
                                  Text(displayName),
                                ],
                              ),
                              SizedBox(width: 20),
                              Row(
                                children: [
                                  Icon(Icons.favorite_rounded),
                                  SizedBox(width: 8),
                                  Text(
                                      '${(100 - (widget.iotDevice.therapyQuantity! / 10) * 100).toStringAsFixed(0)}%'),
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(
                                      255, 218, 228, 237), // Fondo del botón
                                  onPrimary: Colors.black, // Color del texto
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Esquinas menos redondeadas
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MapView(
                                        iotDevice: widget.iotDevice,
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.play_circle_rounded,
                                  color:
                                      AppConfig.primaryColor, // Color del icono
                                ),
                                label: Text(
                                  'View Info',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ), // Color del texto
                                ),
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  primary: widget.iotDevice.therapy?.id != 0 &&
                                          widget.iotDevice.therapy?.finished !=
                                              true
                                      ? AppConfig.primaryColor
                                      : Color.fromARGB(
                                          255, 74, 194, 100), // Fondo blanco
                                  onPrimary: Colors.white, // Color del texto
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Esquinas menos redondeadas
                                  ),
                                ),
                                onPressed: () {
                                  if (deviceStatus == "Available") {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          builder: (BuildContext context,
                                              StateSetter setState) {
                                            return Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width, // Ancho total de la pantalla
                                              height:
                                                  400, // Altura del contenedor
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(35),
                                                  topRight: Radius.circular(35),
                                                ),
                                              ),
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: <Widget>[
                                                  // Icono y texto en la esquina superior izquierda
                                                  Positioned(
                                                    top: 25,
                                                    left: 30,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Icon(Icons.people,
                                                            size:
                                                                28), // Icono más grande
                                                        SizedBox(height: 4),
                                                        Text(
                                                          '${widget.iotDevice.therapyQuantity} uses',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // Icono y texto en la esquina superior derecha
                                                  Positioned(
                                                    top: 25,
                                                    right: 30,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Icon(
                                                            Icons
                                                                .favorite_rounded,
                                                            size:
                                                                28), // Icono más grande
                                                        SizedBox(height: 4),
                                                        Text(
                                                          '${(100 - (widget.iotDevice.therapyQuantity! / 10) * 100).toStringAsFixed(0)}%',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // Contenido principal
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Image.asset(
                                                          'assets/iot.png',
                                                          height: 150,
                                                          width: 150,
                                                        ),
                                                        SizedBox(height: 5),
                                                        Text(
                                                          "Assign to",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Container(
                                                          width:
                                                              320, // Ancho deseado para la lista desplegable
                                                          child:
                                                              DropdownButtonFormField<
                                                                  Patient>(
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .blue),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .blue),
                                                              ),
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          16.0),
                                                              suffixIcon: Icon(
                                                                  Icons
                                                                      .keyboard_arrow_down,
                                                                  color: Colors
                                                                      .blue), // Color del icono de flecha
                                                            ),
                                                            icon: Icon(
                                                                Icons
                                                                    .keyboard_arrow_down,
                                                                color: Colors
                                                                    .transparent), // Oculta el icono predeterminado
                                                            value:
                                                                selectedPatient,
                                                            onChanged: (Patient?
                                                                newValue) {
                                                              setState(() {
                                                                selectedPatient =
                                                                    newValue;
                                                              });
                                                            },
                                                            items: widget
                                                                        .patientsAvailableForAssignment
                                                                        ?.isEmpty ??
                                                                    true
                                                                ? [
                                                                    DropdownMenuItem<
                                                                        Patient>(
                                                                      value:
                                                                          null,
                                                                      child:
                                                                          Text(
                                                                        'No patients available for selection',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.grey),
                                                                      ),
                                                                    ),
                                                                  ]
                                                                : widget
                                                                    .patientsAvailableForAssignment
                                                                    ?.map((Patient
                                                                        patient) {
                                                                    String
                                                                        fullName =
                                                                        "${patient.user.firstname} ${patient.user.lastname}";
                                                                    String
                                                                        displayName;

                                                                    int maxDisplayNameLength =
                                                                        20;

                                                                    if (fullName
                                                                            .length >
                                                                        maxDisplayNameLength) {
                                                                      displayName =
                                                                          "${patient.user.firstname} ${patient.user.lastname[0]}.";
                                                                    } else {
                                                                      displayName =
                                                                          fullName;
                                                                    }
                                                                    return DropdownMenuItem<
                                                                        Patient>(
                                                                      value:
                                                                          patient,
                                                                      child:
                                                                          Row(
                                                                        children: <Widget>[
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            child:
                                                                                Image(
                                                                              image: NetworkImage(patient.photoUrl),
                                                                              width: 40,
                                                                              height: 40,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                              width: 10),
                                                                          Text(
                                                                              displayName),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  }).toList(),
                                                          ),
                                                        ),
                                                        SizedBox(height: 20),
                                                        RichText(
                                                          textAlign:
                                                              TextAlign.center,
                                                          text: TextSpan(
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    "Assignment date: ",
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    formattedDate,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: 20),
                                                        ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            primary:
                                                                selectedPatient !=
                                                                        null
                                                                    ? Color
                                                                        .fromARGB(
                                                                            255,
                                                                            74,
                                                                            194,
                                                                            100)
                                                                    : Colors
                                                                        .white,
                                                            onPrimary:
                                                                Colors.white,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        30,
                                                                    vertical:
                                                                        15),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              side: selectedPatient !=
                                                                      null
                                                                  ? BorderSide
                                                                      .none
                                                                  : BorderSide(
                                                                      color: AppConfig
                                                                          .primaryColor, // Color del borde
                                                                      width:
                                                                          0.5, // Ancho del borde
                                                                    ),
                                                            ),
                                                          ),
                                                          onPressed: () async {
                                                            if (selectedPatient !=
                                                                null) {
                                                              await _httpHelper?.assignIotDeviceAgain(
                                                                  widget
                                                                      .iotDevice
                                                                      .id,
                                                                  widget.id!,
                                                                  selectedPatient!
                                                                      .id);
                                                              String fullName =
                                                                  "${selectedPatient?.user.firstname} ${selectedPatient?.user.lastname}";
                                                              String
                                                                  displayNameConfirmation;

                                                              int maxDisplayNameLength =
                                                                  20;

                                                              if (fullName
                                                                      .length >
                                                                  maxDisplayNameLength) {
                                                                displayNameConfirmation =
                                                                    "${selectedPatient?.user.firstname} ${selectedPatient?.user.lastname[0]}.";
                                                              } else {
                                                                displayNameConfirmation =
                                                                    fullName;
                                                              }
                                                              showModalBottomSheet(
                                                                context:
                                                                    context,
                                                                isScrollControlled:
                                                                    true,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                builder:
                                                                    (BuildContext
                                                                        context2) {
                                                                  return ClipPath(
                                                                    clipper:
                                                                        TriangleClipper(),
                                                                    child:
                                                                        Container(
                                                                      height: MediaQuery.of(context2)
                                                                              .size
                                                                              .height *
                                                                          0.65, // Altura del 75% de la pantalla
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .green,
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Icon(
                                                                              Icons.check_circle_outline_rounded,
                                                                              color: Colors.white,
                                                                              size: 100,
                                                                            ),
                                                                            SizedBox(height: 20),
                                                                            Text(
                                                                              'IoT Device assigned successfully',
                                                                              style: TextStyle(
                                                                                fontSize: 24,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.white,
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 10),
                                                                            Text(
                                                                              'The device was assigned to ${displayNameConfirmation}',
                                                                              style: TextStyle(
                                                                                fontSize: 16,
                                                                                color: Colors.white,
                                                                              ),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ).whenComplete(
                                                                  () {
                                                                // Navigate to the new view when the modal is closed
                                                                WidgetsBinding
                                                                    .instance!
                                                                    .addPostFrameCallback(
                                                                        (_) {
                                                                  if (context !=
                                                                      null) {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              IotdevicesList()),
                                                                    );
                                                                  }
                                                                });
                                                              });
                                                            }
                                                          },
                                                          child: Center(
                                                            child: RichText(
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              text: TextSpan(
                                                                style:
                                                                    TextStyle(
                                                                  color: selectedPatient !=
                                                                          null
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .grey,
                                                                  fontSize: 14,
                                                                ),
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        "Assign New IoT Device",
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
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
                                      },
                                    );
                                  }
                                },
                                icon: widget.iotDevice.therapy?.id != 0 &&
                                        widget.iotDevice.therapy?.finished !=
                                            true
                                    ? Icon(
                                        Icons.lock_rounded,
                                        color: Colors
                                            .white, // Color del icono blanco
                                        size: 20, // Tamaño del icono
                                      )
                                    : Icon(
                                        Icons.check_circle_rounded,
                                        color: Colors
                                            .white, // Color del icono blanco
                                        size: 20, // Tamaño del icono
                                      ),
                                label: Text(
                                  deviceStatus,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ), // Color del texto
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -5, // Ajusta la posición vertical de la imagen
              left: 200, // Ajusta la posición horizontal de la imagen
              right: 0,
              child: Image.asset(
                'assets/iot.png', // Ruta del asset
                height: 120, // Altura de la imagen
                fit: BoxFit.contain, // Ajusta la imagen al contenedor
              ),
            ),
          ],
        ));
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double triangleHeight = 15.0;
    var path = Path();
    path.lineTo(0, triangleHeight);

    bool drawTriangle = true;
    double xPos = 0;

    while (xPos < size.width) {
      if (drawTriangle) {
        path.lineTo(xPos + triangleHeight, 0);
      } else {
        path.lineTo(xPos + triangleHeight, triangleHeight);
      }
      drawTriangle = !drawTriangle;
      xPos += triangleHeight;
    }

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
