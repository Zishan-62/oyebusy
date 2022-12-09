import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:oyebusytask/viewprofile.dart';

import '../login.dart';

class SplashServices {
  void isLogin() {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      {
        Timer(
            Duration(seconds: 3),
            (() => Get.off(() => ViewProfile(
                  user: user.uid,
                ))));
      }
    } else {
      Timer(Duration(seconds: 3), (() => Get.off(() => login())));
    }
  }
}
