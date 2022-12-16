import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oyebusytask/profile.dart';
import 'package:oyebusytask/viewprofile.dart';

class otp extends StatefulWidget {
  final String verificationId;
  otp({super.key, required this.verificationId});

  @override
  State<otp> createState() => _otpState();
}

class _otpState extends State<otp> {
  TextEditingController otp = TextEditingController();
  TextEditingController phoneno = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("otp")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Enter otp'),
            controller: otp,
          ),
          SizedBox(
            height: 40,
          ),
          ElevatedButton(
              onPressed: () async {
                final credentials = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: otp.text.toString());

                try {
                  final auth = FirebaseAuth.instance;
                  await auth.signInWithCredential(credentials);
                  final userexists = auth.currentUser!.uid;
                  final doc = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userexists)
                      .get();
                  // print("ye check karne k liea :"+doc.toString());
                  final bool doesDocExists = doc.exists;
                  print(doesDocExists);
                  // print("This is the id......" + widget.verificationId);
                  if (doesDocExists == false) {
                    print("This is from otp : $userexists");
                    Get.off(() => profileSet());

                    // Get.off(() => ViewProfile());
                  } else {
                    Get.off(() => ViewProfile(
                          user: userexists.toString(),
                        ));
                  }
                } catch (e) {
                  print(e.toString());
                }
              },
              child: Text('Login'))
        ],
      ),
    );
  }
}
