import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  //obtener la lista de eventos
  Stream<QuerySnapshot> eventos() {
    return FirebaseFirestore.instance.collection('eventos').snapshots();
    // return FirebaseFirestore.instance.collection('eventos').where('lugar',isLessThanOrEqualTo: 25).orderBy('fecha').snapshots();
    // return FirebaseFirestore.instance.collection('eventos').get()
  }

  Stream<QuerySnapshot> eventosPorRealizar() {
    //return FirebaseFirestore.instance.collection('eventos').snapshots();
    return FirebaseFirestore.instance.collection('eventos').where('fecha',isGreaterThanOrEqualTo: Timestamp.now()).orderBy('fecha').snapshots();
    // return FirebaseFirestore.instance.collection('eventos').get()
  }

  Stream<QuerySnapshot> eventosPasados() {
    //return FirebaseFirestore.instance.collection('eventos').snapshots();
    return FirebaseFirestore.instance.collection('eventos').where('fecha',isLessThan: Timestamp.now()).orderBy('fecha').snapshots();
    // return FirebaseFirestore.instance.collection('eventos').get()
  }

  //insertar nuevo evento
  Future<void> eventoAgregar(
      String nombre,
      DateTime fecha,
      String lugar,
      String descripcion,
      String tipo,
      int megusta,
      String foto,
      bool destacado) async {
    return FirebaseFirestore.instance.collection('eventos').doc().set({
      'nombre': nombre,
      'fecha': fecha,
      'lugar': lugar,
      'descripcion': descripcion,
      'tipo': tipo,
      'megusta': megusta,
      'foto': foto,
      'destacado': destacado,
    });
  }

  //borrar evento
  Future<void> eventoBorrar(String docId) async {
    return FirebaseFirestore.instance.collection('eventos').doc(docId).delete();
  }

  //obtener la lista de megustas
  Future<QuerySnapshot> megustas() async {
    return FirebaseFirestore.instance
        .collection('megustas')
        .orderBy('nombre')
        .get();
  }
}
