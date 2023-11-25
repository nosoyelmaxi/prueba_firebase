import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:prueba_firebase/pages/evento_agregar.dart';
import 'package:prueba_firebase/services/firestore_service.dart';

class AdminPage extends StatefulWidget {

  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final formatoFecha = DateFormat('dd-MM-yyyy, hh:mm');

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
              child: Text(this.emailUsuario(context)),
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

      //body
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: Text('Eventos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: StreamBuilder(
                stream: FirestoreService().eventos(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.separated(
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var evento = snapshot.data!.docs[index];
                        return ListTile(
                            onTap: () {
                              showDialog(
                                context: context, 
                                builder: (context) => AlertDialog(
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      }, 
                                      child: Text('Cerrar')
                                    ),
                                  ],
                                title: Text('Descripcion:'),
                                content: Text(evento['descripcion']),
                              ));
                            } ,
                            leading: Image.network(
                            evento['foto'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              MdiIcons.trashCan,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              FirestoreService().eventoBorrar(evento.id);
                            },
                          ),
                          title: Text(evento['nombre'], style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            children: [
                              Row(children: [
                                Text('(${evento['tipo']})', style: TextStyle(color: Colors.blue, fontSize: 13)),
                                Text(' '),
                                Text(evento['lugar'])
                              ]),
                              Row(children: [
                                Text(formatoFecha.format(evento['fecha'].toDate()))
                              ],)
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          MaterialPageRoute route =
              MaterialPageRoute(builder: (context) => EventoAgregarPage());
          Navigator.push(context, route);
        },
      ),
    );
  }
  String emailUsuario(BuildContext context) {
    final usuario = Provider.of<User?>(context);
    return usuario!.email.toString();
  }
}
