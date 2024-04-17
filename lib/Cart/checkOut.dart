import 'dart:math';
import 'package:estore/Cart/thankyou.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estore/Cart/cartItems.dart';
import 'package:estore/Database/dbinitialization.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
//for readable timestamp
import 'package:intl/intl.dart';

class CheckOut extends StatefulWidget {
  final String email;
  final String displayName;
  final String photoUrl;

  CheckOut({
    required this.email,
    required this.displayName,
    required this.photoUrl,
  });

  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  bool formValid = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  List<CartItem> cartItems = [];
  int total = 0;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    try {
      List<CartItem> items = await getAllCartItems();
      setState(() {
        cartItems = items;
        total = cartItems.fold<int>(
            0, (sum, item) => sum + item.qtySold * item.price);
      });
    } catch (error) {
      print('Error fetching cart items: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Wrap the Scaffold body with GestureDetector
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss keyboard on tap outside
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Color.fromARGB(255, 63, 158, 22),
          title: const Text(
            'CHECKOUT',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.displayName,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    widget.email,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        CartItem item = cartItems[index];
                        return ListTile(
                          title: Text(item.title),
                          subtitle: Text(
                            '${item.qtySold} x ${item.price} Rs = ${item.qtySold * item.price} Rs',
                          ),
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(item.imagePath),
                            radius: 25,
                            backgroundColor: Colors.grey,
                          ),
                        );
                      },
                    ),
                    Container(
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.grey)),
                      ),
                      child: Text(
                        'Total: $total Rs',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: fullNameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                        onChanged: (value) => formValidation(),
                      ),
                      TextFormField(
                        controller: phoneNumberController,
                        decoration: InputDecoration(labelText: 'Phone Number'),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter a valid contact number';
                          } else if (!isValidPhoneNumber(value)) {
                            return 'Enter a valid numeric contact number';
                          }
                          return null;
                        },
                        onChanged: (value) => formValidation(),
                      ),
                      TextFormField(
                        controller: addressController,
                        decoration: InputDecoration(labelText: 'House Address'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                        onChanged: (value) => formValidation(),
                      ),
                      TextFormField(
                        controller: cityController,
                        decoration: InputDecoration(labelText: 'City'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your city';
                          }
                          return null;
                        },
                        onChanged: (value) => formValidation(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                UnconstrainedBox(
                  // height: 50,
                  // width: 150,

                  child: ElevatedButton(
                    onPressed:
                        formValid ? () async => await placeOrder() : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: formValid
                          ? Color.fromARGB(255, 63, 158, 22)
                          : Colors.grey,
                      shadowColor: Colors.black,
                      elevation: 20,
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment:  MainAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.fromLTRB(15,20,0,20)),
                        Text("PLACE ORDER",
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                        Icon(
                          Icons.shopping_bag_rounded,
                          size: 30,
                          color: Colors.white,
                        ),
                        SizedBox(width: 20,)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Inside _CheckOutState class

  Future<void> placeOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    late int randomNumber;
    bool uniqueIdFound = false;

    // Show a circular progress indicator in an AlertDialog
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent users from dismissing the dialog
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Processing Order...'),
            ],
          ),
        );
      },
    );

    while (!uniqueIdFound) {
      randomNumber = Random().nextInt(900000) + 1000000;

      try {
        var existingDoc = await firestore
            .collection('orders')
            .doc(randomNumber.toString())
            .get();
        if (!existingDoc.exists) {
          uniqueIdFound = true;
        }
      } catch (error) {
        print('Error connecting to Firestore: $error');
        Fluttertoast.showToast(
          msg: "Check your internet connection",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        break;
      }
    }

    // Hide the AlertDialog
    Navigator.pop(context);

    // Create the order with the unique random ID
    Timestamp timestamp = Timestamp.now();
    DateTime dateTime = timestamp.toDate();
    Map<String, dynamic> orderData = {
      'orderId': randomNumber.toString(),
      'fullName': fullNameController.text,
      'userName': widget.displayName,
      'userEmail': widget.email,
      'phoneNumber': phoneNumberController.text,
      'address': addressController.text,
      'city': cityController.text,
      'timestamp': timestamp,
      'items': cartItems
          .map((item) => {
                'id': item.id,
                'title': item.title,
                'category': item.category,
                'size': item.size,
                'price': item.price,
                'imagePath': item.imagePath,
                'qtySold': item.qtySold,
                'productNo': item.productNo,
              })
          .toList(),
      'orderStatus': "Pending",
      'totalAmount': total,
    };

    // Add the order to Firestore with the unique random ID
    try {
      await firestore
          .collection('orders')
          .doc(orderData['orderId'])
          .set(orderData);

      print(
          'Order placed successfully! Order ID: ${orderData['orderId']} $dateTime');
    } catch (error) {
      Fluttertoast.showToast(msg: 'Error placing order, check your internet');
      print('Error placing order: $error');
    }
    // ignore: use_build_context_synchronously
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Your Order is placed'),
            content: FutureBuilder<DocumentSnapshot>(
              future: firestore
                  .collection('orders')
                  .doc(orderData['orderId'])
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Text(
                      'No data found for order ID: ${orderData['orderId']}');
                }

                // Extract order data from snapshot
                Map<String, dynamic> order =
                    snapshot.data!.data() as Map<String, dynamic>;

                //convert timestamp into a readable form
                DateTime dateTimeFromDB = order['timestamp'].toDate();
                String formattedDateTime =
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTimeFromDB);

                // Build the content of the dialog with order details
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Order ID: ${order['orderId']}'),
                    Text('Full Name: ${order['fullName']}'),
                    Text('Email: ${order['userEmail']}'),
                    Text('Address: ${order['address']}'),
                    Text('City: ${order['city']}'),
                    Text('Phone Number: ${order['phoneNumber']}'),
                    Text('Time Stamp: $formattedDateTime'),
                    SizedBox(height: 10),
                    const Text(
                      "Items Included",
                      style: TextStyle(color: Colors.green, fontSize: 20),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.green)),

                      height: 200, // Adjust the height as needed
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: order['items'].map<Widget>((orderedItem) {
                            return ListTile(
                              title: Text(
                                  "${orderedItem['title']}, Size: ${orderedItem['size']}"),
                              subtitle: Text(
                                  '\ ${orderedItem['price']} x ${orderedItem['qtySold']}'),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("Total: ${order['totalAmount']}"),
                    // Add more order details as needed
                  ],
                );
              },
            ),
            actions: [
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => thankyou(
                                    displayName_: widget.displayName,
                                    email_: widget.email,
                                    photoUrl_: widget.photoUrl)));
                      },
                      icon: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 40,
                      ))),
            ],
          );
        });
    if (uniqueIdFound) {
      // Delete all cart items from the database
      await deleteAllCartItems();
    }
  }

  Future<List<CartItem>> getAllCartItems() async {
    Dbfiles dbfiles = Dbfiles();
    return await dbfiles.getCartItems();
  }

  bool isValidPhoneNumber(String phoneNumber) {
    final phoneRegExp = RegExp(r'^[0-9]+$');
    return phoneRegExp.hasMatch(phoneNumber);
  }

  formValidation() {
    setState(() {
      formValid = _formKey.currentState?.validate() ?? false;
    });
  }

  Future<void> deleteAllCartItems() async {
    try {
      Dbfiles dbfiles = Dbfiles();
      await dbfiles.deleteAllCartItems();
      print('All cart items deleted successfully.');
    } catch (error) {
      print('Error deleting cart items: $error');
    }
  }
}
