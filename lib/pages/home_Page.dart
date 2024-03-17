import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:furnitureapp/pages/Cart.dart';
import 'package:furnitureapp/pages/Notifications.dart';
import 'package:furnitureapp/pages/search.dart';

import 'productDetail.dart';
import 'package:furnitureapp/pages/Wishlist_page.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  List<Map<String, dynamic>> _products = [];
  var _firestoreInstance = FirebaseFirestore.instance;
  List<String> _carouselImages = [];
  var _dotPosition = 0;
  String _selectedCategory = "";
  int _selectedCategoryIndex = 0; // to track the selected category index

  List<Map<String, dynamic>> _selectedCategoryProducts = [];// Track the selected category

  fetchCarouselImages() async {
    QuerySnapshot qn = await _firestoreInstance.collection("carousel_Images").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _carouselImages.add(qn.docs[i]["image_path"]);
      }
    });

    return qn.docs;
  }
  fetchProducts() async {
    QuerySnapshot qn = await _firestoreInstance.collection("furniture_list").orderBy('publishedDate').get();
    List<Map<String, dynamic>> products = [];

    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        products.add({
          "name": qn.docs[i]["name"],
          "description": qn.docs[i]["description"],
          "price": qn.docs[i]["price"],
          "image": qn.docs[i]["image"],
          "createdBy": qn.docs[i]["createdBy"],
          "productId":qn.docs[i]["productId"],
          "category": qn.docs[i]["category"], // Add category to products
        });
      }
      _products = products;
    });

    return qn.docs;
  }

  @override
  void initState() {
    fetchCarouselImages();
    fetchProducts();
    _selectedCategory = "All products"; // Set the default category
    super.initState();
    //for android mobile
    //   const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings("@mipmap/ic_launcher");
    //
    //   const InitializationSettings initializationSettings = InitializationSettings(
    //     android: androidInitializationSettings
    //   );
    //
    //   flutterLocalNotificationsPlugin.initialize(
    //       initializationSettings,
    //       onDidReceiveBackgroundNotificationResponse: (dataYouNeedToUseWhenNotificationsIsClicked){});
    //   Stream<QuerySnapshot<Map<String, dynamic>>> notificationStream =
    //   FirebaseFirestore.instance.collection('furniture_list').snapshots();
    //   notificationStream.listen((event){
    //     if(event.docs.isEmpty){
    //       return;
    //     }
    //     else{
    //
    //     }
    //   });
    // }
    // void showNotifications(){
    //
    // }
  }
  Future<List<Map<String, dynamic>>> getDataFromFirestore() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('furniture_list').get();
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
  Future<String> downloadImage(String images) async {
    Reference ref = FirebaseStorage.instance.ref().child(images);
    return await ref.getDownloadURL();
  }
  var imageURL = 'https://firebasestorage.googleapis.com/v0/b/furniqo.appspot.com/o/images%2F1703559803796.jpg?alt=media&token=3582b168-e9e5-46ea-919b-17a78248d37d';

  final Stream<QuerySnapshot> _data = FirebaseFirestore.instance.collection('furniture_list').snapshots();


  @override
  Widget build(BuildContext context) {
// Update selected category products when category changes
    if (_selectedCategory == 'All products') {
      _selectedCategoryProducts = _products;
    } else {
      _selectedCategoryProducts = _products
          .where((product) => product["category"].toLowerCase() == _selectedCategory.toLowerCase())
          .toList();
    }
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xfffcfcfc),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartPage()),
                    );
                  },
                  icon: Icon(
                    Icons.shopping_cart,
                    size: 35,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Notifications()),
                    );
                  },
                  icon: Icon(
                    Icons.notifications,
                    size: 35,
                  ),
                ),
              ],
            ),
            Container(
              height: size.height / 10,
              width: size.width / 1.1,
              child: Text(
                'Eco-Friendly \n Collection',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 30, fontFamily: 'RobotoSerif', color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoSearchTextField(onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => searchpage()));
              }),
            ),
            AspectRatio(
              aspectRatio: 3.5,
              child: CarouselSlider(
                items: _carouselImages
                    .map((item) => Padding(
                  padding: const EdgeInsets.only(left: 3, right: 3),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(item),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ))
                    .toList(),
                options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: true,
                  viewportFraction: 0.8,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  onPageChanged: (val, carouselPageChangedReason) {
                    setState(() {
                      _dotPosition = val;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            DotsIndicator(
              dotsCount: _carouselImages.length == 0 ? 1 : _carouselImages.length,
              position: _dotPosition.toDouble(),
              decorator: DotsDecorator(
                activeColor: Colors.black,
                color: Colors.black.withOpacity(0.5),
                spacing: EdgeInsets.all(2),
                activeSize: Size(8, 8),
                size: Size(6, 6),
              ),
            ),
            Container(
                height: size.height/20,
                width: size.width/1.05,
                child: Text('Categories', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'RobotoSerif'),textAlign: TextAlign.start,)),
            Container(
              height: size.height/20,
              width: size.width/1.04,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 40,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),border: Border.all(color: Colors.black),  color: _selectedCategoryIndex == 0 ? Colors.brown : Colors.white,
                        ),
                        child: buildCategoryButton('All products', 0)),
                    SizedBox(width: 10,),
                    Container(
                        height: 40,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),border: Border.all(color: Colors.black), color: _selectedCategoryIndex == 1 ? Colors.brown: Colors.white,),
                        child: buildCategoryButton('chair', 1)),
                    SizedBox(width: 10,),
                    Container(
                        height: 40,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),border: Border.all(color: Colors.black), color: _selectedCategoryIndex == 2 ? Colors.brown : Colors.white,),
                        child: buildCategoryButton('sofa', 2)),
                    SizedBox(width: 10,),
                    Container(
                        height: 40,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.black),color: _selectedCategoryIndex == 3 ? Colors.brown : Colors.white,),
                        child: buildCategoryButton('cupboard' ,3)),
                    SizedBox(width: 10,),
                    Container(
                        height: 40,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),border: Border.all(color: Colors.black), color: _selectedCategoryIndex == 4 ? Colors.brown : Colors.white,),
                        child: buildCategoryButton('table' ,4)),
                    SizedBox(width: 10,),
                    Container(
                        height: 40,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),border: Border.all(color: Colors.black), color: _selectedCategoryIndex == 5 ? Colors.brown : Colors.white,),
                        child: buildCategoryButton('bed' ,5)),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategoryButton(String category, int index) {
    return TextButton(
      onPressed: () {
        setState(() {
          _selectedCategory = category;
          _selectedCategoryIndex = index; // Set the selected category index


        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          _selectedCategoryIndex == index ? Colors.brown : Colors.white,
        ),
      ),
      child: Text(category, style:TextStyle(color: _selectedCategoryIndex == index ? Colors.white : Colors.black, fontSize: 15, fontFamily: 'RobotoSerif') ,),
    );
  }
}

var imageURL = 'https://firebasestorage.googleapis.com/v0/b/furniqo.appspot.com/o/images%2F1704032136183.jpg?alt=media&token=a0159495-6059-4c6f-a508-48f6bd6a4a80';