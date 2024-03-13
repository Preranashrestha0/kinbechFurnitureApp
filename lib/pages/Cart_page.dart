import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kinbech_furnitureapp/controllers/Cart_controller.dart';
import 'package:kinbech_furnitureapp/pages/Checkout.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xffe3d8d0),
      appBar: AppBar(
        backgroundColor: Color(0xffe3d8d0),
        title: Text(
          'My Cart',style: TextStyle(fontSize: 20, fontFamily: 'RobotoSerif', color: Colors.brown),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
                child: Cart_ControllerPage()
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.brown, borderRadius: BorderRadius.circular(10)),
            child: TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> CheckOutScreen()));
            },
                child: Text('Check Out', style: TextStyle(color: Colors.white, fontFamily: 'RobotoSerif', fontSize: 20),)),
          )

        ],
      ),
    );
  }
}