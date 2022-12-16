import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
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
  String imageUrl = '';
  // final databaseRef = FirebaseDatabase.instance.ref('Post');
  final _form = GlobalKey<FormState>();

  void _saveForm() {
    _form.currentState?.save();
  }

  void check() {
    print("This is the url of image: " + image!.path.toString());
  }

  File? image;
  final picker = ImagePicker();

  Future getimage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedImage != null) {
        image = File(pickedImage.path);
      } else {
        return;
      }
    });
  }

  Future getgallery() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        image = File(pickedImage.path);
      } else {
        return;
      }
    });
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
            Center(
              child: Stack(children: [
                CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 60,
                    child: ClipOval(
                        child: Container(
                      height: 120.0,
                      width: 120.0,
                      child: image == null
                          ? Image.asset(
                              'assets/images/profile.png',
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              image!,
                              fit: BoxFit.values[1],
                            ),
                    ))),
                Positioned(
                    bottom: 0,
                    right: 5,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(width: 2, color: Colors.blue)),
                      child: InkWell(
                          onTap: () => {
                                showModalBottomSheet(
                                    context: context,
                                    builder: ((builder) => picking()))
                              },
                          child: Icon(
                            Icons.edit,
                            color: Colors.blue,
                          )),
                    ))
              ]),
            ),

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
                  try {
                    CollectionReference docUser =
                        FirebaseFirestore.instance.collection('users');

                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceDirImages =
                        referenceRoot.child('images');
                    String uniqueFileName =
                        DateTime.now().millisecondsSinceEpoch.toString();

                    // Create a ref for the image to be stored
                    Reference referenceImageToUplode =
                        referenceDirImages.child(uniqueFileName);
                    try {
                      await referenceImageToUplode.putFile(File(image!.path));
                       imageUrl =
                          await referenceImageToUplode.getDownloadURL();
                    } catch (e) {
                      print("This error is from image picker:$e");
                    }
                    // to store a file
                  Map<String, dynamic> json = {
                    "fname": Fname.text,
                    "lname": Lname.text,
                    "email": Email.text,
                    "desg": Designation.text,
                    'userId': userid,
                    'image':imageUrl
                  };

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

  Widget picking() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(children: [
        Text(
          "Choose Profile Photo",
          style: TextStyle(fontSize: 20, fontFamily: "Montserrat"),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
                onPressed: () {
                  getimage();
                },
                icon: Icon(Icons.camera, color: Colors.blue),
                label: Text('Camera',
                    style: TextStyle(fontSize: 20, fontFamily: "Montserrat"))),
            TextButton.icon(
                onPressed: () {
                  getgallery();
                },
                icon: Icon(
                  Icons.image,
                  color: Colors.blue,
                ),
                label: Text('Gallery',
                    style: TextStyle(fontSize: 20, fontFamily: "Montserrat")))
          ],
        )
      ]),
    );
  }
}
