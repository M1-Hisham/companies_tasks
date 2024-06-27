import 'package:companies_tasks/screens/auth/forget_password.dart';
import 'package:flutter/material.dart';
import '../../services/auth_services.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static bool _isObscure = true;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formkey = GlobalKey<FormState>();
  var email = TextEditingController();
  var password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.05,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Login',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      'Don\'t have an account? ',
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const SignUp()),
                        );
                      },
                      child: const Text(
                        'SIGN UP',
                        style: TextStyle(color: Colors.blue, fontSize: 15),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.025,
                ),
                Form(
                  key: formkey,
                  child: Column(
                    children: [
                      ///EMAIL
                      TextFormField(
                        controller: email,
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

                      /// PASSWORD
                      StatefulBuilder(
                        builder: (context, setState) => TextFormField(
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a valid password';
                            }
                            if (value.length <= 7) {
                              return 'Enter more than 7 characters';
                            }
                            return null;
                          },
                          controller: password,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: LoginScreen._isObscure,
                          decoration: InputDecoration(
                            label: const Text('Password'),
                            suffixIcon: IconButton(
                                icon: Icon(
                                  LoginScreen._isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    LoginScreen._isObscure =
                                        !LoginScreen._isObscure;
                                  });
                                }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.001,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ForgetPassword()));
                    },
                    child: const Text(
                      'Forget password?',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                          fontSize: 15),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.055,
                ),
                InkWell(
                  onTap: () {
                    if (formkey.currentState!.validate()) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      Auth().userLogin(
                        email: email.text,
                        password: password.text,
                        context: context,
                      );
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
                            'LOGIN',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                          SizedBox(
                            width: size.width * 0.03,
                          ),
                          const Icon(
                            Icons.login,
                            color: Colors.white,
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
    );
  }
}
