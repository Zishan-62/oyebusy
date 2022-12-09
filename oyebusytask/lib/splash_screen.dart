import 'package:flutter/material.dart';
import 'package:oyebusytask/services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashscreen = SplashServices();

  void initState() {
    super.initState();
    splashscreen.isLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text(
        "OyeBusy",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      )),
    );
  }
}
