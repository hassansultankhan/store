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
            return ListView.builder(
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
                  trailing: IconButton(
                    onPressed: () async {
                      await Dbfiles().deleteCartItem(item.id);
                      // Trigger a rebuild of the widget when an item is deleted
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${item.title} removed from cart'),
                        ),
                      );
                    },
                    icon: Icon(Icons.delete),
                  ),
                );
              },
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
