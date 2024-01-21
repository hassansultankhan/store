import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estore/Cart/cartItems.dart';
import 'package:estore/Database/dbinitialization.dart';

class CheckOut extends StatefulWidget {
  final String email;
  final String displayName;

  CheckOut({
    required this.email,
    required this.displayName,
  });

  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  bool formValid = false;

  // Controllers for text fields
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CHECKOUT'),
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.email,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<CartItem>>(
        future: getAllCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<CartItem> cartItems = snapshot.data ?? [];
            int total = cartItems.fold<int>(
                0, (sum, item) => sum + item.qtySold * item.price);

            return ListView(
              padding: EdgeInsets.all(15),
              children: [
                // List of items
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
                // Total sum
                Container(
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey)),
                  ),
                  child: Text(
                    'Total: $total Rs',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                // Input fields for phone number, full name, and address
                Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(
                      controller: fullNameController,
                      decoration: InputDecoration(labelText: 'Full Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        // Add more validation logic if needed
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
                        // Add more validation logic if needed
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
                        // Add more validation logic if needed
                        return null;
                      },
                      onChanged: (value) => formValidation(),
                    ),
                  ]),
                ),

                SizedBox(height: 20),
                // Place Order button
                UnconstrainedBox(
                    child: SizedBox(
                  height: 50,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: formValid
                        ? () async => await placeOrder(cartItems, total)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: formValid ? Colors.green : Colors.grey,
                      shadowColor: Colors.black,
                      elevation: 20,
                      tapTargetSize: MaterialTapTargetSize
                          .padded, // make the button bigger
                    ).copyWith(
                      fixedSize: MaterialStateProperty.all(Size(130, 40)),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "PLACE ORDER",
                            style: TextStyle(fontSize: 18),
                          ),
                          Icon(Icons.shopping_bag_rounded, size: 30),
                        ],
                      ),
                    ),
                  ),
                )),
              ],
            );
          }
        },
      ),
    );
  }

  Future<void> placeOrder(List<CartItem> cartItems, int total) async {
    // Initialize Firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create a new order document
    DocumentReference orderRef = await firestore.collection('orders').add({
      'fullName': fullNameController.text,
      'userName': widget.displayName,
      'userEmail': widget.email,
      'phoneNumber': phoneNumberController.text,
      'address': addressController.text,
      'city': cityController.text,
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
      'totalAmount': total,
    });

    print('Order placed successfully! Order ID: ${orderRef.id}');
  }

  Future<List<CartItem>> getAllCartItems() async {
    Dbfiles dbfiles = Dbfiles();
    return await dbfiles.getCartItems();
  }

  bool isValidPhoneNumber(String phoneNumber) {
    // Use a regular expression to check if the phone number is numeric
    final phoneRegExp = RegExp(r'^[0-9]+$');
    return phoneRegExp.hasMatch(phoneNumber);
  }

  formValidation() {
    setState(() {
      formValid = _formKey.currentState?.validate() ?? false;
    });
  }
}
