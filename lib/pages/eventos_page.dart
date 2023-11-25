import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:intl/intl.dart';
import 'package:prueba_firebase/constants/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:prueba_firebase/services/auth_service.dart';
import 'package:prueba_firebase/services/firestore_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //variables carrusel
  final formatoFecha = DateFormat('dd-MM-yyyy, hh:mm');
  bool mostrarDesc = false;
  int selectedImgIndex = -1;

  List<String> eventoNom = [];
  List<String> eventoDesc = [];
  List<Timestamp> eventoFecha = [];
  List<String> eventoFoto = [];
  List<String> eventoLugar = [];
  List<int> eventoMGs = [];
  List<String> eventoTipo = [];


  @override
  void initState() {
    super.initState();
    cargarDatosDestacados();
    selectedOption = OpcionDropdown.Todos;
  }

  Future<void> cargarDatosDestacados() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('eventos').where('destacado', isEqualTo: true).get();
    List<DocumentSnapshot> documentos = querySnapshot.docs;

    setState(() {
      eventoNom = documentos.map((doc) => doc['nombre'] as String).toList();
      eventoDesc = documentos.map((doc) => doc['descripcion'] as String).toList();
      eventoFecha = documentos.map((doc) => doc['fecha'] as Timestamp).toList();
      eventoFoto = documentos.map((doc) => doc['foto'] as String).toList();
      eventoLugar = documentos.map((doc) => doc['lugar'] as String).toList();
      eventoMGs = documentos.map((doc) => doc['megusta'] as int).toList();
      eventoTipo = documentos.map((doc) => doc['tipo'] as String).toList();
    });
  }



  //variables dropdown
  final TextEditingController opcionController = TextEditingController();
  OpcionDropdown? selectedOption;


  

  //APP
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appbar
      appBar: AppBar(title: Text('Punto Tocket')),

      //drawer
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      // color: Colors.blue,
                    ),
                    child: Text(''),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Image(image: AssetImage('assets/logos/google.png'), width: 20,),
                        Text('  Iniciar Sesion con Google'),
                      ],
                    ),
                    onTap: () async {
                      await signInWithGoogle();
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('.'),
              onTap: () {},
            ),
          ],
        ),
      ),


      //body
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            //Carrusel destacados
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Destacados:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                ),
              ],
            ),
            Container(
              height: 200,
              child: Swiper(
                loop: false,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        mostrarDesc = !mostrarDesc;
                        selectedImgIndex = index;
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            child: Image.network(
                              eventoFoto[index],
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black,
                                  const Color.fromARGB(0, 0, 0, 0),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                          if (mostrarDesc && selectedImgIndex == index)
                            Container(
                              color: Colors.black.withOpacity(0.8),
                              child: Center(
                                child: Text(
                                  eventoDesc[index],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          if (!mostrarDesc)
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                          '(${eventoTipo[index].toString()})',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                    ],
                                  ),
                                  Row(children: [
                                    Text(
                                      eventoNom[index].toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ]),
                                  Row(children: [
                                    Text(
                                      eventoLugar[index].toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    )
                                  ]),
                                  Row(children: [
                                    Text(
                                      formatoFecha.format(eventoFecha[index].toDate()) ,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    )
                                  ]),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: eventoNom.length,
                viewportFraction: 0.8,
                scale: 0.9,
                pagination: SwiperPagination(
                  alignment: Alignment.bottomCenter,
                  builder: SwiperPagination.rect,
                ),
                onIndexChanged: (index) {
                  setState(() {
                    mostrarDesc = false;
                    selectedImgIndex = -1;
                  });
                },
              ),
            ),


            //texto hint
            Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('toca la imagen para más info.')])
            ),
      
            //Titulo + filtro
            Row(children: [
              //titulo
              Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text(
                    'Eventos',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
              // Dropdown
              DropdownMenu<OpcionDropdown>(
                initialSelection: OpcionDropdown.Todos,
                controller: opcionController,
                requestFocusOnTap: false,
                label: Text('Filtrar'),
                onSelected: (OpcionDropdown? opcion) {
                  setState(() {
                    selectedOption = opcion;
                  });
                },
                dropdownMenuEntries: OpcionDropdown.values
                    .map<DropdownMenuEntry<OpcionDropdown>>(
                        (OpcionDropdown opcion) {
                  return DropdownMenuEntry<OpcionDropdown>(
                    value: opcion,
                    label: opcion.label,
                  );
                }).toList(),
              ),
            ]),
      
            //listar TODOS
            if (selectedOption == OpcionDropdown.Todos)
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
                      return Expanded(
                        child: ListView.separated(
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
                          trailing: Column(
                            children: [
                              InkWell(child: Icon(MdiIcons.heart, size: 40,), onTap: () {}),
                              Text(evento['megusta'].toString())
                            ],
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
                        ),
                      );
                    }
                  }
                ),
              ),
            ),
           
            //listar POR REALIZAR
            if (selectedOption == OpcionDropdown.PorRealizar)
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: StreamBuilder(
                  stream: FirestoreService().eventosPorRealizar(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());

                    } else {
                      return Expanded(
                        child: ListView.separated(
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
                          trailing: Column(
                            children: [
                              InkWell(child: Icon(MdiIcons.heart, size: 40,), onTap: () {}),
                              Text(evento['megusta'].toString())
                            ],
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
                        ),
                      );
                    }
                  }
                ),
              ),
            ),

            //listar PASADOS
            if (selectedOption == OpcionDropdown.Finalizados)
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: StreamBuilder(
                  stream: FirestoreService().eventosPasados(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());

                    } else {
                      return Expanded(
                        child: ListView.separated(
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
                          trailing: Column(
                            children: [
                              InkWell(child: Icon(MdiIcons.heart, size: 40,), onTap: () {}),
                              Text(evento['megusta'].toString())
                            ],
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
                        ),
                      );
                    }
                  }
                ),
              ),
            ),

      
            //mas
      
      
          ]),
        ),
      );
  }
}
