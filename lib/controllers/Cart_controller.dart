import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kinbech_furnitureapp/pages/product_detail.dart';

num totalPriceFinal = 0;
class Cart_ControllerPage extends StatefulWidget {
  const Cart_ControllerPage({super.key});
  @override
  _Cart_ControllerPageState createState() => _Cart_ControllerPageState();
}

class _Cart_ControllerPageState extends State<Cart_ControllerPage> {
  @override
  void initState() {
    calculatingTotalPrice();
    super.initState();
  }
  //for calculating total
  calculatingTotalPrice() async {
    num totalPrice = 0;
    final firestoreInstance = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestoreInstance
        .collection("users_cart_items")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("Items")
        .get();

    for (int i = 0; i < qn.docs.length; i++) {
      totalPrice = totalPrice + num.parse(qn.docs[i]["price"]);
      totalPriceFinal = totalPrice;
    }
    setState(() {});
  }

  //for fetching data
  fetchCartData(String collectionName) {
    num lastElement = 0;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(collectionName)
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("Items")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something is wrong"),
          );
        }

        return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data == null ? 0 : snapshot.data!.docs.length,
            itemBuilder: (_, index) {
              DocumentSnapshot _docSnapshot = snapshot.data!.docs[index];
              lastElement = snapshot.data!.docs.length;

              return Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ProductDetails(_docSnapshot)));
                    },
                    child: Card(
                      elevation: 5,
                      child: ListTile(
                        leading: Image(image: NetworkImage(_docSnapshot['image']),),
                        title: Text(
                          " ${_docSnapshot['name']}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        subtitle: Text(
                          "\$ ${_docSnapshot['price']}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.brown),
                        ),
                        trailing: GestureDetector(
                          child: const CircleAvatar(
                            child: Icon(Icons.delete, color: Colors.brown,),
                          ),
                          onTap: () {
                            FirebaseFirestore.instance
                                .collection(collectionName)
                                .doc(FirebaseAuth.instance.currentUser!.email)
                                .collection("Items")
                                .doc(_docSnapshot.id)
                                .delete()
                                .then((value) => calculatingTotalPrice());
                          },
                        ),
                      ),
                    ),
                  ),
                  if (index == lastElement - 1)
                    Text(
                      "Total Price :  \$ $totalPriceFinal",
                      style: TextStyle(
                        color: Colors.brown, fontSize: 18, fontFamily: 'RobotoSerif',),
                    ),
                ],
              );
            });
      },
    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xffe3d8d0),
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              child: fetchCartData("users_cart_items"),
            ),
          ),

        ],
      ),
    );
  }
}