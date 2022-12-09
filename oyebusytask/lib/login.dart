import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:oyebusytask/viewprofile.dart';

import 'otp.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController phoneno = TextEditingController();
  bool isLoading = false;
  final auth = FirebaseAuth.instance;
  check() async {
    final user = auth.currentUser?.uid;
    print(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LOGIN',
        ),
        actions: [IconButton(onPressed: () => check(), icon: Icon(Icons.abc))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration:
                    InputDecoration(labelText: "Enter your phone number"),
                controller: phoneno,
              ),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });

                    auth.verifyPhoneNumber(
                        phoneNumber: phoneno.text,
                        verificationCompleted: (_) {
                          setState(() {
                            isLoading = false;
                          });
                        },
                        verificationFailed: (e) {
                          print(e.toString());
                          setState(() {
                            isLoading = false;
                          });
                        },
                        codeSent: (String verificationID, int? token) {
                          Get.to(() => otp(
                                verificationId: verificationID,
                              ));
                          setState(() {
                            isLoading = false;
                          });
                        },
                        codeAutoRetrievalTimeout: (e) {
                          print(e.toString());
                          setState(() {
                            isLoading = false;
                          });
                        });
                  },
                  child: Text("Login"))
            ]),
      ),
    );
  }
}
