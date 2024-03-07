import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> cancelOrder(String orderId) async {
    try {
      CollectionReference postCollection = FirebaseFirestore.instance
          .collection('users_order_history').doc(user!.email).collection(
          'Items');

      // Fetch data from the furniture_list collection
      QuerySnapshot postData = await postCollection.where(
          'orderId', isEqualTo: orderId).get();

      // Update the status of the post
      for (QueryDocumentSnapshot doc in postData.docs) {
        await postCollection.doc(doc.id).update({
          "Status": "Cancelled",
        });
        // Get the productId associated with the cancelled order
        String productId = postData.docs.first['Products'][0]['productId'];

        // Update the status of the post in the furniture_list collection
        await updatePostStatus(productId);
      }

      print(" Order Cancelled successfully.");
    } catch (e) {
      print('Error cancelling post: $e');
    }
  }

  Future<void> updatePostStatus(String productId) async {
    try {
      CollectionReference postCollection =
      FirebaseFirestore.instance.collection('users_post_history');

      // Fetch data from the furniture_list collection
      QuerySnapshot postData = await postCollection.where(
          'productId', isEqualTo: productId).get();

      // Update the status of the post to "Cancelled"
      for (QueryDocumentSnapshot doc in postData.docs) {
        await postCollection.doc(doc.id).update({
          "status": "Cancelled",
        });
      }

      print("Post status updated to Cancelled successfully.");
    } catch (e) {
      print('Error updating post status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white24,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
        backgroundColor: Colors.white24,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            size: 36,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "My Orders",
          style: TextStyle(
            color: Color(0xff864942),
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoSerif',
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0), // Adjust the height of the line
          child: Divider(
            color: Colors.grey,
            thickness: 2.0, // Adjust the thickness of the line
           ),
         ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users_order_history')
            .doc(user!.email)
            .collection('Items')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          final orderHistory = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: orderHistory.length,
            itemBuilder: (BuildContext context, int index) {
              final orderData = orderHistory[index].data() as Map<
                  String,
                  dynamic>;
              final List<Map<String, dynamic>> orderItems = List<
                  Map<String, dynamic>>.from(orderData['Products']);

              return ListTile(
                title: Text('Order ID: ${orderData["orderId"]}'),
                trailing: Text('${orderData["Status"]}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Price: \$${orderData["Total Price"]}'),
                    Text('Delivery Address: ${orderData["deliveryAddress"]}'),
                    Text('Phone Number: ${orderData["phoneNumber"]}'),
                    Text('Payment Method: ${orderData["Payment Method"]}'),
                    Text('Products:'),
                    for (var item in orderItems) Text(
                        '${item["name"]} - ${item["price"]}'),
                    ElevatedButton(
                      onPressed: () {
                        // Implement cancellation logic here
                        cancelOrder(orderData["orderId"]);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Order Cancelled Successfully'),
                            backgroundColor: Colors.brown,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(primary: Color(
                          0xff864942),),
                      child: Text('Cancel Order', style: TextStyle(color: Color(
                          0xffffffff),
                          fontFamily: 'RobotoSerif',
                          fontSize: 16),),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}