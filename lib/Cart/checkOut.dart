import 'package:flutter/material.dart';
import 'package:estore/Cart/cartItems.dart';
import 'package:estore/Database/dbinitialization.dart';

class checkOut extends StatelessWidget {
  final String email;
  final String displayName;

  checkOut({
    required this.email,
    required this.displayName,
  });

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

                // Calculate the total price
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
                    TextField(
                      decoration: InputDecoration(labelText: 'Phone Number'),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Full Name'),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'House Address'),
                    ),
                    TextField(decoration: InputDecoration(labelText: 'City'),),
                    SizedBox(height:20),
                    // Place Order button
                    // Set the width as needed
                       ElevatedButton(
                        onPressed: () {
                          // Add your logic for "Place Order" here
                        },
                        style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 8),
                        backgroundColor: const Color.fromARGB(255, 63, 158, 22),
                      ),
                      child: 
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('PLACE ORDER', style: TextStyle(fontSize: 14)),
                          SizedBox(width: 8),
                          Icon(Icons.shopping_bag, size: 20),
                        ],
                      ),
                      ),
                    

                  ],
                );
              }
            },
          ),


    );
  }

  // Method to retrieve all cart items from the database
  Future<List<CartItem>> getAllCartItems() async {
    Dbfiles dbfiles = Dbfiles();
    return await dbfiles.getCartItems();
  }
}
