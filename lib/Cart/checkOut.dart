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
    return GestureDetector( // Wrap the Scaffold body with GestureDetector
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss keyboard on tap outside
      },
      child: Scaffold(
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
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        decoration: InputDecoration(labelText: 'Full Name'),
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
                SizedBox(
                  height: 50,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: formValid ? () async => await placeOrder() : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: formValid ? Colors.green : Colors.grey,
                      shadowColor: Colors.black,
                      elevation: 20,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("PLACE ORDER", style: TextStyle(fontSize: 18)),
                        Icon(Icons.shopping_bag_rounded, size: 30),
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

  Future<void> placeOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FirebaseFirestore firestore = FirebaseFirestore.instance;

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
    final phoneRegExp = RegExp(r'^[0-9]+$');
    return phoneRegExp.hasMatch(phoneNumber);
  }

  formValidation() {
    setState(() {
      formValid = _formKey.currentState?.validate() ?? false;
    });
  }
}
