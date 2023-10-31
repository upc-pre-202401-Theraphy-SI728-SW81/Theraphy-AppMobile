import 'package:flutter/material.dart';
import 'package:mobile_app_theraphy/data/model/available_hour.dart';
import 'package:mobile_app_theraphy/data/model/physiotherapist.dart';
import 'package:mobile_app_theraphy/data/remote/http_helper.dart';
import 'package:mobile_app_theraphy/data/remote/services/availableHour/available_hour_service.dart';
import 'package:mobile_app_theraphy/data/remote/services/physiotherapist/physiotherapist_service.dart';
import 'package:mobile_app_theraphy/ui/profile/available_hour.dart';
import 'package:mobile_app_theraphy/ui/profile/edit_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AvailableHourService? _availableHourService;
  List<AvailableHour>? _availableHours;
  PhysiotherapistService? _physiotherapistService;
  Physiotherapist? _physiotherapist;
  HttpHelper? _httpHelper;

  Future initialize() async {
    _availableHours = List.empty();
    _availableHours = await _availableHourService?.getAll();
    int? id = await _httpHelper?.getPhysiotherapistLogged();
    _physiotherapist = await _physiotherapistService?.getPhysiotherapistById(id!);
    setState(() {
      _availableHours = _availableHours;
    });
  }

  @override
  void initState() {
    _availableHourService = AvailableHourService();
    _physiotherapistService = PhysiotherapistService();
    _httpHelper = HttpHelper();
    initialize();
    super.initState();
  }

  bool isButtonEnabled = true;
  final TextEditingController dayController = TextEditingController();
  final TextEditingController hourController = TextEditingController();
  int maxElementCount = 6;
  //isButtonEnabled = (_availableHours?.length ?? 0) < maxElementCount;

  @override
  Widget build(BuildContext context) {
    isButtonEnabled = (_availableHours?.length ?? 0) < maxElementCount;
    return WillPopScope(
      onWillPop: () async {
        return false; //no estoy seguro si poner eso ..pongo eso y pongo un boton para retroceder a la pagina anterior o de inicio
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Fisioterapeuta Profile"),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const CircleAvatar(
                    radius: 60, // Tamaño del avatar
                    backgroundImage: NetworkImage(
                        "https://superdoc.mx/wp-content/uploads/2023/05/doctora-1.png"),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _physiotherapist?.user.firstName ?? "",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _physiotherapist?.user.role ?? "",
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    _physiotherapist?.specialization ?? "",
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    _physiotherapist?.user.username ?? "",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Your available schedules: ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  // Coloca la lista dentro de un SingleChildScrollView
                  Visibility(
                    visible: _availableHours?.isNotEmpty ==
                        true, // Muestra solo si hay datos
                    child: SizedBox(
                      height:
                          190, // Establece una altura fija o usa otro valor adecuado
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Ancho máximo de los elementos
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          mainAxisExtent: 55,
                        ),
                        itemCount: _availableHours?.length ?? 0,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              dayController.text =
                                  _availableHours?[index].day ?? '';
                              hourController.text =
                                  _availableHours?[index].hours ?? '';
                              print("Hola perro");
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Edit availability"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          controller: dayController,
                                          decoration: const InputDecoration(
                                              labelText: "Día"),
                                        ),
                                        TextFormField(
                                          controller: hourController,
                                          decoration: const InputDecoration(
                                              labelText: "Hora"),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Cierra el diálogo
                                        },
                                        child: const Text("Cancelar"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Envía un PUT request con los nuevos valores
                                          final String updatedDay =
                                              dayController.text;
                                          final String updatedHour =
                                              hourController.text;
                                          // Realiza la lógica para enviar la solicitud PUT
                                          // Puedes llamar a una función que maneje la solicitud PUT
                                          // y actualice el valor en la lista _availableHours.
                                          _availableHourService
                                              ?.updateAvailableHour(
                                                  _availableHours![index].id,
                                                  updatedDay,
                                                  updatedHour)
                                              .then((value) => initialize());
                                          Navigator.of(context)
                                              .pop(); // Cierra el diálogo
                                        },
                                        child: const Text("Guardar"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Card(
                              elevation: 2,
                              color: const Color.fromARGB(255, 27, 139, 214),
                              shape: RoundedRectangleBorder(
                                  side: BorderSide.none,
                                  borderRadius: BorderRadius.circular(
                                      BouncingScrollSimulation
                                          .maxSpringTransferVelocity)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      "${_availableHours?[index].day}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      "${_availableHours?[index].hours}",
                                      style: const TextStyle(
                                          fontSize:
                                              14), // Reduce el tamaño de fuente
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Agrega la lógica para editar el perfil del fisioterapeuta.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditProfilePage()),
                      );
                    },
                    child: const Text("Editar Perfil"),
                  ),
                  ElevatedButton(
                    onPressed: isButtonEnabled
                        ? () {
                            // Agrega la lógica para editar el perfil del fisioterapeuta.
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AvailabilityPage(),
                              ),
                            ).then((value) => initialize());
                          }
                        : null,
                    child: const Text("Ingresa tus horarios"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
