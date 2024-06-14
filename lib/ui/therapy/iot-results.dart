import 'package:flutter/material.dart';
import 'package:mobile_app_theraphy/config/app_config.dart';
import 'package:mobile_app_theraphy/data/model/iot_Result.dart';
import 'package:mobile_app_theraphy/data/model/therapy.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:mobile_app_theraphy/data/remote/http_helper.dart';

class IotResults extends StatefulWidget {
  const IotResults({Key? key, required this.therapy, required this.date})
      : super(key: key);
  final Therapy therapy;
  final String date;

  @override
  State<IotResults> createState() => _IotResultsState();
}

class _IotResultsState extends State<IotResults> {
  HttpHelper? _httpHelper;
  List<IotResult>? iotResults = [];
  List<IotResult>? iotResultswithMapDuration = [];
  double heartbeatAverage = 0.0;
  double temperatureAverage = 0.0;
  double humidityAverage = 0.0;

  double calcularPromedioPulse(List<IotResult> iotResults) {
    if (iotResults.isEmpty) {
      return 0.0; // Manejar el caso cuando la lista está vacía para evitar divisiones por cero
    }
    // Calcular la suma de los valores de pulse
    double sumaPulse = iotResults
        .map((result) => double.tryParse(result.pulse ?? '0.0') ?? 0.0)
        .reduce((value, element) => value + element);

    // Calcular el promedio
    double promedio = sumaPulse / iotResults.length;

    return promedio;
  }

  double calcularPromedioTemperature(List<IotResult> iotResults) {
    if (iotResults.isEmpty) {
      return 0.0; // Manejar el caso cuando la lista está vacía para evitar divisiones por cero
    }
    // Calcular la suma de los valores de pulse
    double sumaPulse = iotResults
        .map((result) => double.tryParse(result.temperature ?? '0.0') ?? 0.0)
        .reduce((value, element) => value + element);

    // Calcular el promedio
    double promedio = sumaPulse / iotResults.length;

    return promedio;
  }

  double calcularPromedioHumidity(List<IotResult> iotResults) {
    if (iotResults.isEmpty) {
      return 0.0; // Manejar el caso cuando la lista está vacía para evitar divisiones por cero
    }
    // Calcular la suma de los valores de pulse
    double sumaPulse = iotResults
        .map((result) => double.tryParse(result.humidity ?? '0.0') ?? 0.0)
        .reduce((value, element) => value + element);

    // Calcular el promedio
    double promedio = sumaPulse / iotResults.length;

    return promedio;
  }

  Future initialize() async {
    // Obtén las listas
    iotResults = List.empty();
    iotResults = await _httpHelper?.getIotResultsByTherapyIdandDate(
        widget.therapy.id, widget.date) ?? [];

    // Filtra los elementos con mapDuration diferente de 0
    iotResultswithMapDuration =
        iotResults!.where((result) => result.mapDuration != '0').toList();

    heartbeatAverage = calcularPromedioPulse(iotResults!);
    temperatureAverage = calcularPromedioTemperature(iotResults!);
    humidityAverage = calcularPromedioHumidity(iotResults!);

    // Actualiza las listas
    setState(() {
      iotResults = iotResults;
      iotResultswithMapDuration = iotResultswithMapDuration;
      heartbeatAverage = heartbeatAverage;
      temperatureAverage = temperatureAverage;
      humidityAverage = humidityAverage;
    });
  }

