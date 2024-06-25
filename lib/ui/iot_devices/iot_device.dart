import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math' as Math;
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_theraphy/config/app_config.dart';
import 'package:mobile_app_theraphy/data/model/appointment.dart';
import 'package:mobile_app_theraphy/data/model/iot_device.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';

class MapView extends StatefulWidget {
  final IotDevice iotDevice;
  const MapView({Key? key, required this.iotDevice}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  //default
  static const LatLng sourceLocation =
      LatLng(-8.119252368132193, -79.0376629232878);
  static const destination = LatLng(-12.1081725, -76.9680419);
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
        widget.iotDevice!.therapy!.physiotherapist.photoUrl,
        Colors.green,
        10.0);
    customMarker2 = await _createCustomMarker(
        "https://images.samsung.com/is/image/samsung/es-galaxy-fite-sm-r375nzkaphe-frontblack-thumb-167568895",
        Colors.blue,
        10.0);

    getGeo();
    animateMap();
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double mapHeight = screenHeight * 0.7;
    String displayName;
    String fullName =
        "${widget.iotDevice?.therapy?.patient.user.firstname} ${widget.iotDevice?.therapy?.patient.user.lastname}";

    int maxDisplayNameLength = 20;

    if (fullName.length > maxDisplayNameLength) {
      displayName =
          "${widget.iotDevice?.therapy?.patient.user.firstname} ${widget.iotDevice?.therapy?.patient.user.lastname[0]}.";
    } else {
      displayName = fullName;
    }

    String formattedDate = '';
    String formattedDateTherapyEnded = '';

    try {
      DateTime parsedDate =
          DateFormat('yyyy-MM-dd').parse(widget.iotDevice.assignmentDate);
      formattedDate = DateFormat('MMMM dd, yyyy').format(parsedDate);
      DateTime parsedDateTherapy =
          DateFormat('yyyy-MM-dd').parse(widget.iotDevice.therapy.finishAt.substring(0, 10));
      formattedDateTherapyEnded = DateFormat('MMMM dd, yyyy').format(parsedDateTherapy);

    } catch (e) {
      print('Error parsing date: $e');
    }
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          myPosition == null
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
                              AppConfig
                                  .primaryColor, // Color del borde superior
                              Colors
                                  .transparent, // Color del contenido del mapa
                              Colors
                                  .transparent, // Color del contenido del mapa
                              AppConfig
                                  .primaryColor, // Color del borde inferior
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
                          padding: EdgeInsets.only(top: 80),
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
                            19), // Espaciado entre el mapa y la información inferior
                  ],
                ),
          Positioned(
            top: 50, // Ajusta la posición vertical del botón
            left: 14, // Ajusta la posición horizontal del botón
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, size: 32, color: Colors.black),
              color: AppConfig.primaryColor,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          myPosition != null
              ? Positioned(
                  bottom: 0, // Ajusta la posición vertical del botón
                  left: 0, // Ajusta la posición horizontal del botón
                  right: 0, // Ajusta la posición horizontal del botón
                  child: Container(
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
                              Icon(Icons.people, size: 28), // Icono más grande
                              SizedBox(height: 4),
                              Text(
                                '${widget.iotDevice?.therapyQuantity} uses',
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
                                '${(100 - (widget.iotDevice!.therapyQuantity! / 10) * 100).toStringAsFixed(0)}%',
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
                                widget.iotDevice?.therapy?.id != 0 &&
                                        widget.iotDevice?.therapy?.finished !=
                                            true
                                    ? "Assign to"
                                    : "Was assigned to",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 1),
                              Text(
                                displayName,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Was assigned on ",
                                    ),
                                    TextSpan(
                                      text: formattedDate,
                                      style: TextStyle(
                                        fontSize:
                                            15, // Tamaño de fuente más grande para el valor dinámico
                                        fontWeight: FontWeight
                                            .bold, // Opcional, si deseas que sea negrita
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    widget.iotDevice?.therapy?.id != 0 &&
                                            widget.iotDevice?.therapy
                                                    ?.finished !=
                                                true
                                        ? TextSpan()
                                        : TextSpan(
                                            children: [
                                              WidgetSpan(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 4.0, top: 10),
                                                  child: Icon(
                                                    Icons.info_outline,
                                                    color: Colors.blue,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    "The therapy ended on ${formattedDateTherapyEnded}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 24),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: widget.iotDevice?.therapy?.id != 0
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
                                onPressed: () {},
                                child: Center(
                                  child: RichText(
                                    textAlign:
                                        TextAlign.center, // Centra el texto
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "Located in ",
                                        ),
                                        TextSpan(
                                          text: destinationAddress,
                                          style: TextStyle(
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
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox(),
        ]));
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
