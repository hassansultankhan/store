import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrdersHistory extends StatefulWidget {
  final String displayName;

  const OrdersHistory(
    this.displayName, {
    Key? key,
  }) : super(key: key);

  @override
  State<OrdersHistory> createState() => _OrdersHistoryState();
}

class _OrdersHistoryState extends State<OrdersHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order History (${widget.displayName})",
          style: const TextStyle(
              fontFamily: 'Poppins regular',
              fontWeight: FontWeight.w600,
              fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .where("userName", isEqualTo: widget.displayName)
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
              // Formate timestamp into readable
              String formattedDateTime =
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(timestampfromDB);

              return Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Container(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          details(data, formattedDateTime, items);
                          print(orderId);
                        },
                        child: ListTile(
                          key: ValueKey(orderId), // Unique key for each order
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: Colors.blueAccent),
                          ),
                          title: Text('Order ID: ${data['orderId']}'),
                          subtitle: Text(
                            'Total Amount: ${data['totalAmount']}\n$formattedDateTime',
                          ),
                          trailing: Text("${data['orderStatus']}",
                              style: TextStyle(fontSize: 20)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList();

            // Sort the order tiles based on timestamp in descending order
            orderTiles.sort((a, b) {
              // Check if a.key and b.key are not null
              if (a.key != null && b.key != null) {
                // Attempt to parse the date format from a.key and b.key
                try {
                  DateTime timestampA = DateTime.parse(a.key.toString());
                  DateTime timestampB = DateTime.parse(b.key.toString());
                  // Compare the timestamps
                  return timestampB.compareTo(timestampA);
                } catch (e) {
                  print('Error parsing date format: $e');
                  // Handle parsing errors, for example, return 0 to keep the order unchanged
                  return 0;
                }
              } else {
                // Handle cases where a.key or b.key is null
                print('a.key or b.key is null');
                // Return 0 to keep the order unchanged
                return 0;
              }
            });

            return ListView(
              children: orderTiles,
            );
          },
        ),
      ),
    );
  }

  details(
    Map<String, dynamic> data,
    String timestamp_,
    List<Map<String, dynamic>> items,
  ) {
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
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Order ID: $orderId'),
                      Text('User Name: $userName'),
                      Text('Full Name: $fullName'),
                      Text('Address: $address'),
                      Text('City: $city'),
                      Text('Phone Number: $phoneNumber'),
                      Text('User Email: $userEmail'),
                      Text('Total Amount: $totalAmount'),
                      Text('Time Stamp :  $timestamp_1'),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Order Items:',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blue,
                  ),
                ),
                Column(
                  children: items.map((item) {
                    return ListTile(
                      title: Text(item['title']),
                      subtitle: Text(
                        'Category: ${item['category']}\nSize: ${item['size']}\nQuantity: ${item['qtySold']}',
                      ),
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
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
