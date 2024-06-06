import 'package:flutter/material.dart';
import 'package:mobile_app_theraphy/config/app_config.dart';
import 'package:mobile_app_theraphy/config/navBar.dart';
import 'package:mobile_app_theraphy/data/model/consultation.dart';
import 'package:mobile_app_theraphy/data/model/physiotherapist.dart';
import 'package:mobile_app_theraphy/data/remote/http_helper.dart';

class ConsultationsList extends StatefulWidget {
  const ConsultationsList({super.key});

  @override
  State<ConsultationsList> createState() => _ConsultationsListState();
}

class _ConsultationsListState extends State<ConsultationsList> {
  int selectedIndex = 1;
  HttpHelper? _httpHelper;
  List<Consultation>? myConsultations = [];
  List<Consultation>? filteredConsultations = [];
  int? id;
  Physiotherapist? physiotherapistLogged;

  bool _done = false;
  bool _all = true;

  Future initialize() async {
    //Get user logged
    id = await _httpHelper?.getPhysiotherapistLogged();

    // Get Lists
    // ignore: sdk_version_since
    myConsultations = List.empty();
    myConsultations = await _httpHelper?.getMyConsultations(id!);
    physiotherapistLogged = await _httpHelper?.getPhysiotherapist();

    //Update lists
    setState(() {
      id = id;
      physiotherapistLogged = physiotherapistLogged;
      myConsultations = myConsultations;
      filteredConsultations = myConsultations;
    });
  }

