import 'package:flutter/material.dart';
import 'package:mobile_app_theraphy/config/app_config.dart';
import 'package:mobile_app_theraphy/data/model/patient.dart';
import 'package:mobile_app_theraphy/data/remote/http_helper.dart';

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

  late FocusNode _focusNode;

  @override
  void initState() {
    _httpHelper = HttpHelper();
    super.initState();

    _focusNode = FocusNode();
  }

  final TextEditingController _sizecontroller = TextEditingController();

  TextEditingController _weightcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          titleSpacing: -10,
          title: Padding(
            padding: EdgeInsets.only(top: 20),
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
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                          "${widget.patient.user.firstname} ${widget.patient.user.lastname}",
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
                    left: 10.0, right: 10), // Añade el padding a la izquierda
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
                                selectedGender = isMaleSelected ? "Male" : null;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isMaleSelected
                                    ? Colors.white
                                    : const Color.fromARGB(255, 238, 238, 238),
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
                                              isMaleSelected ? "Male" : null;
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
                                    isFemaleSelected ? "Female" : null;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isFemaleSelected
                                    ? Colors.white
                                    : const Color.fromARGB(255, 238, 238, 238),
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
                                              : null;
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
                            Text(
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
                                    120, // Ajusta el valor según sea necesario
                                child: TextField(
                                  cursorColor: AppConfig.primaryColor,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                        color: Colors
                                            .grey, // Color del borde cuando no está enfocado
                                        width: 2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
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
                            TextField(
                              cursorColor: AppConfig.primaryColor,
                              obscureText: true,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 1.0),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Colors
                                        .grey, // Color del borde cuando no está enfocado
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: AppConfig
                                        .primaryColor, // Color del borde cuando está enfocado
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ])));
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
