import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:companies_tasks/screens/auth/login_screen.dart';
import 'package:companies_tasks/services/auth_services.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword({super.key});
  final formkey = GlobalKey<FormState>();
  final email = TextEditingController();

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
            child: Column(children: [
              SizedBox(
                height: size.height * 0.05,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Forget Password',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: size.height * 0.025,
              ),
              Form(
                key: formkey,
                child: TextFormField(
                  controller: email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a valid Email adress";
                    }
                    if (!value.contains('@gmail.com')) {
                      return "A gmail account is required";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    label: Text('Email address'),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.055,
              ),
              InkWell(
                onTap: () async {
                  if (formkey.currentState!.validate()) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    var isRegistered = await Auth()
                        .isRegisteredEmail(email: email.text, context: context);
                    if (isRegistered == false) {
                      //the methode reset password
                      await Auth()
                          .resetPassword(email: email.text, context: context);
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.success,
                        title: 'Reset Password',
                        desc:
                            'Please Check your email to reset your password 👍',
                        descTextStyle: const TextStyle(color: Colors.black),
                        buttonsTextStyle: const TextStyle(color: Colors.black),
                        btnCancelColor: Colors.green,
                        btnCancelText: 'OK',
                        btnCancelOnPress: () {
                          Navigator.pop(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ));
                        },
                      ).show();
                    } else {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        title: 'Email Error',
                        desc: 'Email is not correct please check it again',
                        descTextStyle: const TextStyle(color: Colors.black),

                        btnCancelText: 'Try Again',
                        buttonsTextStyle: const TextStyle(),
                        // btnCancelOnPress: () {        },
                      ).show();
                    }
                  }
                },
                child: Container(
                  height: size.height * 0.07,
                  width: double.infinity,
                  color: Colors.black,
                  child: const Center(
                    child: Text(
                      'Raset password',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
