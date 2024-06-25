import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math' as Math;
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app_theraphy/config/app_config.dart';
import 'package:mobile_app_theraphy/data/model/appointment.dart';
import 'package:mobile_app_theraphy/data/model/consultation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';

class LocationMap extends StatefulWidget {
  final Consultation? consultation;
  const LocationMap({Key? key, required this.consultation}) : super(key: key);

  @override
  _LocationMapState createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  //default
  static const LatLng sourceLocation =
      LatLng(-8.119252368132193, -79.0376629232878);
  static const destination = LatLng(-12.000556, -77.001615);
  late GoogleMapController mapController; // Agrega esta línea
  bool isMapAnimated = false;
  Completer<GoogleMapController> _controller = Completer();

  LatLng? myPosition;

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  void getGeo() async {
    Stream<Position> positionStream = Geolocator.getPositionStream();

    positionStream.listen((position) async {
      if (mounted) {
        setState(() {
          myPosition = LatLng(position.latitude, position.longitude);
          print(myPosition.toString());
          getPolyPoints();
        });
      }

      // No llames a getPolyPoints aquí para evitar duplicar la solicitud
      // Imprimir la ubicación
      print("Latitud: ${position.latitude}");
      print("Longitud: ${position.longitude}");
      animateMap(); // Agregar esta línea
    });

    // Llamada única para obtener la posición inicial
    Position initialPosition = await Geolocator.getCurrentPosition();
    if (mounted) {
      setState(() {
        myPosition =
            LatLng(initialPosition.latitude, initialPosition.longitude);
        getPolyPoints();
      });
    }
    print(myPosition.toString());
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
      if (mounted) {
        setState(() {
          polylineCoordinates.clear();
          result.points.forEach(
            (PointLatLng point) => polylineCoordinates.add(
              LatLng(point.latitude, point.longitude),
            ),
          );
        });
      }
    }
  }

  void animateMap() async {
    if (!isMapAnimated && myPosition != null) {
      final GoogleMapController controller = await _controller.future;

      // Configura los valores iniciales y finales para la animación
      final CameraPosition initialPosition = CameraPosition(
        target: myPosition!,
        zoom: 8.5,
        tilt: 0.0,
      );

      final CameraPosition finalPosition = CameraPosition(
        target: myPosition!,
        zoom: 13.5,
        tilt: 45.0,
      );

      // Número de pasos para la animación
      final int numberOfSteps = 500;

      // Duración total de la animación en milisegundos
      final int totalDuration = 3000; // 10 segundos

      // Intervalo de tiempo entre cada paso de la animación
      final int interval = totalDuration ~/ numberOfSteps;

      for (int i = 0; i <= numberOfSteps; i++) {
        final double t = i / numberOfSteps.toDouble();
        final CameraPosition intermediatePosition = CameraPosition(
          target: LatLng(
            ui.lerpDouble(initialPosition.target.latitude,
                finalPosition.target.latitude, t)!,
            ui.lerpDouble(initialPosition.target.longitude,
                finalPosition.target.longitude, t)!,
          ),
          zoom: ui.lerpDouble(initialPosition.zoom, finalPosition.zoom, t)!,
          tilt: ui.lerpDouble(initialPosition.tilt, finalPosition.tilt, t)!,
        );

        controller.animateCamera(
            CameraUpdate.newCameraPosition(intermediatePosition));

        // Espera el intervalo antes de realizar el siguiente paso
        await Future.delayed(Duration(milliseconds: interval));
      }
      if (mounted) {
        setState(() {
          isMapAnimated = true;
        });
      }
    }
  }

  String destinationAddress = "";
  late BitmapDescriptor customMarker;
  late BitmapDescriptor customMarker2;
  Future initialize() async {
    destinationAddress = await getAddressFromCoordinates(
      destination.latitude,
      destination.longitude,
    );
    customMarker = await _createCustomMarker(
        widget.consultation!.physiotherapist.photoUrl,
        Colors.green,
        10.0);
    customMarker2 = await _createCustomMarker(
        widget.consultation!.patient.photoUrl, Colors.blue, 10.0);

    getGeo();
    animateMap();
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double mapHeight = screenHeight * 0.7;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 65, // Ajusta la altura del AppBar

        title: Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 5),
          child: Text(
            "This is the way to ${widget.consultation!.patient.user.firstname[0]}. ${widget.consultation!.patient.user.lastname.split(" ")[0]}",
            style: TextStyle(
              color: AppConfig.primaryColor,
              fontSize: 18,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 20),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: AppConfig.primaryColor,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      body: myPosition == null
          ? const Center(
              child:
                  CircularProgressIndicator(), // Muestra un indicador de carga
            )
          : Column(
              children: [
                Container(
                  height: mapHeight,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppConfig.primaryColor, // Color del borde superior
                          Colors.transparent, // Color del contenido del mapa
                          Colors.transparent, // Color del contenido del mapa
                          AppConfig.primaryColor, // Color del borde inferior
                        ],
                        stops: [
                          0.0,
                          0.03,
                          0.97,
                          1.0
                        ], // Ajusta los valores según sea necesario
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: myPosition!,
                        zoom: 9.5,
                        tilt: 90.0,
                      ),
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
                          position: myPosition!,
                          icon: customMarker,
                        ),
                        Marker(
                          markerId: const MarkerId("destination"),
                          position: destination,
                          icon: customMarker2,
                        ),
                      },
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                    height:
                        10), // Espaciado entre el mapa y la información inferior
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppConfig.primaryColor,
                                ),
                                children: [
                                  const TextSpan(text: 'Destination: '),
                                  TextSpan(
                                    text: destinationAddress,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppConfig.primaryColor,
                                ),
                                children: [
                                  const TextSpan(text: 'Distance: '),
                                  TextSpan(
                                    text: '${calculateDistance()} Km',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.location_on,
                        size: 60, // Tamaño del icono
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    final apiKey =
        google_api_key; // Reemplaza con tu clave de API de Google Maps
    final apiUrl = 'https://maps.googleapis.com/maps/api/geocode/json';

    final response = await http.get(
      Uri.parse('$apiUrl?latlng=$latitude,$longitude&key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final results = data['results'] as List<dynamic>;

        if (results.isNotEmpty) {
          final address = results[0]['formatted_address'];
          return address;
        }
      }
    }

    return 'No se pudo obtener la dirección';
  }

  String calculateDistance() {
    // Puedes calcular la distancia entre myPosition y destination aquí
    // Utiliza la clase Geolocator para calcular la distancia entre dos puntos

    double distance = Geolocator.distanceBetween(
      myPosition!.latitude,
      myPosition!.longitude,
      destination.latitude,
      destination.longitude,
    );

    // Convierte la distancia de metros a kilómetros y redondea a dos decimales
    double distanceInKm = distance / 1000;
    return distanceInKm.toStringAsFixed(2);
  }

  Future<BitmapDescriptor> _createCustomMarker(
    String imageUrl,
    Color borderColor,
    double borderWidth,
  ) async {
    final Completer<BitmapDescriptor> completer = Completer();

    final ImageStream stream =
        NetworkImage(imageUrl).resolve(ImageConfiguration());
    final Uint8List byteData = await _getBytesFromStream(stream);

    final codec = await ui.instantiateImageCodec(byteData);
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ui.Image image = fi.image;

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    // Calcula las nuevas dimensiones para la imagen con el borde
    const double newWidth = 150;
    const double newHeight = 150;

    // Dibuja un círculo del color del borde detrás de la imagen
    final Paint borderPaint = Paint()..color = borderColor;
    canvas.drawCircle(
        const Offset(newWidth / 2, newHeight / 2), newWidth / 2, borderPaint);

    // Dibuja la imagen en el centro del círculo
    final double radius = Math.min(newWidth, newHeight) / 2 - borderWidth;
    final double scaleFactor =
        Math.min(newWidth / image.width, newHeight / image.height);
    final Paint ovalPaint = Paint()
      ..shader = ImageShader(
        image,
        TileMode.decal,
        TileMode.decal,
        Matrix4.identity().scaled(scaleFactor, scaleFactor).storage,
      );
    canvas.drawCircle(
      Offset(newWidth / 2, newHeight / 2),
      radius,
      ovalPaint,
    );

    // Finaliza el dibujo
    final ui.Picture picture = recorder.endRecording();
    final img = await picture.toImage(newWidth.toInt(), newHeight.toInt());
    final imgByteData = await img.toByteData(format: ui.ImageByteFormat.png);

    completer.complete(
      BitmapDescriptor.fromBytes(imgByteData!.buffer.asUint8List()),
    );
    return completer.future;
  }

  Future<Uint8List> _getBytesFromStream(ImageStream stream) async {
    Completer<Uint8List> completer = Completer();

    stream.addListener(
      ImageStreamListener(
        (ImageInfo info, bool synchronousCall) async {
          final ByteData? byteData =
              await info.image.toByteData(format: ui.ImageByteFormat.png);
          final Uint8List uint8List = byteData!.buffer.asUint8List();
          completer.complete(uint8List);
        },
        onError: (Object error, StackTrace? stackTrace) {
          completer.completeError(error);
        },
      ),
    );

    return completer.future;
  }
}