  @override
  void initState() {
    _httpHelper = HttpHelper();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: -10,
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            "Patient's Physical Performance",
            style: TextStyle(
              color: AppConfig.primaryColor,
              fontSize: 21,
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
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Muscular Action Potential",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10), // Ajusta el valor según sea necesario
                Text(
                  "(MAP)",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14, // Tamaño más pequeño para "MAP"
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.3, // Ocupa la mitad de la pantalla
                child: SfCartesianChart(
                  primaryXAxis: NumericAxis(
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    title: AxisTitle(text: 'Index'),
                  ),
                  primaryYAxis: NumericAxis(
                    axisLine: const AxisLine(width: 0),
                    title: AxisTitle(text: 'Amplitude (µV)'),
                  ),
                  series: <ChartSeries>[
                    StackedLineSeries<IotResult, double>(
                      dataSource: iotResults!,
                      xValueMapper: (IotResult result, _) =>
                          iotResults!.indexOf(result).toDouble(),
                      yValueMapper: (IotResult result, _) =>
                          double.tryParse(result.mapAmplitude ?? '0') ?? 0,
                      markerSettings: const MarkerSettings(isVisible: true),
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        builder: (dynamic data, dynamic point, dynamic series,
                            int pointIndex, int seriesIndex) {
                          return Text('${data.mapAmplitude}');
                        },
                      ),
                    ),
                  ],
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                    builder: (dynamic data, dynamic point, dynamic series,
                        int pointIndex, int seriesIndex) {
                      // Contenido personalizado dentro del cuadro emergente
                      final IotResult data = iotResults![pointIndex];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.black, // Color negro
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0, 2),
                                blurRadius: 3),
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.center, // Al centro
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Reading ${pointIndex + 1}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14), // Letras blancas
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 1, // Altura de la línea
                              width: 90, // Ancho de la línea
                              color: Colors.white, // Color blanco
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Amplitude : ${data.mapAmplitude} µV',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12), // Letras blancas
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Frequency : ${data.mapFrequency} Hz',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12), // Letras blancas
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: 188,
                        height: 190,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Alinea los elementos en la parte superior
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Average Heartbeat',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          5), // Ajusta el valor según sea necesario
                                  GestureDetector(
                                    onTap: () {
                                      // Muestra el diálogo cuando se toca el icono
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:
                                                const Text('Average Heartbeat'),
                                            content: const Text(
                                                "This information allows the patient's cardiovascular response to be evaluated, providing key information about their exercise tolerance and appropriate intensity."),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  // Cierra el diálogo cuando se toca "Cerrar"
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Close'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Icon(
                                      Icons.info_outline,
                                      color: Colors.green,
                                      size:
                                          25, // Ajusta el tamaño del icono según sea necesario
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Expanded(
                              child: Center(
                                child: Icon(
                                  Icons.favorite,
                                  size: 80,
                                  color: Color.fromARGB(255, 227, 56, 56),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 55.0,
                                bottom: 25.0,
                              ),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          '${heartbeatAverage.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight:
                                            FontWeight.bold, // Añadir negrita
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' BPM',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight:
                                            FontWeight.normal, // Sin negrita
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 16), // Espacio entre las cards
                    Expanded(
                      child: Container(
                        width: 188,
                        height: 190,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Alinea los elementos en la parte superior
                                children: [
                                  const Expanded(
                                    child: Text(
                                      'Average Temperature',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          5), // Ajusta el valor según sea necesario
                                  GestureDetector(
                                    onTap: () {
                                      // Muestra el diálogo cuando se toca el icono
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Average Temperature'),
                                            content: const Text(
                                                "These information help monitor the patient's physiological response to exercise, identifying possible signs of overexertion or abnormal reactions."),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  // Cierra el diálogo cuando se toca "Cerrar"
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Close'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Icon(
                                      Icons.info_outline,
                                      color: Colors.green,
                                      size:
                                          25, // Ajusta el tamaño del icono según sea necesario
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.00001,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left:
                                      15), // Ajusta el valor según sea necesario
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Etiquetas a la izquierda
                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                            height:
                                                8), // Espacio adicional entre las etiquetas
                                        Text('${100}°C',
                                            style:
                                                TextStyle(color: Colors.grey)),
                                        SizedBox(height: 8),
                                        Text('${(100 * 0.75).toInt()}°C',
                                            style:
                                                TextStyle(color: Colors.grey)),
                                        SizedBox(height: 8),
                                        Text('${(100 * 0.5).toInt()}°C',
                                            style:
                                                TextStyle(color: Colors.grey)),
                                        SizedBox(height: 8),
                                        Text('${(100 * 0.25).toInt()}°C',
                                            style:
                                                TextStyle(color: Colors.grey)),
                                        SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Termómetro
                                  Container(
                                    width: 20,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 182, 182, 182),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: temperatureAverage / 100 * 100,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  // Título a la derecha del termómetro
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 1.0,
                                      bottom: 1.0,
                                    ),
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: temperatureAverage.toStringAsFixed(2),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight
                                                  .bold, // Añadir negrita
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' °C',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight
                                                  .normal, // Sin negrita
                                            ),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        // Contenido de la segunda card
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: 188,
                        height: 190,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start, // Alinea los elementos en la parte superior
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'MAPs Duration',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            5), // Ajusta el valor según sea necesario
                                    GestureDetector(
                                      onTap: () {
                                        // Muestra el diálogo cuando se toca el icono
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  const Text('MAPs Duration'),
                                              content: const Text(
                                                  "This interval represents the time each action potential lasts. It can indicate how quickly the muscle is activated and deactivated."),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    // Cierra el diálogo cuando se toca "Cerrar"
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Close'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Icon(
                                        Icons.info_outline,
                                        color: Colors.green,
                                        size:
                                            25, // Ajusta el tamaño del icono según sea necesario
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 140,
                                    child: SfCartesianChart(
                                      primaryXAxis: CategoryAxis(
                                        desiredIntervals: 4,
                                      ),
                                      primaryYAxis: NumericAxis(
                                        interval:
                                            10000, // Ajusta el valor del intervalo según tus necesidades
                                      ),
                                      series: <ChartSeries>[
                                        ColumnSeries<IotResult, int>(
                                          dataSource: iotResultswithMapDuration!
                                              .take(3)
                                              .toList(),
                                          xValueMapper: (IotResult result, _) =>
                                              iotResultswithMapDuration!
                                                  .take(3)
                                                  .toList()
                                                  .indexOf(result)
                                                  .toInt(),
                                          yValueMapper: (IotResult result, _) =>
                                              double.tryParse(
                                                  result.mapDuration ?? '0') ??
                                              0,
                                          color: AppConfig.primaryColor,
                                          dataLabelSettings: DataLabelSettings(
                                            isVisible: true,
                                            labelPosition:
                                                ChartDataLabelPosition.outside,
                                          ),
                                        ),
                                      ],
                                      enableSideBySideSeriesPlacement: false,
                                    ),
                                  ),
                                ],
                              )
                            ]),
                      ),
                    ),
                    const SizedBox(width: 16), // Espacio entre las cards
                    Expanded(
                      child: Container(
                        width: 188,
                        height: 190,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Alinea los elementos en la parte superior
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Average Humidity',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          5), // Ajusta el valor según sea necesario
                                  GestureDetector(
                                    onTap: () {
                                      // Muestra el diálogo cuando se toca el icono
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:
                                                const Text('Average Humidity'),
                                            content: const Text(
                                                "This information is important to evaluate the patient's comfort and prevent possible respiratory discomfort."),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  // Cierra el diálogo cuando se toca "Cerrar"
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Close'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Icon(
                                      Icons.info_outline,
                                      color: Colors.green,
                                      size:
                                          25, // Ajusta el tamaño del icono según sea necesario
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.00001,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left:
                                      28), // Ajusta el valor según sea necesario
                              child: CircularPercentIndicator(
                                radius: 120.0,
                                lineWidth: 10.0,
                                percent: humidityAverage /
                                    100, // Ajusta este valor según tus necesidades
                                center: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 1.0,
                                    bottom: 1.0,
                                  ),
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: humidityAverage.toStringAsFixed(2),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight
                                                .bold, // Añadir negrita
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' %',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 17,
                                            fontWeight: FontWeight
                                                .normal, // Sin negrita
                                          ),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                backgroundColor: Colors.grey,
                                progressColor: AppConfig.primaryColor,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
