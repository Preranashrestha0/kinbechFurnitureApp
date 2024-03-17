import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

import '../components/TextFormField.dart';
import 'onBoardingpage.dart';
class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();

}
class _PostPageState extends State<PostPage> {
  //for notifications
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //textediting controllers
  final _namecontroller = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _category = TextEditingController();
  final _productCondition = TextEditingController();

  //list of categories
  List<String> _categories = ['Chair', 'Sofa', 'Cupboard', 'Table', 'Bed'];
  String _selectedCategory = 'Chair'; // Default category
  String? _categoryError;

  //for photo
  File? _photo;
  //reference of imageppicker
  final ImagePicker _picker = ImagePicker();
  //reference of curentUser
  User? user = FirebaseAuth.instance.currentUser;

  //picking image form gallery
  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  //picking image from camera
  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  //uploading a file
  Future uploadFile() async {
    try {
      if (_photo == null) {
        print('No image selected.');
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
            SnackBar(
              content: Text(
                  'No image selected'),
            )
        );
        return;
      }

      var productId = DateTime.now().millisecondsSinceEpoch.toString(); // Generate productId
      var publishedDate = DateTime.now().toString(); // Generate publishedDate

      var imageName = productId;
      var storageRef = firebase_storage.FirebaseStorage.instance.ref().child('images/$imageName.jpg');
      var uploadTask = storageRef.putFile(_photo!);
      var downloadUrl = await (await uploadTask).ref.getDownloadURL();

      // Prepare data for Furniture list
      Map<String, dynamic> furnitureListData = {
        "name": _namecontroller.text,
        "createdBy": user!.email.toString(),
        "description" : _descriptionController.text,
        "price": _priceController.text,
        "status" : "Available",
        "category":_selectedCategory.toString(),
        "productCondition": _productCondition.text,
        'publishedDate':publishedDate,
        'productId': productId,
        "image": downloadUrl.toString()
      };

      // Prepare data for post history
      Map<String, dynamic> postHistoryData = {
        "productId" : productId,
        "name": _namecontroller.text,
        "description": _descriptionController.text,
        "price": _priceController.text,
        "createdBy": user!.email.toString(),
        "image": downloadUrl.toString(),
        "status" : "A vailable",
        "category": _selectedCategory.toString(),
        "productCondition": _productCondition.text,
        "publishedDate": publishedDate,
        "orderedBy": " ",
        "deliveryAddress" : " ",
        "customerPhoneNo": " ",
      };

      // Add data to 'furniture_list' collection
      await FirebaseFirestore.instance.collection('furniture_list').add(furnitureListData);

      // Add data to 'users_post_history' collection
      await FirebaseFirestore.instance.collection('users_post_history').add(postHistoryData);

      print("Data added to both collections successfully.");
    } catch (e) {
      print('Error occurred: $e');
    }
  }
  void _showCategoryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: _categories.map((String category) {
                return ListTile(
                  title: Text(category),
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                      _category.text = category;
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //for the notification icon
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings("@mipmap/app_logo");

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: androidInitializationSettings,
      iOS: null,
      macOS: null,
      linux: null,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse){
        switch(notificationResponse.notificationResponseType){
          case NotificationResponseType.selectedNotification:
            break;
          case NotificationResponseType.selectedNotificationAction:
            break;
        }
      },
    );
    Stream<QuerySnapshot<Map<String, dynamic>>> notificationStream =
    FirebaseFirestore.instance.collection('furniture_list').snapshots();
    notificationStream.listen((event) {
      if(event.docs.isEmpty){
        return;
      }
      showNotifications(event.docs.first);
    });
  }
  void showNotifications(QueryDocumentSnapshot<Map<String, dynamic>> event){
    if(_namecontroller.text.isEmpty || _descriptionController.text.isEmpty){
      return;
    }
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('ScheduleNotification001', 'Notify me',
        importance: Importance.high);
    const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails);
    flutterLocalNotificationsPlugin.show(01, _namecontroller.text,_descriptionController.text, notificationDetails);

  }
  void onNotificationTap(){
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffe3d8d0),
      appBar: AppBar(
        backgroundColor: Color(0xffe3d8d0),
        title: Text(
          "Sell your Furniture",
          style: TextStyle(
              fontFamily: 'RobotoSerif',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.brown
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            MyTextFormField(
              controller: _namecontroller,
              hintText: 'Enter the name of the product',
            ),
            SizedBox(height: 10,),
            MyTextFormField(
              controller: _descriptionController,
              hintText: 'Enter the description of the product',
            ),
            SizedBox(height: 10,),
            MyTextFormField(
              controller: _priceController,
              hintText: 'Enter the price of the product',
            ),
            SizedBox(height: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.brown),
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xfff2eded),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue!;
                          _categoryError = null; // Clear the error when the user selects a category
                        });
                      },
                      items: _categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              category,
                              style: TextStyle(fontSize: 16), // Adjust the font size as needed
                            ),
                          ),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        errorText: _categoryError,
                        border: InputBorder.none, // Remove the border
                        contentPadding: EdgeInsets.zero, // Remove the content padding
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            MyTextFormField(controller: _productCondition, hintText: 'Enter the product Condition'),
            SizedBox(height: 10,),
            Center(
              child: GestureDetector(
                onTap: () async {
                  _showPicker(context);
                },
                child: Container(
                  child: _photo != null
                      ? ClipRRect(
                    child: Image.file(
                      _photo!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.fitHeight,
                    ),
                  )
                      : Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    width: 100,
                    height: 100,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: size.height / 15,
              width: size.width / 2,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Color(0xff864942)),
              child: GestureDetector(
                onTap: () async {
                  if (_descriptionController.text.isNotEmpty &&
                      _namecontroller.text.isNotEmpty &&
                      _priceController.text.isNotEmpty &&
                      _photo != null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirmation'),
                          content: Text("Are you sure you want to submit these details?"),
                          actions: [
                            TextButton(
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Colors.amber),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              onPressed: () {
                                // Upload image file to Firebase Storage
                                uploadFile();
                                showNotifications; // Corrected line
                                Navigator.of(context).pop();
                                // Show success SnackBar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Post Created Successfully'),
                                    backgroundColor: Colors.brown,
                                  ),
                                );
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnBoardingPage()));
                              },
                              child: Text("Submit", style: TextStyle(color: Colors.amber)),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    String errorMessage = _photo == null
                        ? 'Please select an image.'
                        : 'Please fill in all the required fields.';

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(errorMessage),
                        backgroundColor: Colors.brown,
                      ),
                    );
                  }
                },

                child: Center(child: Text('Submit Details', style: TextStyle(color: Color(0xffffffff), fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Inika'),)),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: [
                new ListTile(
                  leading: new Icon(Icons.photo_library),
                  title: new Text('Gallery'),
                  onTap: () {
                    imgFromGallery();
                    Navigator.of(context).pop();
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}