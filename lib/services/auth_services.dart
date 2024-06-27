import 'dart:async';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companies_tasks/screens/auth/login_screen.dart';
import 'package:companies_tasks/screens/tasks.dart';
import 'package:companies_tasks/services/firestore_services.dart';
import 'package:companies_tasks/services/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Auth {
  //! create email & password
  String userUID() {
    final auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    return uid ?? '';
  }

  void createUserByEmail({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String jobCategory,
    required File image,
    required context,
  }) async {
    try {
      // final credential =
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then(
        (value) async {
          final uid = Auth().userUID();
          var ref = FirebaseStorage.instance.ref();
          var imageRef = ref.child('users').child('$uid.jpg');
          var uploadedImage = await imageRef.putFile(image);
          var imageUrl = await uploadedImage.ref.getDownloadURL();
          FireStore().createUser(
            data: UserData(
              image: imageUrl,
              email: email,
              name: name,
              phone: phone,
              jobCategory: jobCategory,
            ),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return const TasksHome();
              },
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              'User Added Successfully',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            backgroundColor: Colors.black,
            showCloseIcon: true,
            // closeIconColor: white,
            // duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ));
          await Future.delayed(const Duration(seconds: 1));
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Password Error',
          desc: 'The password provided is too weak.',
          // descTextStyle: h5.merge(
          //   TextStyle(color: black),
          // ),
          btnCancelText: 'Try Again',
          // buttonsTextStyle: h5,
          btnCancelOnPress: () {},
        ).show();
      } else if (e.code == 'email-already-in-use') {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'email Error',
          desc: 'The account already exists for that email.',
          // descTextStyle: h5.merge(
          //   TextStyle(color: black),
          // ),
          btnCancelText: 'Try Again',
          // buttonsTextStyle: h5,
          btnCancelOnPress: () {},
        ).show();
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Error',
          desc: e.toString(),
          // descTextStyle: h5.merge(
          //   TextStyle(color: black),
          // ),
          btnCancelText: 'Try Again',
          // buttonsTextStyle: h5,
          btnCancelOnPress: () {},
        ).show();
      }
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'Error',
        desc: e.toString(),
        // descTextStyle: h5.merge(
        //   TextStyle(color: black),
        // ),
        btnCancelText: 'Try Again',
        // buttonsTextStyle: h5,
        btnCancelOnPress: () {},
      ).show();
    }
  }

//! LOGIN
  void userLogin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    // bool isLoding = true;
    try {
      // final credential =
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Successfully LogIn',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          backgroundColor: Colors.black,
          showCloseIcon: true,
          // closeIconColor: white,
          // duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ));
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return const TasksHome();
            },
          ),
        );
      });
      // return isLoding = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Email Error',
          desc: 'No user found for that email.',
          // descTextStyle: h5.merge(
          //   TextStyle(color: black),
          // ),
          btnCancelText: 'Try Again',
          // buttonsTextStyle: h5,
          btnCancelOnPress: () {},
        ).show();
        // return isLoding;
      } else if (e.code == 'wrong-password') {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Password Error',
          desc: 'Wrong password provided for that user.',
          // descTextStyle: h5.merge(
          //   TextStyle(color: black),
          // ),
          btnCancelText: 'Try Again',
          // buttonsTextStyle: h5,
          btnCancelOnPress: () {},
        ).show();
        // return isLoding;
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Error',
          desc: e.toString(),
          btnCancelText: 'Try Again',
          btnCancelOnPress: () {},
        ).show();
        // return isLoding;
      }
    }
  }

//! LOGOUT
  void userLogout({required context}) async {
    // signOut with google
    // GoogleSignIn googleSignIn = GoogleSignIn();
    // // await googleSignIn.signOut();
    // if (googleSignIn.currentUser != null) {
    //   await googleSignIn.disconnect();
    //   await FirebaseAuth.instance.signOut();
    // } else {
    // }
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return const LoginScreen();
      },
    ));
  }

  Future<bool> isRegisteredEmail(
      {required String email, required context}) async {
    try {
      List<String> signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      var isRegistered = signInMethods.isNotEmpty;
      return isRegistered;
    } catch (error) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'Email checking error',
        desc: error.toString(),
        descTextStyle: const TextStyle(color: Colors.black),

        btnCancelText: 'Try Again',
        buttonsTextStyle: const TextStyle(),
        // btnCancelOnPress: () {},
      ).show();
    }
    return false;
  }

  Future<void> resetPassword({required String email, required context}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (error) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'Email checking error',
        desc: error.toString(),
        descTextStyle: const TextStyle(color: Colors.black),
        btnCancelText: 'Try Again',
        buttonsTextStyle: const TextStyle(),
        // btnCancelOnPress: () {},
      ).show();
    }
  }

//! Delete
  Future<void> deleteUser({required context}) async {
    var uid = Auth().userUID();
    User? user = FirebaseAuth.instance.currentUser;
    var ref = FirebaseStorage.instance.ref();
    var imageRef = ref.child('users').child('$uid.jpg');
    try {
      if (user != null) {
        await user.delete();
      }

      await imageRef.delete();

      QuerySnapshot userTasks = await FirebaseFirestore.instance
          .collection('tasks')
          .where('uploadedBy', isEqualTo: uid)
          .get();

      // Delete all user Tasks
      for (var doc in userTasks.docs) {
        await FirebaseFirestore.instance
            .collection('tasks')
            .doc(doc.id)
            .delete();
      }
      QuerySnapshot userComment = await FirebaseFirestore.instance
          .collection('tasks')
          .where('uid', isEqualTo: uid)
          .get();

      // Delete all user comment
      for (var doc in userComment.docs) {
        await FirebaseFirestore.instance
            .collection('tasks')
            .doc(doc.id)
            .delete();
      }
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return const LoginScreen();
          },
        ),
      );
    } catch (e) {
      // ignore: avoid_print
      print('Error deleting user: $e');
    }
  }

}