  TextEditingController searchController = TextEditingController();

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
          title: Padding(
            padding: const EdgeInsets.only(
                top: 20), // Ajusta la cantidad de espacio según tus necesidades
            child: Text(
              "My Consultations",
              style: TextStyle(
                // color: AppConfig.primaryColor,
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
        body: Container(
          color: Colors.white, // Fondo blanco
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(22.0, 22.0, 22.0, 0),
                child: Container(
                  width: 360,
                  child: TextField(
                    cursorColor: AppConfig.primaryColor,
                    // cursorColor: AppConfig.primaryColor,
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        filteredConsultations = myConsultations
                            ?.where((consultation) =>
                                ('${consultation.patient.user.firstname} ${consultation.patient.user.lastname}')
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppConfig.primaryColor,
                        //color: AppConfig.primaryColor,
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            //color: AppConfig.primaryColor,
                            color: AppConfig.primaryColor,
                            width: 2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppConfig
                                .primaryColor, //color: AppConfig.primaryColor,
                            width: 2.2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelStyle: TextStyle(
                        // color: AppConfig.primaryColor,
                        color: AppConfig.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22.0, 5, 22.0, 10),
                child: Row(
                  children: [
                    if (_done == false)
                      ElevatedButton(
                        onPressed: () async {
                          filteredConsultations =
                              await _httpHelper?.getMyConsultationsDone(id!);
                          setState(() {
                            filteredConsultations = filteredConsultations;
                            _done = true;
                            _all = false;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.white), // Fondo blanco
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Bordes redondeados en todos los lados
                            ),
                          ),
                          elevation:
                              MaterialStateProperty.all(0), // Sin elevación
                          side: MaterialStateProperty.all(BorderSide(
                            color: AppConfig
                                .primaryColor, //AppConfig.primaryColor, // Color azul
                            width: 1.5, // Ancho del borde
                          )),
                          minimumSize: MaterialStateProperty.all(
                              Size(110, 30)), // Ancho mínimo del botón
                        ),
                        child: Text(
                          'Done',
                          style: TextStyle(
                            color:
                                AppConfig.primaryColor, //AppConfig.primaryColor
                          ),
                        ),
                      ),
                    if (_done == true)
                      ElevatedButton(
                        onPressed: () async {
                          filteredConsultations =
                              await _httpHelper?.getMyConsultations(id!);
                          setState(() {
                            filteredConsultations = filteredConsultations;
                            _done = false;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              AppConfig.primaryColor), // Fondo blanco
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Bordes redondeados en todos los lados
                            ),
                          ),
                          elevation:
                              MaterialStateProperty.all(0), // Sin elevación
                          minimumSize: MaterialStateProperty.all(
                              Size(110, 30)), // Ancho mínimo del botón
                        ),
                        child: Text(
                          'Done',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    Container(
                      width: 10,
                      color: Colors.white, //AppConfig.primaryColor
                    ),
                    if (_all == false)
                      ElevatedButton(
                        onPressed: () async {
                          filteredConsultations =
                              await _httpHelper?.getMyConsultations(id!);
                          setState(() {
                            filteredConsultations = filteredConsultations;
                            _all = true;
                            _done = false;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.white), // Fondo blanco
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Bordes redondeados en todos los lados
                            ),
                          ),
                          elevation:
                              MaterialStateProperty.all(0), // Sin elevación
                          side: MaterialStateProperty.all(BorderSide(
                            color: AppConfig
                                .primaryColor, //AppConfig.primaryColor, // Color azul
                            width: 1.5, // Ancho del borde
                          )),
                          minimumSize: MaterialStateProperty.all(
                              Size(110, 30)), // Ancho mínimo del botón
                        ),
                        child: Text(
                          'All',
                          style: TextStyle(
                            color: AppConfig.primaryColor,
                            //AppConfig.primaryColor
                          ),
                        ),
                      ),
                    if (_all == true)
                      ElevatedButton(
                        onPressed: () async {
                          filteredConsultations =
                              await _httpHelper?.getMyConsultations(id!);
                          setState(() {
                            filteredConsultations = filteredConsultations;
                            _all = false;
                          });
                          ;
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            AppConfig.primaryColor, //AppConfig.primaryColor
                          ), // Fondo blanco
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Bordes redondeados en todos los lados
                            ),
                          ),
                          elevation:
                              MaterialStateProperty.all(0), // Sin elevación
                          minimumSize: MaterialStateProperty.all(
                              Size(110, 30)), // Ancho mínimo del botón
                        ),
                        child: Text(
                          'All',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: filteredConsultations == null ||
                        filteredConsultations!.isEmpty
                    ? const Center(
                        child: Text(
                          'No consultations found',
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredConsultations!.length,
                        itemBuilder: (context, index) {
                          return ConsultationItem(
                              consultation: filteredConsultations![index]);
                        },
                      ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: NavBar(currentIndex: 3));
  }
}

/*   return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My consultations",
          style: TextStyle(color: Colors.blue),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        
      ),
      body: CustomScrollView(
        slivers: <Widget>[
        

          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(
                height: 15.0,
              ),
            ]),
          ),
                    SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal:
                          0.0), // Ajusta el valor vertical según tus necesidades
                  child: ConsultationItem(
                      consultation: myConsultations![index]),
                );
              },
              childCount: myConsultations?.length ?? 0,
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(
                height: 15.0,
              ),
            ]),
          ),
        ],
      ),
    );*/
class ConsultationItem extends StatefulWidget {
  const ConsultationItem({super.key, required this.consultation});
  final Consultation consultation;

  @override
  State<ConsultationItem> createState() => _ConsultationItemState();
}

class _ConsultationItemState extends State<ConsultationItem> {
  @override
  Widget build(BuildContext context) {
    String fullName =
        "${widget.consultation.patient.user.firstname} ${widget.consultation.patient.user.lastname}";
    String displayName;

    int maxDisplayNameLength = 20;

    if (fullName.length > maxDisplayNameLength) {
      displayName =
          "${widget.consultation.patient.user.firstname} ${widget.consultation.patient.user.lastname[0]}.";
    } else {
      displayName = fullName;
    }

    return FractionallySizedBox(
      widthFactor: 0.9,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: Colors.white,
        elevation: 1,
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Colors.blue,
                width: 7,
                style: BorderStyle.solid,
              ),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Hero(
                          tag: widget.consultation.id,
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            constraints: const BoxConstraints(
                              minWidth: 80.0,
                              maxWidth: 80.0,
                              minHeight: 80,
                              maxHeight: 80,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image(
                                image: NetworkImage(
                                    widget.consultation.patient.photoUrl),
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
                              displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${widget.consultation.hour} / ${widget.consultation.date} ",
                                  style: const TextStyle(
                                    color: Color(0xFFB1D7F3),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Divider(
                  color: Color(0xFFB1D7F3),
                  height: 10,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB1D7F3),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            "Topic: ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.consultation.topic,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB1D7F3),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            "At: ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.consultation.place,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/* 
  } */
