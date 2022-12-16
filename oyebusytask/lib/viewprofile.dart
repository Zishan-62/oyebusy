import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:oyebusytask/login.dart';
import 'package:oyebusytask/upiii.dart';
import 'package:pay/pay.dart';

class ViewProfile extends StatefulWidget {
  final String user;
  const ViewProfile({super.key, required this.user});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  final auth = FirebaseAuth.instance;
  final _paymentItems = [
    PaymentItem(
      label: 'Total',
      amount: '99.99',
      status: PaymentItemStatus.final_price,
    )
  ];
  void onGooglePayResult(paymentResult) {
    print(paymentResult);
    // Send the resulting Google Pay token to your server or PSP
  }

  // late final user = auth.currentUser?.uid;
  bool isVisible = false;
  Map<String, dynamic>? data;
  late String Fname = '';
  late String Lname = '';
  late String Email = '';
  late String desg = '';
  late String imageUrl = '';

  @override
  void initState() {
    super.initState();
    initPlatformState();
    getData();
    // medicalHistory = [];
    // SurgicalHistory = [];
  }

  static final String oneSignalAppId = "e67f1ea3-e411-487b-ba69-d9d7c88f8ea3";

  Future<void> initPlatformState() async {
    OneSignal.shared.setAppId(oneSignalAppId);
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
          imageUrl = data?["image"];
          print("This is the name" + Fname);
          print("This is the name" + Lname);
          print("This is the name" + Email);
          print('this is image : $imageUrl');
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
        automaticallyImplyLeading: false,
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
              SizedBox(height: 150, width: 150, child: Image.network(imageUrl)),
              Text('First Name: $Fname'),
              Text("Last Name: " + Lname),
              Text("Email : $Email"),
              Text("designation : $desg"),
              // GooglePayButton(
              //   // height: 80,
              //   paymentConfigurationAsset:
              //       'json/sample_payment_configuration.json',
              //   paymentItems: _paymentItems,

              //   // style: GooglePayButtonStyle.black,
              //   type: GooglePayButtonType.pay,
              //   onPaymentResult: onGooglePayResult,
              // ),
              ElevatedButton(
                  onPressed: () {
                    Get.to(upiii());
                  },
                  child: Text('pay with UPI')),
            ]),
      ),
    );
  }
}
