

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Post_Controller extends StatefulWidget {
  @override
  _Post_ControllerState createState() => _Post_ControllerState();
}

class _Post_ControllerState extends State<Post_Controller> {
  TextEditingController ?_nameController;
  TextEditingController ?_priceController;
  TextEditingController ?_descriptionController;

  setDataToTextField(data){
    return  Column(
      children: [
        TextFormField(
          controller: _nameController = TextEditingController(text: data['name']),
        ),
        TextFormField(
          controller: _priceController = TextEditingController(text: data['price']),
        ),
        TextFormField(
          controller: _descriptionController = TextEditingController(text: data['description']),
        ),
        ElevatedButton(onPressed: ()=>updateData(), child: Text("Update"))
      ],
    );
  }


  updateData(){
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection("furniture_list");
    return _collectionRef.doc().update(
        {
          "name":_nameController!.text,
          "description":_descriptionController!.text,
          "price":_priceController!.text,
        }
    ).then((value) { print("Updated Successfully");
    updateDatainHistory();});
  }
  updateDatainHistory(){
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection("users_post_history");
    return _collectionRef.doc("productId").update(
        {
          "name":_nameController!.text,
          "description":_descriptionController!.text,
          "price":_priceController!.text,
        }
    ).then((value) => print("Updated Successfully"));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users_post_history").snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            var data = snapshot.data;
            if(data==null){
              return Center(child: CircularProgressIndicator(),);
            }
            return setDataToTextField(data);
          },

        ),
      )),
    );
  }
}