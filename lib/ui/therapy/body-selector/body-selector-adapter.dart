import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_app_theraphy/config/app_config.dart';
import 'package:mobile_app_theraphy/ui/therapy/body-selector/src/body_part_selector_turnable.dart';
import 'package:mobile_app_theraphy/ui/therapy/body-selector/src/model/body_parts.dart';
import 'package:mobile_app_theraphy/ui/therapy/new-video.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BodySelectorAdapter extends StatefulWidget {
  final int initialIndex;
  final int patientId;

  const BodySelectorAdapter({Key? key, required this.initialIndex, required this.patientId}) : super(key: key);

  @override
  State<BodySelectorAdapter> createState() => _BodySelectorAdapterState();
}

class _BodySelectorAdapterState extends State<BodySelectorAdapter> {
  BodyParts _bodyParts = const BodyParts();
  
  void _saveSelectedParts(List<String> selectedParts) async {
  // Obtén una instancia de SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // Elimina las partes seleccionadas antiguas
    prefs.remove('selectedParts');

  // Guarda la lista de partes seleccionadas como una cadena JSON
  String partsJson = jsonEncode(selectedParts);
  prefs.setString('selectedParts', partsJson);

  // Puedes agregar más lógica aquí según tus necesidades
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
        titleSpacing: -10,
        title: Padding(
          padding: const EdgeInsets.only(top: 20,),
          child: Text(
            "Select Body Parts",
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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Cambiado a start
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 20),
                  child: Text(
                    'Select the parts of the body on which the user should put the IoTheraphy Band.',
                    style: TextStyle(fontSize: 17.0),
                  ),
                ),
                // Tu BodyPartSelectorTurnable existente
                BodyPartSelectorTurnable(
                  bodyParts: _bodyParts,
                  onSelectionUpdated: (p) {
                    setState(() {
                      _bodyParts = p;
                    });
                  },
                  labelData: const RotationStageLabelData(
                    front: 'Front',
                    left: 'Left',
                    right: 'Right',
                    back: 'Back',
                  ),
                ),

                // Mostrar las partes seleccionadas debajo de la cinta de rotación
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: DataTable(
                    columns: const [
                      DataColumn(
                        label: Padding(
                          padding: EdgeInsets.only(left: 80.0),
                          child: Text(
                            'Selected Body Parts',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                    rows: _bodyParts.selectedParts
                        .map(
                          (part) => DataRow(
                            cells: [
                              DataCell(Text(part)),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 130.0, bottom: 20),
                  child: ElevatedButton(
                    onPressed: () {
          
                      _saveSelectedParts(_bodyParts.selectedParts);
                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NewVideo(
                                          initialIndex: widget.initialIndex,
                                          patientId: widget.patientId,
                                        ),
                                      ));
                      // Lógica para confirmar la selección
                      // Puedes agregar aquí la lógica que necesites al confirmar la selección
                      // por ejemplo, navegar a otra pantalla o realizar alguna acción específica.
                    },
                    child: const Text('Confirm Selection'),
                  ),
                ),
                // Botón de confirmación
              ],
            ),
          ),
        ));
  }
}
