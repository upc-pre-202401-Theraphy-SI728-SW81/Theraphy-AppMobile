import 'package:flutter/material.dart';
import 'package:mobile_app_theraphy/config/app_config.dart';
import 'package:mobile_app_theraphy/config/navBar.dart';
import 'package:mobile_app_theraphy/data/model/iot_device.dart';
import 'package:mobile_app_theraphy/data/model/patient.dart';
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

  int? id;
  bool _withTherapy = false;
  bool _onlyConsultation = false;

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
    myIotDevices = await _httpHelper?.getMyIotDevices(id!);

    //Update lists
    setState(() {
      id = id;
      myIotDevices = myIotDevices;
      filteredIotDevices = myIotDevices;
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
                                return PatientItem(
                                    iotDevice: filteredIotDevices![index]);
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
                // Acción al presionar el botón
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
  const PatientItem({super.key, required this.iotDevice});
  final IotDevice iotDevice;

  @override
  State<PatientItem> createState() => _PatientItemState();
}

class _PatientItemState extends State<PatientItem> {
  @override
  Widget build(BuildContext context) {
    String deviceStatus = "";

    if (widget.iotDevice.therapy?.id != 0 &&
        widget.iotDevice.therapy?.finished != true) {
      deviceStatus = "Assigned";
    } else {
      deviceStatus = "Available";
    }

    return FractionallySizedBox(
        widthFactor: 0.9,
        child: Card(
      color: Color.fromARGB(255, 255, 255, 255), // Establece el fondo blanco
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.drive_eta),
                    SizedBox(width: 8),
                    Text('0 min'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.directions_walk),
                    SizedBox(width: 8),
                    Text('5 min'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.battery_full),
                    SizedBox(width: 8),
                    Text('95%'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255,236, 239, 249), // Fondo blanco
                    onPrimary: Colors.black, // Color del texto
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Esquinas menos redondeadas
                    ),
                  ),
                  onPressed: () {},
                  icon: Icon(
                    Icons.play_circle,
                    color: AppConfig.primaryColor, // Color del icono
                  ),
                  label: Text(
                    'Play sound',
                    style: TextStyle(color: Colors.black, fontSize: 18), // Color del texto
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white, // Fondo blanco
                    onPrimary: Colors.black, // Color del texto
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Esquinas menos redondeadas
                    ),
                  ),
                  onPressed: () {},
                  icon: Icon(
                    Icons.send,
                    color: Theme.of(context).primaryColor, // Color del icono
                  ),
                  label: Text(
                    '326.31 m',
                    style: TextStyle(color: Colors.black), // Color del texto
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}

class StatusPill extends StatelessWidget {
  final String status;
  final bool isActive;

  StatusPill({required this.status, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          "Status: ",
          style: TextStyle(
            color: Color.fromARGB(255, 121, 121, 121),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? AppConfig.primaryColor : Colors.green,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class AirpodsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My AirPods',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.drive_eta),
                    SizedBox(width: 8),
                    Text('0 min'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.directions_walk),
                    SizedBox(width: 8),
                    Text('5 min'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.battery_full),
                    SizedBox(width: 8),
                    Text('95%'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.play_circle),
                  label: Text('Play sound'),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.send),
                  label: Text('326.31 m'),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Image of AirPods
            Image(
              image: NetworkImage(
                  "https://icon-library.com/images/internet-of-things-icon/internet-of-things-icon-9.jpg"),
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
