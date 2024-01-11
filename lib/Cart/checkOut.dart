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
        ),
      body: Center(
          child: Column(

          ),
      ),
    );
  }
    // Method to retrieve all cart items from the database
  Future<List<CartItem>> getAllCartItems() async {
    Dbfiles dbfiles = Dbfiles();
    return await dbfiles.getCartItems();
  }
}