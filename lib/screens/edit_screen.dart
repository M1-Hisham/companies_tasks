import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companies_tasks/inner_screens/profile.dart';
import 'package:companies_tasks/services/auth_services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditScreen extends StatefulWidget {
  const EditScreen(
      {super.key,
      required this.image,
      required this.name,
      required this.email,
      required this.phone});
  final String image;
  final String name;
  final String email;
  final String phone;
  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  static TextEditingController nameControler = TextEditingController();
  static TextEditingController emailControler = TextEditingController();
  static TextEditingController phoneControler = TextEditingController();
  final formkey = GlobalKey<FormState>();
  XFile? pickedFile;
  CroppedFile? croppedFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            children: [
              const SizedBox(
                height: 35,
              ),
              // const Center(
              //   child: Text(
              //     'EDIT',
              //     style: TextStyle(fontSize: 30),
              //   ),
              // ),

              Stack(alignment: Alignment.bottomRight, children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.black,

                  // backgroundImage: NetworkImage(widget.image),
                  child: pickedFile == null
                      ? Container(
                          // height: 225,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(widget.image),
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        )
                      : Container(
                          // height: 225,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(pickedFile!.path)),
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                ),
                InkWell(
                  onTap: imageShowDialogAdd,
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 3,
                          color: Colors.black,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.edit,
                          size: 23,
                        ),
                      )),
                ),
              ]),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  controller: nameControler =
                      TextEditingController(text: widget.name),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a valid Full name";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    label: Text('Full name'),
                  ),
                ),
              ),

              ///EMAIL
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  controller: emailControler =
                      TextEditingController(text: widget.email),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@') ||
                        !value.contains('.com')) {
                      return "Please enter a valid Email adress";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    label: Text('Email'),
                  ),
                ),
              ),

              ///Phone number
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  controller: phoneControler =
                      TextEditingController(text: widget.phone),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('01')) {
                      return "Please enter a valid Phone Number";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    label: Text('Phone Number '),
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  final uid = Auth().userUID();
                  if (pickedFile != null) {
                    var ref = FirebaseStorage.instance.ref();
                    var imageRef = ref.child('users').child('$uid.jpg');
                    var uploadedImage =
                        await imageRef.putFile(File(pickedFile!.path));
                    var imageUrl = await uploadedImage.ref.getDownloadURL();
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .update(
                      {
                        'image': imageUrl,
                      },
                    );
                  }
                  if (formkey.currentState!.validate()) {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .update(
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
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(90),
                  ),
                  height: 50,
                  width: 150,
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Edit',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Icon(
                          Icons.upload_file_outlined,
                          color: Colors.white,
                          size: 25,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void imageShowDialogAdd() {
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
                    onTap: uploadImageCamera,
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
                    onTap: uploadImageGallery,
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

  void imageShowDialogEdit() {
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
                    onTap: clear,
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

  void uploadImageGallery() async {
    Navigator.pop(context);
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    cropImage(pickedFile);
  }

  void uploadImageCamera() async {
    Navigator.pop(context);
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    cropImage(pickedFile);
  }

  void cropImage(filePath) async {
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
        setState(() {
          pickedFile = XFile(croppedFile.path);
          // croppedFile = croppedFile;
        });
      }
    }
  }

  void clear() {
    setState(() {
      pickedFile = null;
      croppedFile = null;
    });
    Navigator.pop(context);
  }
}
