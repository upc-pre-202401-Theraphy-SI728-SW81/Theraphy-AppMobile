import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_app_theraphy/config/app_config.dart';
import 'package:mobile_app_theraphy/config/navBar.dart';
import 'package:mobile_app_theraphy/data/model/available_hour.dart';
import 'package:mobile_app_theraphy/data/model/physiotherapist.dart';
import 'package:mobile_app_theraphy/data/model/review.dart';
import 'package:mobile_app_theraphy/data/remote/http_helper.dart';
import 'package:mobile_app_theraphy/data/remote/services/availableHour/available_hour_service.dart';
import 'package:mobile_app_theraphy/data/remote/services/physiotherapist/physiotherapist_service.dart';
import 'package:mobile_app_theraphy/ui/patients/patients-list.dart';
import 'package:mobile_app_theraphy/ui/profile/available_hour.dart';
import 'package:mobile_app_theraphy/ui/profile/edit_profile.dart';
import 'package:mobile_app_theraphy/ui/security/login-in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedIndex = 4;
  int _selectedIndexSchedule = -1;
  AvailableHourService? _availableHourService;
  List<AvailableHour>? _availableHours;
  PhysiotherapistService? _physiotherapistService;
  Physiotherapist? _physiotherapist;
  HttpHelper? _httpHelper;
  int? id;
  late List<DateTime> _weekDates;
  List<Review>? myReviews = [];
  int numberOfReviews = 0;

  List<Widget> pages = const [
    PatientsList(),
    ProfilePage(),
    ProfilePage(),
    ProfilePage(),
    ProfilePage(),
  ];

  Future initialize() async {
    _availableHours = List.empty();
    id = await _httpHelper?.getPhysiotherapistLogged();
    _availableHours = await _availableHourService?.getByPhysiotherapistId(id!);

    _physiotherapist = await _httpHelper?.getPhysiotherapist();

    id = await _httpHelper?.getPhysiotherapistLogged();

    // Get Lists
    // ignore: sdk_version_since
    myReviews = List.empty();
    myReviews = await _httpHelper?.getMyReviews(id!) ?? [];

    setState(() {
      myReviews = myReviews;
      numberOfReviews = myReviews!.length;
      _availableHours = _availableHours;
    });
  }

  @override
  void initState() {
    _availableHourService = AvailableHourService();
    _physiotherapistService = PhysiotherapistService();
    _httpHelper = HttpHelper();
    _initializeWeekDates();
    initialize();
    super.initState();
  }

  void _initializeWeekDates() {
    DateTime now =
        DateTime.now().toUtc(); // Obtener la fecha y hora actual en UTC
    // Convertir la fecha y hora actual a la zona horaria de Perú
    DateTime nowPeru = now.add(
        Duration(hours: -5)); // Ajuste según el huso horario de Perú (UTC-5)

    // Obtener la fecha del lunes de esta semana
    DateTime monday = nowPeru.subtract(Duration(days: nowPeru.weekday - 1));

    // Generar la lista de fechas de la semana
    _weekDates = List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  bool isButtonEnabled = true;
  final TextEditingController dayController = TextEditingController();
  final TextEditingController hourController = TextEditingController();
  int maxElementCount = 6;

  // List<Color> cardColors = [
  //   Colors.blue,
  //   Colors.green,
  //   Colors.orange,
  //   Colors.purple,
  //   Colors.red,
  //   Colors.teal,
  // ];

  List<Color> cardColors = [
    const Color(0xFFB1D7F3), // Celeste
    const Color(0xFFC7B6E4), // Rosado
  ];

  bool isValidHourFormat(String hour) {
    // Verificar si la hora tiene uno de los formatos válidos usando una expresión regular
    RegExp regex = RegExp(
        r'^\d{1,2}:\d{2}-\d{1,2}:\d{2}$|^\d{1,2}:\d{2}\s*-\s*\d{1,2}:\d{2}$');
    return regex.hasMatch(hour);
  }

  @override
  Widget build(BuildContext context) {
    isButtonEnabled = (_availableHours?.length ?? 0) < maxElementCount;

    String formatDay(int day) {
      return day < 10 ? '0$day' : '$day';
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                "My Profile",
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
          body: SingleChildScrollView(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context)
                              .size
                              .width, // Ocupa todo el ancho de la pantalla
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                // Centro el contenedor interno
                                child: Container(
                                  width: 140, // Tamaño reducido para la imagen
                                  height: 110, // Tamaño reducido para la imagen
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color.fromARGB(255, 101, 101, 101)
                                                .withOpacity(0.5),
                                        spreadRadius: 0.1,
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 58,
                                    backgroundImage: NetworkImage(
                                        _physiotherapist?.photoUrl ?? ""),
                                    backgroundColor: Colors.white,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 5,
                                        ),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              _createRoute(
                                                  _physiotherapist?.photoUrl ??
                                                      ""));
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Más widgets aquí si es necesario
                            ],
                          ),
                        ),
                        Positioned(
                          top: -15,
                          right: 0,
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.black),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const EditProfilePage()),
                                  ); // Acción al presionar el primer icono
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.logout, color: Colors.black),
                                onPressed: () async {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) {
                                      return Center(
                                        child: Container(
                                          padding: EdgeInsets.all(20),
                                          height: 340,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 6),
                                              Container(
                                                padding: EdgeInsets.all(
                                                    20), // Increase padding to make the circle larger
                                                decoration: BoxDecoration(
                                                  color: Color(
                                                      0xFFD0EAFD), // Celeste color
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.exit_to_app,
                                                  size: 40,
                                                  color: AppConfig.primaryColor,
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              Text(
                                                'Already leaving?',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: Text(
                                                  'Your patients and their therapies will be waiting for you. We will miss your invaluable work...',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              SizedBox(height: 18),
                                              SizedBox(
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    final prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    // Eliminar el token de acceso
                                                    prefs.remove('accessToken');
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const Login()),
                                                    );
                                                  },
                                                  child: Text(
                                                    'Yes, Log out',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Color.fromARGB(
                                                        255, 226, 68, 68),
                                                    onPrimary: Colors.white,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 12),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 11),
                                              SizedBox(
                                                width: double.infinity,
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "No, I'm staying",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: AppConfig
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    side: BorderSide(
                                                      color: AppConfig
                                                          .primaryColor,
                                                      width: 2,
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 12),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "Dr. ${_physiotherapist?.user.firstname} ${_physiotherapist?.user.lastname}" ??
                                    "",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "\n${_physiotherapist?.user.username}" ?? "",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${_physiotherapist?.specialization ?? ""} Specialist",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildIconWithText(
                            icon: Icons.people,
                            text1: "Patients",
                            text2:
                                _physiotherapist?.patientQuantity?.toString() ??
                                    "",
                          ),
                          const SizedBox(width: 20),
                          _buildIconWithText(
                            icon: Icons.work,
                            text1: "Years Exp.",
                            text2:
                                _physiotherapist?.yearsExperience?.toString() ??
                                    "",
                          ),
                          const SizedBox(width: 20),
                          _buildIconWithText(
                            icon: Icons.star,
                            text1: "Rating",
                            text2:
                                _physiotherapist?.rating?.toStringAsFixed(2) ??
                                    "",
                          ),
                          const SizedBox(width: 20),
                          _buildIconWithText(
                            icon: Icons.message,
                            text1: "Reviews",
                            text2: myReviews?.length.toString() ?? "",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: AppConfig.primaryColor, // Color primario
                        borderRadius:
                            BorderRadius.circular(12), // Bordes redondeados
                      ),
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Fee per Consultation',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors
                                      .white, // Ajuste de color para el texto
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.white),
                                iconSize: 18,
                                onPressed: () {
                                  // Acción del botón de editar
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Center(
                            child: Text(
                              'S/. ${_physiotherapist?.fees?.toString()}' ?? "",
                              style: TextStyle(
                                fontSize: 28,
                                color: Colors
                                    .white, // Ajuste de color para el texto grande
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Working Hours",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "These are your work hours for this week",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w100,
                              color: Colors.black,
                            ),
                          ),
                          // Agrega más widgets hijos aquí si es necesario
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                buildDayButton(
                                    'Mon', formatDay(_weekDates[0].day),
                                    isSelected: _selectedIndexSchedule == 0,
                                    index: 0),
                                buildDayButton(
                                    'Tue', formatDay(_weekDates[1].day),
                                    isSelected: _selectedIndexSchedule == 1,
                                    index: 1),
                                buildDayButton(
                                    'Wed', formatDay(_weekDates[2].day),
                                    isSelected: _selectedIndexSchedule == 2,
                                    index: 2),
                                buildDayButton(
                                    'Thu', formatDay(_weekDates[3].day),
                                    isSelected: _selectedIndexSchedule == 3,
                                    index: 3),
                                buildDayButton(
                                    'Fri', formatDay(_weekDates[4].day),
                                    isSelected: _selectedIndexSchedule == 4,
                                    index: 4),
                                buildDayButton(
                                    'Sat', formatDay(_weekDates[5].day),
                                    isSelected: _selectedIndexSchedule == 5,
                                    index: 5),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Reviews",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "This is what your patients say about your work",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w100,
                              color: Colors.black,
                            ),
                          ),
                          // Agrega más widgets hijos aquí si es necesario
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 250,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        initialPage: 0,
                      ),
                      items: List.generate(numberOfReviews, (index) {
                        String fullName =
                            "${myReviews![index].patient.user.firstname} ${myReviews![index].patient.user.lastname}";
                        String displayName;

                        int maxDisplayNameLength = 20;

                        if (fullName.length > maxDisplayNameLength) {
                          displayName =
                              "${myReviews![index].patient.user.firstname} ${myReviews![index].patient.user.lastname[0]}.";
                        } else {
                          displayName = fullName;
                        }

                        return Card(
                          color: AppConfig.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundImage: NetworkImage(
                                              myReviews![index]
                                                  .patient
                                                  .photoUrl),
                                          backgroundColor: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          displayName,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.star,
                                            color: Colors.white, size: 20),
                                        SizedBox(width: 4),
                                        Text(
                                          myReviews![index].score.toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Divider(color: Colors.white),
                                SizedBox(height: 8),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      myReviews![index].content,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: NavBar(currentIndex: 2)),
    );
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

  Widget _buildIconWithText({
    required IconData icon,
    required String text1,
    required String text2,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.blue, // Color primario como color del borde
              width: 2, // Ancho del borde
            ),
          ),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(
              icon,
              size: 30,
              color: Colors.blue, // Color primario como color del icono
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          text1,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        Text(
          text2,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget buildDayButton(String day, String date,
      {bool isSelected = false, int index = -1}) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color.fromRGBO(255, 255, 255, 1),
          onPrimary: Colors.white,
          padding: EdgeInsets.zero,
          minimumSize: Size(20, 20),
        ),
        onPressed: () {
          setState(() {
            _selectedIndexSchedule =
                _selectedIndexSchedule == index ? -1 : index;
          });
        },
        child: Container(
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppConfig.primaryColor,
            ),
            borderRadius: BorderRadius.circular(10.0),
            color: isSelected ? AppConfig.primaryColor : Colors.white,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset:
                          Offset(0, 3), // cambios en la posición de la sombra
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                day,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  color: isSelected
                      ? Colors.white
                      : Color.fromARGB(255, 124, 124, 124),
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                date,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ));
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
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
