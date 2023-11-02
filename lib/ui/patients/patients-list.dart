import 'package:flutter/material.dart';
import 'package:mobile_app_theraphy/data/model/consultation.dart';
import 'package:mobile_app_theraphy/data/model/patient.dart';
import 'package:mobile_app_theraphy/data/model/physiotherapist.dart';
import 'package:mobile_app_theraphy/data/remote/http_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  List<Widget> pages = const [
    //HomePhysiotherapist(),
    PatientsList(),
    //ListAppointments(),
    //ListTreatments(),
    //PhysiotherapistProfile(),
  ];

  Future initialize() async {
    //Get user logged
    int? id = await _httpHelper?.getPhysiotherapistLogged();

    // Get Lists
    // ignore: sdk_version_since
    myPatients = List.empty();
    myPatients = await _httpHelper?.getMyPatients(id!);

    //Update lists
    setState(() {
      myPatients = myPatients;
      filteredPatients = myPatients;
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
        title: const Padding(
          padding: EdgeInsets.only(
              top: 20), // Ajusta la cantidad de espacio según tus necesidades
          child: Text(
            "My Patients",
            style: TextStyle(
              color: Color.fromRGBO(1, 77, 191, 1),
              fontSize: 24,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(22.0),
            // ignore: sized_box_for_whitespace
            child: Container(
              width: 360, // Establece el ancho deseado
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    filteredPatients = myPatients
                        ?.where((patient) =>
                            ('${patient.user.firstname} ${patient.user.lastname}')
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                        .toList();
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color.fromRGBO(1, 77, 191, 1),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(1, 77, 191, 1)),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromRGBO(1, 77, 191, 1), width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  labelStyle: TextStyle(
                    color: Color.fromRGBO(
                        1, 77, 191, 1), // Color azul para el labelText
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPatients?.length,
              itemBuilder: (context, index) {
                return PatientItem(patient: filteredPatients![index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(10.0),
          ),
          border: Border.all(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(10.0),
          ),
          child: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (int index) {
              setState(() {
                selectedIndex = index;
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => pages[index]),
              );
            },
            unselectedItemColor: const Color.fromARGB(255, 104, 104, 104),
            selectedItemColor: Colors.black,
            items: [
              BottomNavigationBarItem(
                icon: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: const Icon(Icons.home),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: const Icon(Icons.people),
                ),
                label: 'Patients',
              ),
              BottomNavigationBarItem(
                icon: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: const Icon(Icons.calendar_month),
                ),
                label: 'Appointments',
              ),
              BottomNavigationBarItem(
                icon: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: const Icon(Icons.video_collection),
                ),
                label: 'Treatments',
              ),
              BottomNavigationBarItem(
                icon: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: const Icon(Icons.person),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
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
                      "${widget.patient.user.firstname} ${widget.patient.user.lastname}",
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
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(1, 77, 191, 1),
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
