import 'package:companies_tasks/view/screens/auth/login_screen.dart';
import 'package:companies_tasks/view/screens/tasks.dart';
import 'package:companies_tasks/view_models/edit_profile_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'view_models/tasks_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
     MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TasksViewModel()),
        ChangeNotifierProvider(create: (context) => EditViewModel()),
      ],
      child: MyApp(),
    ),
    );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final User? currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tasks',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            color: Colors.black, iconTheme: IconThemeData(color: Colors.white)),
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 252, 252)),
        useMaterial3: true,
      ),
      home: currentUser != null ? const TasksHome() : const LoginScreen(),
    );
  }
}
