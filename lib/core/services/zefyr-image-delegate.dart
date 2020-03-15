import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zefyr/zefyr.dart';

class CustomImageDelegate implements ZefyrImageDelegate<ImageSource> {
  @override
  Future<String> pickImage(ImageSource source) async {
    FirebaseStorage _storage = FirebaseStorage.instance;

    final file = await ImagePicker.pickImage(source: source);
    if (file == null) return null;

    StorageReference _reference =
        _storage.ref().child("images/" + basename(file.path));
    // We simply return the absolute path to selected file.

    final StorageUploadTask uploadTask = _reference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = await downloadUrl.ref.getDownloadURL();

    Fluttertoast.showToast(
        msg: "Please wait for image to load",
        backgroundColor: Colors.black45,
        textColor: Colors.white);
    return url;
  }

  @override
  Widget buildImage(BuildContext context, String key) {
    /// Create standard [FileImage] provider. If [key] was an HTTP link
    /// we could use [NetworkImage] instead.
    final image = NetworkImage(key);
    return Image(image: image);
  }

  @override
  ImageSource get cameraSource => ImageSource.camera;

  @override
  ImageSource get gallerySource => ImageSource.gallery;
}
