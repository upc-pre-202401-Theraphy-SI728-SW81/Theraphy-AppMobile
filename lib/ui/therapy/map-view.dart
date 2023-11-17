import 'package:flutter/material.dart';
import 'package:mobile_app_theraphy/config/app_config.dart';
import 'package:mobile_app_theraphy/data/model/appointment.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';

class CitizenMap extends StatefulWidget {
  final Appointment? appointment;
  const CitizenMap({Key? key, required this.appointment}) : super(key: key);

  @override
  _CitizenMapState createState() => _CitizenMapState();
}

class _CitizenMapState extends State<CitizenMap> {
  //default
  static const LatLng sourceLocation =
      LatLng(-8.119252368132193, -79.0376629232878);
  static const destination = LatLng(-12.000556, -77.001615);

  LatLng? myPosition;

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  void getGeo() async {
    Stream<Position> positionStream = Geolocator.getPositionStream();
    // Escuchar el flujo de posiciones
    positionStream.listen((position) async {
      myPosition = LatLng(position.latitude, position.longitude);
      print(myPosition.toString());
      // No llames a getPolyPoints aquí para evitar duplicar la solicitud
      // Imprimir la ubicación
      print("Latitud: ${position.latitude}");
      print("Longitud: ${position.longitude}");
    });

    // Llamada única para obtener la posición inicial
    Position initialPosition = await Geolocator.getCurrentPosition();
    myPosition = LatLng(initialPosition.latitude, initialPosition.longitude);
    print(myPosition.toString());
    getPolyPoints();
    // Imprimir la ubicación inicial
    print("Latitud inicial: ${initialPosition.latitude}");
    print("Longitud inicial: ${initialPosition.longitude}");
  }

  void getPolyPoints() async {
    PolylinePoints polyLinePoints = PolylinePoints();
    PolylineResult result = await polyLinePoints.getRouteBetweenCoordinates(
        google_api_key,
        PointLatLng(myPosition!.latitude, myPosition!.longitude),
        PointLatLng(destination.latitude, destination.longitude));

    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  Future initialize() async {
    getGeo();
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double mapHeight = screenHeight * 0.6;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppConfig.primaryColor),
            onPressed: () {
              // Acción al presionar el botón de retroceso -12.10474721778145, -76.95317763648323
              Navigator.of(context).pop();
            },
          ),
          title: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Way to ${widget.appointment!.therapy.patient.user.firstname}",
              style: TextStyle(color: AppConfig.primaryColor),
            ),
          ),
        ),
        body: Column(children: [
          Container(
            height: mapHeight,
            child: myPosition == null
                ? const Center(
                    child:
                        CircularProgressIndicator(), // Muestra un indicador de carga
                  )
                : GoogleMap(
                    initialCameraPosition:
                        CameraPosition(target: myPosition!, zoom: 5.5),
                    polylines: {
                      Polyline(
                        polylineId: PolylineId("route"),
                        points: polylineCoordinates,
                        color: AppConfig.primaryColor,
                        width: 6,
                      ),
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId("currentLocation"),
                        //icon: sourceIcon,
                        position: myPosition!,
                      ),
                      const Marker(
                        markerId: MarkerId("destination"),
                        position: destination,
                      ),
                    },
                  ),
          ),
        ]));
  }
}
