import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app_theraphy/data/model/physiotherapist.dart';
import 'package:mobile_app_theraphy/data/remote/http_helper.dart';
import 'package:mobile_app_theraphy/data/remote/services/physiotherapist/physiotherapist_service.dart';
import 'package:mobile_app_theraphy/data/remote/upload_Into_Firebase.dart';
import 'package:mobile_app_theraphy/ui/profile/physiotherapist_profile.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  PhysiotherapistService? _physiotherapistService;
  Physiotherapist? _physiotherapist;
  HttpHelper? _httpHelper;
  int? id;

  Future initialize() async {
    id = await _httpHelper?.getPhysiotherapistLogged();
    _physiotherapist =
        await _physiotherapistService?.getPhysiotherapistById(id!);
    setState(() {
      _physiotherapist = _physiotherapist;
    });
  }

  @override
  void initState() {
    _physiotherapistService = PhysiotherapistService();
    _httpHelper = HttpHelper();
    initialize();
    super.initState();
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController specializationController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60, // Tamaño del avatar
                  backgroundImage:
                      NetworkImage(_physiotherapist?.photoUrl ?? ""),
                  backgroundColor: Colors.transparent,
                  // Agrega un contorno al avatar
                  foregroundColor: Colors.white,
                  // Ajusta el grosor y el color del contorno según tus preferencias
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black, // Color del contorno
                        width: 2.5, // Grosor del contorno
                      ),
                    ),
                    child: InkWell(
                      onTap: () async {
                        ImagePicker picker = ImagePicker();
                        PickedFile? pickedFile =
                            // ignore: deprecated_member_use
                            await picker.getImage(source: ImageSource.gallery);

                        if (pickedFile != null) {
                          File image = File(pickedFile.path);

                          String? imageUrl = await uploadImage(image);

                          if (imageUrl != null) {
                            // Haz algo con la URL de la imagen cargada
                            _physiotherapistService
                                ?.patchImageUrlToPhysiotherapist(id!, imageUrl);
                            print('URL de la imagen cargada: $imageUrl');
                          } else {
                            // Manejar el caso en que la carga de la imagen falle
                            print('Error al cargar la imagen');
                          }
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildTextField(nameController, 'Name'),
                const SizedBox(height: 16.0),
                _buildTextField(specializationController, 'Specialization'),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    String newFirstName = nameController.text.isNotEmpty
                        ? nameController.text
                        : _physiotherapist!.user.firstname;
                    String newSpecialization =
                        specializationController.text.isNotEmpty
                            ? specializationController.text
                            : _physiotherapist!.specialization;

                    _physiotherapist!.user.firstname = newFirstName;
                    _physiotherapist!.specialization = newSpecialization;

                    // Realiza el PATCH y espera la respuesta
                    bool? success =
                        await _physiotherapistService?.patchPhysiotherapist(
                      id!,
                      _physiotherapist!,
                    );

                    if (success == true) {
                      // Muestra un Toast con el mensaje de éxito
                      Fluttertoast.showToast(
                        msg: 'Updated data successfully',
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                      );

                      // Actualiza la interfaz gráfica después de un tiempo (opcional)
                      await Future.delayed(const Duration(seconds: 1));

                      // Navega de regreso a la página de perfil
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      ).then((value) => initialize());
                    } else {
                      // Muestra un Toast con un mensaje de error (si lo deseas)
                      Fluttertoast.showToast(
                        msg: 'There was an error when updating the data',
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                    }
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      ),
    );
  }
}
