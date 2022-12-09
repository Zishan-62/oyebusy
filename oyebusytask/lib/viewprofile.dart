import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oyebusytask/login.dart';

class ViewProfile extends StatefulWidget {
  final String user;
  const ViewProfile({super.key, required this.user});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  final auth = FirebaseAuth.instance;

  // late final user = auth.currentUser?.uid;
  bool isVisible = false;
  Map<String, dynamic>? data;
  late String Fname = '';
  late String Lname = '';
  late String Email = '';
  late String desg = '';

  @override
  void initState() {
    super.initState();
    getData();
    // medicalHistory = [];
    // SurgicalHistory = [];
  }

  getData() async {
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(widget.user).get();
    print('Check Karne k liea: ' + widget.user);
    try {
      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
        setState(() {
          Fname = data?["fname"];
          Lname = data?["lname"];
          Email = data?["email"];
          desg = data?["desg"];
          print("This is the name" + Fname);
          print("This is the name" + Lname);
          print("This is the name" + Email);
          // print("This is the user " + user.toString());
        });
      }
    } on FirebaseException catch (e) {
      print(e);
    } catch (error) {
      print(error);
    }
  }

  signOut() async {
    await auth.signOut();
    Get.off(() => login());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Profile '),
        actions: [
          IconButton(
            icon: Icon(Icons.logout_outlined),
            onPressed: () {
              signOut();
            },
          )
        ],
      ),
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('First Name: $Fname'),
              Text("Last Name: " + Lname),
              Text("Email : $Email"),
              Text("designation : $desg")
            ]),
      ),
    );
  }
}
