import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kinbech_furnitureapp/pages/EditProfile.dart';

import '../components/custom_container_widget.dart';
import '../components/divider.dart';
import 'Login_page.dart';

class Profile_page extends StatefulWidget {
  const Profile_page({super.key});

  @override
  State<Profile_page> createState() => _Profile_pageState();
}

class _Profile_pageState extends State<Profile_page> {
  // late FirebaseUser user;
  // late User _currentUser;
  FirebaseAuth auth = FirebaseAuth.instance;
  final userRef = FirebaseFirestore.instance.collection("users").get();

  User? user;

  Future<void> signOutUser() async {
    await auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => loginpage()));
  }

  // get user
  void _getUser() {
    try {
      user = auth.currentUser;
    } catch (e) {
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUser();

  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffe3d8d0),
      appBar: AppBar(backgroundColor: Color(0xffe3d8d0), title:
      Text("Profile", style:
      TextStyle(color: Color(0xff864942),
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: 'RobotoSerif'),
      ),
          centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
            children: [
              ExpandDivider(),

              // container to greet the user and view image
              Container(
                margin: EdgeInsets.only(left: 10, right: 5, top: 5),
                height: size.height/8,
                width: size.width/1.06,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xff864942))
                ),
                child: Expanded(
                  child: Row(
                    children: [
                      Image.asset('assets/images/Female_Profile.png', height: 80,),
                      Text(' ${user!.email} !!',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xff864942)),overflow: TextOverflow.ellipsis,),
                      IconButton(onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context)=> MyProfile())); },
                          icon: Icon(Icons.edit)),
                    ],
                  ),
                ),
              ),

              ExpandDivider(),  // creates a kind of line named divider

              const SizedBox(height: 10,),

              // Container for the user order
              CustomContainerWidget(
                onTap: () {
                  // Navigate to another page when tapped
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => OrderHistory()),
                  // );
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

              // container for wishlist
              CustomContainerWidget(
                onTap: () {
                  // Navigate to another page when tapped
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => PostHistory()),
                  // );
                },
                rowcontent:  Row(
                  children: [
                    SizedBox(width: 10,),
                    Image.asset('assets/images/wishlist.png', height: 100,),
                    SizedBox(width: 15,),
                    Text('My Posts',style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.black, fontFamily: 'RobotoSerif',),),
                    SizedBox(width: 160,),
                    Icon(Icons.keyboard_arrow_right, size: 30),
                  ],
                ),
              ),

              // container for about app
              CustomContainerWidget(
                onTap: () {},
                rowcontent: Row(
                  children: [
                    SizedBox(width: 10,),
                    Image.asset('assets/images/about_us.png', height: 32,),
                    SizedBox(width: 15,),
                    Text('About Us',style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.black, fontFamily: 'RobotoSerif',),),
                    SizedBox(width: 170,),
                    Icon(Icons.keyboard_arrow_right, size: 30),
                  ],
                ),
              ),

              // container for contact us
              CustomContainerWidget(
                onTap:  () {
                  // Navigate to another page when tapped
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => ContactUsPage()),
                  // );
                },
                rowcontent:  Row(
                  children: [
                    SizedBox(width: 10,),
                    Image.asset('assets/images/Phone_Message.png', height: 60,),
                    SizedBox(width: 15,),
                    Text('Contact Us',style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.black, fontFamily: 'RobotoSerif',),),
                    SizedBox(width: 150,),
                    Icon(Icons.keyboard_arrow_right, size: 30),
                  ],
                ),
              ),

              // container for logout the application
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
            ]
        ),
      ),
    );
  }
}
