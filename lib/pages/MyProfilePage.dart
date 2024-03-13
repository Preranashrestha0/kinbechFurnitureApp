import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kinbech_furnitureapp/components/custom_container_widget.dart';
import 'package:kinbech_furnitureapp/pages/Login_page.dart';
import 'package:kinbech_furnitureapp/pages/Order_history_page.dart';

class MyProfilePage extends StatefulWidget {

  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final userRef = FirebaseFirestore.instance.collection("users").get();

  User? user;

  Future<void> signOutUser() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => loginpage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // container for logout the application
      body: Column(
        children: [
          CustomContainerWidget(
            onTap: () {
              // Navigate to another page when tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderHistory()),
              );
            },
            rowcontent: Row(
              children: [
                SizedBox(width: 10,),
                Image.asset('assets/images/icon_order.png', height: 40,),
                SizedBox(width: 15,),
                Text('My Orders',style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.black, fontFamily: 'RobotoSerif',),),
                SizedBox(width: 160,),
                Icon(Icons.keyboard_arrow_right, size: 30),
              ],
            ),
          ),
      // container for logout page
      CustomContainerWidget(
        onTap: signOutUser,
        rowcontent: Row(
          children: [
            SizedBox(width: 10,),
            Image.asset('assets/images/log_out.png', height: 26,),
            SizedBox(width: 15,),
            Text('Log Out',style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.black, fontFamily: 'RobotoSerif',),),


            ],
          ),
         ),
        ],
      ),
    );
  }
}