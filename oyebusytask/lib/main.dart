import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:oyebusytask/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:oyebusytask/splash_screen.dart';
import 'package:oyebusytask/viewprofile.dart';

import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: "SplashScreen",
      routes: {
        'profile': (context) => profileSet(),
        'login': (context) => login(),
        'SplashScreen': (context) => SplashScreen()
      },
    );
  }
}
