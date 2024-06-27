import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:companies_tasks/screens/auth/login_screen.dart';
import 'package:companies_tasks/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../widget/dialog_widget.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final name = TextEditingController();
  final categorycontroller = TextEditingController(text: 'Job category');
  final phoneNumber = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final formkey = GlobalKey<FormState>();
  final FocusNode focusNodePass = FocusNode();
  final FocusNode focusNodeConfPass = FocusNode();
  final FocusNode focusNodePhone = FocusNode();
  bool isObscure = true;
  XFile? pickedFile;
  CroppedFile? croppedFile;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: [
                      const Text(
                        'Already have an account ',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      SizedBox(
                        width: size.width * 0.02,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(color: Colors.blue, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.025,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: name,
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
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 3.5,
                                  ),
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                height: size.height * 0.17,
                                width: size.width * 0.35,
                                child: pickedFile == null
                                    ? const Icon(
                                        Icons.person,
                                        size: 70,
                                      )
                                    : ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                        child: Image.file(
                                          fit: BoxFit.fill,
                                          File(pickedFile!.path),
                                        ),
                                      ),
                              ),
                            ),
                            InkWell(
                              onTap: pickedFile == null
                                  ? imageShowDialogAdd
                                  : imageShowDialogEdit,
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      width: 3,
                                      color: Colors.black,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: pickedFile == null
                                      ? const Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Icon(
                                            Icons.add_a_photo,
                                            size: 29,
                                          ),
                                        )
                                      : const Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Icon(
                                            Icons.edit,
                                            size: 23,
                                          ),
                                        )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  ///
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return DialogWidget(
                            categorycontroller: categorycontroller,
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: categorycontroller,
                        enabled: false,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        maxLines: 1,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(100, 158, 158, 158),
                        ),
                      ),
                    ),
                  ),

                  ///EMAIL
                  TextFormField(
                    controller: email,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(focusNodePhone),
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

                  ///Phone number
                  TextFormField(
                    controller: phoneNumber,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(focusNodePass),
                    focusNode: focusNodePhone,
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

                  /// PASSWORD
                  TextFormField(
                    controller: password,
                    focusNode: focusNodePass,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(focusNodeConfPass),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a valid password';
                      }
                      if (value.length <= 7) {
                        return 'Enter more than 7 characters';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: isObscure,
                    decoration: InputDecoration(
                      label: const Text('Password'),
                      suffixIcon: IconButton(
                          icon: Icon(
                            isObscure ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          }),
                    ),
                  ),

                  ///pass
                  TextFormField(
                    controller: confirmPassword,
                    textInputAction: TextInputAction.done,
                    focusNode: focusNodeConfPass,
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a valid Confirm Password';
                      }
                      if (value.length <= 7) {
                        return 'Enter more than 7 characters';
                      }
                      if (value != password.text) {
                        return "Password doesn't match";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: isObscure,
                    decoration: InputDecoration(
                      label: const Text('Confirm Password'),
                      suffixIcon: IconButton(
                          icon: Icon(
                            isObscure ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          }),
                    ),
                  ),

                  SizedBox(
                    height: size.height * 0.055,
                  ),

                  InkWell(
                    onTap: () async {
                      if (formkey.currentState!.validate() &&
                          pickedFile != null) {
                        Auth().createUserByEmail(
                          image: File(pickedFile!.path),
                          email: email.text,
                          password: password.text,
                          context: context,
                          name: name.text,
                          phone: phoneNumber.text,
                          jobCategory: categorycontroller.text,
                        );
                      }
                      if (pickedFile == null) {
                        return AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          title: 'IMAGE',
                          desc: 'Please upload the picture',
                          descTextStyle: const TextStyle(
                              color: Colors.black, fontSize: 20),
                          btnCancelColor: Colors.orange[400],
                          btnCancelText: 'OK',
                          btnCancelOnPress: () {},
                        ).show();
                      }
                    },
                    child: Container(
                      height: size.height * 0.07,
                      width: double.infinity,
                      color: Colors.black,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'SIGN UP',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                            SizedBox(
                              width: size.width * 0.03,
                            ),
                            const Icon(
                              Icons.person_add_alt,
                              color: Colors.white,
                              size: 29,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
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

  // void imageCamera() async {
  //   var xFile = await ImagePicker().pickImage(
  //     source: ImageSource.camera,
  //     // maxHeight: 1080,
  //     // maxWidth: 1080,
  //   );
  //   // setState(() {
  //   //   pickedFile = File(xFile!.path);
  //   // });
  //   cropImage(xFile!.path);
  //   Navigator.pop(context);
  // }

  // void imageGallery() async {
  //   Navigator.pop(context);
  //   var xFile = await ImagePicker().pickImage(
  //     source: ImageSource.gallery,
  //     // maxHeight: 1080,
  //     // maxWidth: 1080,
  //   );
  //   // if (pickedFile != null) {
  //   //   setState(() {
  //   //     pickedFile = File(xFile!.path);
  //   //   });
  //   // }
  //   // setState(() {
  //   //   pickedFile = File(xFile!.path);
  //   // });
  //   cropImage(xFile!.path);
  // }

  //  void cropImage(filePath) async {
  //   CroppedFile? cropImage = await ImageCropper().cropImage(
  //     sourcePath: filePath,
  //   );
  // }
  // void cropImage(filePath) async {
  //   if (pickedFile != null) {
  //     CroppedFile? cropImages = await ImageCropper().cropImage(
  //       sourcePath: filePath,
  //       // maxHeight: 1080,
  //       // maxWidth: 1080,
  //     );
  //     if (cropImages != null) {
  //       setState(() {
  //         pickedFile = File(cropImages.path);
  //       });
  //     }
  //   }
  // }

  void clear() {
    setState(() {
      pickedFile = null;
      croppedFile = null;
    });
    Navigator.pop(context);
  }
}
