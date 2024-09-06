import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companies_tasks/services/auth_services.dart';
import 'package:companies_tasks/view/inner_screens/profile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditViewModel extends ChangeNotifier {
  XFile? pickedFile;
  CroppedFile? croppedFile;
  Future<void> updateUserProfile(
    BuildContext context,
    dynamic formkey,
    TextEditingController nameControler,
    TextEditingController emailControler,
    TextEditingController phoneControler,
  ) async {
    final uid = Auth().userUID();
    if (pickedFile != null) {
      var ref = FirebaseStorage.instance.ref();
      var imageRef = ref.child('users').child('$uid.jpg');
      var uploadedImage = await imageRef.putFile(File(pickedFile!.path));
      var imageUrl = await uploadedImage.ref.getDownloadURL();
      FirebaseFirestore.instance.collection('users').doc(uid).update(
        {
          'image': imageUrl,
        },
      );
    }
    if (formkey.currentState!.validate()) {
      FirebaseFirestore.instance.collection('users').doc(uid).update(
        {
          'name': nameControler.text,
          'email': emailControler.text,
          'phone': phoneControler.text,
        },
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(uid: uid),
        ),
      );
    }
  }

  void imageShowDialogAdd(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Please choose an option',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => uploadImageCamera(context),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.camera,
                          size: 27,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Camera',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => uploadImageGallery(context),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.photo,
                          size: 27,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Gallery',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  void imageShowDialogEdit(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Please choose an option',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      cropImage(pickedFile);
                      Navigator.pop(context);
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.edit,
                          size: 27,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Edit',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => clear(context),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.delete,
                          size: 27,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'delete',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  void uploadImageGallery(BuildContext context) async {
    Navigator.pop(context);
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    cropImage(pickedFile);
  }

  void uploadImageCamera(BuildContext context) async {
    Navigator.pop(context);
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    cropImage(pickedFile);
  }

  void cropImage(XFile? filePath) async {
    if (filePath != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: filePath.path,
        //! compressFormat: ImageCompressFormat.jpg,
        //! compressQuality: 100,
        //? uiSettings: [
        // ? AndroidUiSettings(
        //       toolbarTitle: 'Cropper',
        //       toolbarColor: Colors.deepOrange,
        //       toolbarWidgetColor: Colors.white,
        //       initAspectRatio: CropAspectRatioPreset.original,
        //       lockAspectRatio: false),
        //  ? IOSUiSettings(
        //     title: 'Cropper',
        //   ),
        //  ? WebUiSettings(
        //     context: context,
        //     presentStyle: CropperPresentStyle.dialog,
        //     boundary: const CroppieBoundary(
        //       width: 520,
        //       height: 520,
        //     ),
        //   ? viewPort:
        //         const CroppieViewPort(width: 480, height: 480, type: 'circle'),
        //     enableExif: true,
        //     enableZoom: true,
        //     showZoomer: true,
        //   ),
        // ],
      );
      if (croppedFile != null) {
        // setState(() {
        pickedFile = XFile(croppedFile.path);
        notifyListeners();
        // });
      }
    }
  }

  void clear(BuildContext context) {
    // setState(() {
    pickedFile = null;
    croppedFile = null;
    // });
    notifyListeners();
    Navigator.pop(context);
  }
}
