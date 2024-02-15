import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ordersHistory extends StatefulWidget {
  final String displayName;

  const ordersHistory(
    this.displayName, {
    Key? key,
  }) : super(key: key);

  //build constructor for ordershistory


  @override
  State<ordersHistory> createState() => _ordersHistoryState();
}

class _ordersHistoryState extends State<ordersHistory> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Orders History'),
        title: Text("Order History (${widget.displayName})"),
        
        centerTitle: true,
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .where("userName", isEqualTo: widget.displayName)
              // .orderBy('timestamp', descending: true) // requires composite  index in firestore, not working
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            List<Widget> orderTiles =
                snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              List<Map<String, dynamic>> items =
                  List<Map<String, dynamic>>.from(data['items']);

              var orderId = data['orderId'];
              DateTime timestampfromDB = data['timestamp'].toDate();
              //formate timestamp into readable
              String formattedDateTime =
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(timestampfromDB);

              return Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Container(
                  child: Column(children: [
                    // SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        details(data, formattedDateTime, items);
                        print(orderId);
                      },
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: Colors.blueAccent),
                        ),

                        title: Text('Order ID: ${data['orderId']}'),
                        subtitle: Text(
                            'Total Amount: ${data['totalAmount']}\n$formattedDateTime'),
                        // Add more details as needed
                      ),
                    ),
                  ]),
                ),
              );
            }).toList();

            return ListView(
              children: orderTiles,
            );
          },
        ),
      ),
    );
  }

  details(
      Map<String, dynamic> data, timestamp_, List<Map<String, dynamic>> items) {
    var orderId = data['orderId'];
    var userName = data['userName'];
    var fullName = data['fullName'];
    var address = data['address'];
    var city = data['city'];
    var phoneNumber = data['phoneNumber'];
    var userEmail = data['userEmail'];
    var totalAmount = data['totalAmount'];
    var timestamp_1 = timestamp_;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    //decorate container borders with color
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Order ID: ${orderId}'),
                          Text('User Name: ${userName}'),
                          Text('Full Name: ${fullName}'),
                          Text('Address: ${address}'),
                          Text('City: ${city}'),
                          Text('Phone Number: ${phoneNumber}'),
                          Text('User Email: ${userEmail}'),
                          Text('Total Amount: ${totalAmount.toString()}'),
                          Text('TIme Stamp :  $timestamp_1'),
                        ]),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Order Items:',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue),
                  ),
                  Column(
                    children: items.map((item) {
                      return ListTile(
                        title: Text(item['title']),
                        subtitle: Text(
                            'Category: ${item['category']}\nSize: ${item['size']}\nQuantity: ${item['qtySold'].toString()}'),
                      );
                    }).toList(),
                  ),
                  Container(
                      alignment: AlignmentDirectional(0.95, 0.95),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close_rounded,
                          color: Colors.blue,
                        ),
                        iconSize: 40,
                      )),
                ],
              ),
            ),
          );
        });
  }
}
