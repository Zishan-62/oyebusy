import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oyebusytask/viewprofile.dart';
import 'package:firebase_database/firebase_database.dart';

class profileSet extends StatefulWidget {
  const profileSet({super.key});

  @override
  State<profileSet> createState() => _profilesetState();
}

final FirebaseUser = FirebaseAuth.instance;
final userid = FirebaseUser.currentUser?.uid;

class _profilesetState extends State<profileSet> {
  TextEditingController Fname = TextEditingController();
  TextEditingController Lname = TextEditingController();
  TextEditingController Email = TextEditingController();
  TextEditingController Designation = TextEditingController();
  // TextEditingController User = TextEditingController();
  bool loading = false;

  // final databaseRef = FirebaseDatabase.instance.ref('Post');
  final _form = GlobalKey<FormState>();

  void _saveForm() {
    _form.currentState?.save();
  }

  void check() {
    print(userid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [IconButton(onPressed: () => check(), icon: Icon(Icons.abc))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(children: [
            // TextFormField(
            //   controller: User,
            //   decoration: InputDecoration(labelText: 'User Name'),
            // ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: Fname,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: Lname,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: Email,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: Designation,
              decoration: const InputDecoration(labelText: 'Designation'),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  Map<String, dynamic> json = {
                    "fname": Fname.text,
                    "lname": Lname.text,
                    "email": Email.text,
                    "desg": Designation.text,
                    'userId': userid
                  };
                  try {
                    CollectionReference docUser =
                        FirebaseFirestore.instance.collection('users');

                    await docUser.doc(userid).set(json);
                    Get.to(() => ViewProfile(user: userid.toString()));
                    // QuerySnapshot qs = await FirebaseFirestore.instance
                    //     .collection("users")
                    //     .where(FieldPath.documentId, isEqualTo: User.text)
                    //     .get();
                    // if (qs.docs.length > 0) {
                    //   await FirebaseFirestore.instance
                    //       .collection("users")
                    //       .doc(User.text)
                    //       .update(json);
                    // } else {
                    //   await FirebaseFirestore.instance
                    //       .collection("users")
                    //       .doc(User.text)
                    //       .set(json);
                    // }
                  } on FirebaseException catch (e) {
                    print(e);
                  } catch (error) {
                    print(error);
                  }

                  _saveForm();
                  // Get.off(() => const ViewProfile());
                },
                child: Container(
                    height: 40,
                    child: const Center(
                      child: Text(
                        'Submit',
                        style: TextStyle(fontSize: 20),
                      ),
                    )))
          ]),
        ),
      ),
    );
  }
}
