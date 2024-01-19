import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estore/Cart/cartItems.dart';
import 'package:estore/Database/dbinitialization.dart';

class CheckOut extends StatelessWidget {
  final String email;
  final String displayName;

  bool formValid = false;

  CheckOut({
    required this.email,
    required this.displayName,
  });

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
                  displayName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  email,
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
            int total = cartItems.fold<int>(0, (sum, item) => sum + item.qtySold * item.price);

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
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey)),
                  ),
                  child: Text(
                    'Total: $total Rs',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
          
          // Input fields for phone number, full name, and address
          Form(child:Column(
          children:[
               
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
          ),
          TextFormField(
            controller: phoneNumberController,
            decoration: InputDecoration(labelText: 'Phone Number'),
            keyboardType: TextInputType.phone,
            validator: (value) {
                if (value!.isEmpty){   
                   return 'Enter a valid contact number';
                } else if(!isValidPhoneNumber(value)){
                   return 'Enter a Vali numberic contact number'; 
                }    
            }     
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
          ),
          ]
          ),
          ),

                SizedBox(height: 20),
                // Place Order button
                
        // change icon here XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                IconButton(
                  onPressed: ()async{
                    if(
                     _formKey.currentState != null && _formKey.currentState!.validate()){
                    await placeOrder(cartItems, total); 
                  }
                  else  {print("invalid value passed");}
                  },
                  icon: Icon(Icons.shopping_bag_rounded, size: 50,),
                  color: Colors.greenAccent,
                  focusColor: Colors.green[30],
                
                  ),

                  


            
                
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
      'userName': displayName,
      'userEmail': email,
      'phoneNumber': phoneNumberController.text,
      'address': addressController.text,
      'city': cityController.text,
      'items': cartItems.map((item) => {
        'id': item.id,
        'title': item.title,
        'category': item.category,
        'size': item.size,
        'price': item.price,
        'imagePath': item.imagePath,
        'qtySold': item.qtySold,
        'productNo': item.productNo,
      }).toList(),
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
}
