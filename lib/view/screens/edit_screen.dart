import 'dart:io';
import 'package:companies_tasks/view_models/edit_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatelessWidget {
   EditScreen(
      {super.key,
      required this.image,
      required this.name,
      required this.email,
      required this.phone});
  final String image;
  final String name;
  final String email;
  final String phone;
  static TextEditingController nameControler = TextEditingController();
  static TextEditingController emailControler = TextEditingController();
  static TextEditingController phoneControler = TextEditingController();
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final editViewModel = Provider.of<EditViewModel>(context);
    final pickedFile = editViewModel.pickedFile;
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

              Stack(alignment: Alignment.bottomRight, children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.black,
                  child: pickedFile == null
                      ? Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(image),
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(pickedFile.path)),
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                ),
                InkWell(
                  onTap: () => editViewModel.imageShowDialogAdd(context),
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
                      TextEditingController(text: name),
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
                      TextEditingController(text: email),
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
                      TextEditingController(text: phone),
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
                  editViewModel.updateUserProfile(context, formkey,
                      nameControler, emailControler, phoneControler);
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
}
