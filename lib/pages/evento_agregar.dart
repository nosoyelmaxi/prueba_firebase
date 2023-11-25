import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:prueba_firebase/constants/dropdown.dart';
import 'package:prueba_firebase/services/firestore_service.dart';
import 'package:intl/intl.dart';
import 'package:prueba_firebase/services/upload_image.dart';

class EventoAgregarPage extends StatefulWidget {
  const EventoAgregarPage({super.key});

  @override
  State<EventoAgregarPage> createState() => _EventoAgregarPageState();
}

class _EventoAgregarPageState extends State<EventoAgregarPage> {
  TextEditingController nombreCtrl = TextEditingController();
  TextEditingController lugarCtrl = TextEditingController();
  TextEditingController descripcionCtrl = TextEditingController();
  TextEditingController opcionController = TextEditingController();
  OpcionDropdown? selectedOption;

  final formKey = GlobalKey<FormState>();
  DateTime fecha_evento = DateTime.now();
  final formatoFecha = DateFormat('dd-MM-yyyy, hh:mm');
  String tipo = '';
  File? imagen_evento;
  String img_url = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appbar
      appBar: AppBar(title: Text('Punto Tocket')),

      //drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                  // color: Colors.blue,
                  ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: Text('Cerrar sesion'),
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                child: Text(
                  'Agregar Evento',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 30),
                ),
              ),
              TextFormField(
                controller: nombreCtrl,
                decoration: InputDecoration(label: Text('Nombre')),
                validator: (nombre) {
                  if (nombre!.isEmpty) {
                    return 'Indique el nombre';
                  }

                  if (nombre.length < 3) {
                    return 'Nombre debe ser de al menos 3 letras';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: lugarCtrl,
                decoration: InputDecoration(label: Text('Lugar')),
                validator: (lugar) {
                  if (lugar!.isEmpty) {
                    return 'Indique un lugar';
                  }

                  if (lugar.length < 3) {
                    return 'Lugar debe ser de al menos 3 letras';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: descripcionCtrl,
                decoration: InputDecoration(label: Text('Descripcion')),
                validator: (desc) {
                  if (desc!.isEmpty) {
                    return 'Indique una descripcion';
                  }

                  if (desc.length < 5) {
                    return 'Descripcion debe ser de al menos 3 letras';
                  }

                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: 'Concierto',
                  decoration: InputDecoration(labelText: 'Tipo'),
                  items: [
                    DropdownMenuItem(
                        child: Text('Concierto'), value: 'Concierto'),
                    DropdownMenuItem(child: Text('Fiesta'), value: 'Fiesta'),
                    DropdownMenuItem(child: Text('Evento'), value: 'Evento'),
                    DropdownMenuItem(
                        child: Text('Deportivo'), value: 'Deportivo'),
                  ],
                  // items: carreras.map<DropdownMenuItem<String>>((carr) {
                  //   return DropdownMenuItem<String>(
                  //     child: Text(carr['nombre']),
                  //     value: carr['nombre'],
                  //   );
                  // }).toList(),
                  onChanged: (tipoSeleccionado) {
                    setState(() {
                      tipo = tipoSeleccionado!;
                    });
                  },
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 15),
                child: Row(
                  children: [
                    Text('Fecha del Evento: '),
                    Text(formatoFecha.format(fecha_evento),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Spacer(),
                    IconButton(
                      icon: Icon(MdiIcons.calendar),
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                          locale: Locale('es', 'ES'),
                        ).then((fecha) {
                          setState(() {
                            fecha_evento = fecha ?? fecha_evento;
                          });
                        });
                      },
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  height: 100,
                  width: 100,
                  color: Color.fromARGB(255, 215, 215, 215),
                  child: Stack(children: [
                    imagen_evento != null
                        ? Image.file(
                            imagen_evento!,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          )
                        : Container(),
                    Center(
                      child: IconButton(
                        iconSize: 40,
                        color: Colors.white,
                        onPressed: () async {
                          final image = await getImage();
                          setState(() {
                            if (image != null) {
                              imagen_evento = File(image!.path);
                            }
                          });
                        },
                        icon: Icon(MdiIcons.imagePlus),
                      ),
                    ),
                  ]),
                ),
              ),
              Center(
                child: Text('Seleccione una foto...'),
              ),
              //BOTON
              Container(
                margin: EdgeInsets.only(top: 30),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text('Agregar Evento',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    if (imagen_evento != null) {
                      img_url = await uploadImage(imagen_evento!);
                    } else {
                      return;
                    }
                    if (formKey.currentState!.validate()) {
                      FirestoreService().eventoAgregar(
                          nombreCtrl.text.trim(),
                          fecha_evento,
                          lugarCtrl.text.trim(),
                          descripcionCtrl.text.trim(),
                          tipo,
                          0,
                          img_url,
                          false);
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
