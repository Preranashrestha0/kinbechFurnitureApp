import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  var _product;
  ProductDetails(this._product);

  @override
  State<ProductDetails> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetails> {
  bool isInFavorites = false; // Track whether the product is in favorites

  Future addToCart() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _ref =
    FirebaseFirestore.instance.collection('users_cart_items');

    // Check if the product is already in the cart
    var existingProduct = await _ref
        .doc(currentUser!.email)
        .collection('Items')
        .where("name", isEqualTo: widget._product['name'])
        .get();

    // Product is not in the cart, add it to the cart
    await _ref.doc(currentUser.email).collection('Items').doc().set({
      "name": widget._product["name"],
      "description": widget._product["description"],
      "price": widget._product["price"],
      "image": widget._product["image"],
      "createdBy": widget._product["createdBy"],
      "productId" : widget._product["productId"]
    });

    print("Added to cart");

    // Show success SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added to Cart'),
        backgroundColor: Colors.brown,
      ),
    );
  }



  Future addToFavorite() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _ref =
    FirebaseFirestore.instance.collection('user_favorite_items');

    // Check if the product is already in favorites
    var existingProduct = await _ref
        .doc(currentUser!.email)
        .collection('Items')
        .where("name", isEqualTo: widget._product['name'])
        .get();
    // Product is not in favorites, add it to favorites
    await _ref.doc(currentUser.email).collection('Items').doc().set({
      "name": widget._product["name"],
      "description": widget._product["description"],
      "price": widget._product["price"],
      "image": widget._product["image"],
      "createdBy": widget._product["createdBy"],
    });

    // Show success SnackBar for addition
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added to Favorites'),
        backgroundColor: Colors.brown,
      ),
    );
  }
  //to remove product from favorites
  Future removeFromFavorites() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _ref =
    FirebaseFirestore.instance.collection('user_favorite_items');

    // Check if the product is already in favorites
    var existingProduct = await _ref
        .doc(currentUser!.email)
        .collection('Items')
        .where("name", isEqualTo: widget._product['name'])
        .get();

    if (existingProduct.docs.isNotEmpty) {
      // Product is already in favorites, delete it
      await _ref
          .doc(currentUser.email)
          .collection('Items')
          .doc(existingProduct.docs.first.id)
          .delete();

      // Show success SnackBar for removal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Removed from Favorites'),
          backgroundColor: Colors.brown,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffe3d8d0),
      appBar: AppBar(
        backgroundColor: Color(0xffe3d8d0),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Color(0xff864942),
            child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
          ),
        ),
        actions: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("user_favorite_items")
                .doc(FirebaseAuth.instance.currentUser!.email)
                .collection("Items")
                .where("name", isEqualTo: widget._product['name'])
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Text("");
              }

              // Update the isInFavorites variable based on whether the product is in favorites
              isInFavorites = snapshot.data.docs.isNotEmpty;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  backgroundColor: Color(0xff864942),
                  child: IconButton(
                    onPressed: () {
                      // Check if the product is in favorites
                      if (isInFavorites) {
                        // If in favorites, remove it
                        removeFromFavorites();
                      } else {
                        // If not in favorites, add it
                        addToFavorite();
                      }
                    },
                    icon: isInFavorites
                        ? Icon(
                      Icons.favorite,
                      color: Colors.white,
                    )
                        : Icon(
                      Icons.favorite_outline,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: size.height/2.5,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            widget._product["image"],
                            fit: BoxFit.fitWidth,
                          )),
                    ),
                  ),
                  Text(
                    widget._product['name'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  Text(widget._product['description']),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "\$ ${widget._product['price'].toString()}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xff864942),
                    ),
                  ),
                  Text(widget._product['createdBy']),
                  Divider(),
                  Center(
                    child: SizedBox(
                      width: size.width / 2.2,
                      height: size.height / 15,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("users_cart_items")
                            .doc(FirebaseAuth.instance.currentUser!.email)
                            .collection("Items")
                            .where("name", isEqualTo: widget._product['name'])
                            .snapshots(),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.data == null) {
                            return Text("");
                          }
                          return ElevatedButton(
                            onPressed: () {
                              snapshot.data.docs.length == 0
                                  ? addToCart()
                                  : print("Already Added");
                            },
                            child: Text(
                              "Add to cart",
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff864942),
                              elevation: 3,
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
