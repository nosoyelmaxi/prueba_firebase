import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

Future<dynamic> uploadImage(File image) async {
  final String filename = image.path.split("/").last;
  final Reference ref = storage.ref().child("images").child(filename);
  final UploadTask uploadTask = ref.putFile(image);
  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
  final String url = await snapshot.ref.getDownloadURL();

  if (snapshot.state == TaskState.success) {
    return url;
  } else {
    return '';
  }
}

Future getImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  return image;
}
