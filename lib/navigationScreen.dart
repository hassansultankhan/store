import 'package:estore/Cart/cartItems.dart';
import 'package:estore/Cart/ordersHistory.dart';
import 'package:estore/loginScreen.dart';
import 'package:estore/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:estore/Database/dbinitialization.dart';
import 'package:estore/Cart/checkOut.dart';

import 'Categories/cat0.dart';
import 'Categories/cat1.dart';

class navigationScreen extends StatefulWidget {
  final String displayName;
  final String email;
  final String photoUrl;

  const navigationScreen({
    Key? key,
    required this.displayName,
    required this.email,
    required this.photoUrl,
  }) : super(key: key);

  @override
  State<navigationScreen> createState() => _navigationScreenState();
}

class _navigationScreenState extends State<navigationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  var screens = [
    mainScreen(),
    Cat0(),
    Cat1(),
  ];
  int selectedCat = 0;
  bool cartNotEmpty = true;
  @override
  Widget build(BuildContext context) {
    // Set the status bar color here
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(
          255, 14, 41, 0), // Change this color to your desired color
    ));
    return Scaffold(
        appBar: AppBar(
          title: const Text("Flavor up"),
          centerTitle: true,
          // add avatar of photo Url from constructor
          backgroundColor: Color.fromARGB(255, 63, 158, 22),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: "Back to previous screen",
              onPressed: () async {
                //pops back to previous screen without leaving a trace of route
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => loginScreen()),
                    (route) => false);
              }),
          actions: [
            IconButton(
              onPressed: () {
                // Show added cart items in AlertDialog  XXXXXXXXXXXXX

                showCartItems();
              },
              icon: const Icon(
                Icons.shopping_cart_rounded,
                size: 30,
              ),
            ),
            IconButton(
              onPressed: () {
                Future.delayed(Duration.zero, () {
                  showDialog(
                    context: context,
                    builder: (context) => showCredentials(
                        widget.displayName, widget.email, widget.photoUrl),
                  );
                });
              },
              icon: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: widget.photoUrl.startsWith("http")
                      ? Image.network(widget.photoUrl)
                      : Image.asset('assets/images/Carrot_icon.png'),
                ),
              ),
            ),
          ],
        ),
        body: SizedBox(
          //set size of sized box to maximum size of screen
          height: MediaQuery.of(context).size.height * .97,
          child: screens[selectedCat],
        ),
        // Build bottom navigation bar with product categories
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectedCat,
            backgroundColor: Color.fromARGB(255, 63, 158, 22),
            selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
            unselectedItemColor: Color.fromARGB(255, 218, 242, 215),
            selectedFontSize: 20,
            onTap: (int i) => switchScreen(i, context),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.menu), label: "Main Page"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.food_bank), label: "Sauces"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.food_bank), label: "Chatnis"),
            ]));
  }

  void switchScreen(int index, BuildContext context) {
    setState(() {
      selectedCat = index;
    });
  }

  Future<void> _signOut() async {
    // Sign out from Firebase
    await _auth.signOut();

    // Sign out from Google
    await _googleSignIn.signOut();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const loginScreen()),
        (route) => false);
  }

  showCredentials(name, email, photo) {
    return AlertDialog(
      actions: [
        Row(
          children: [
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(
                Icons.logout,
                size: 30,
                color: Colors.black,
              ),
              alignment: Alignment.bottomLeft,
              onPressed: () => _signOut(),
            ),
            SizedBox(width: MediaQuery.of(context).size.width - 240),
            IconButton(
              icon: const Icon(
                Icons.remove_circle_outline,
                size: 30,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context); // Close the AlertDialog
              },
            ),
          ],
        )
      ],

      // Display details of login (login credentials)
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text('You are logged in as $name'),
            Text('$email'),
            //display argument photo in avatar of redius 15
            // Display either network or asset image based on the condition
            const SizedBox(height: 20),
            photo.startsWith('http') // Check if it's a network image
                ? Image.network(
                    photo,
                    height: 20,
                    width: 20,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  )
                : CircleAvatar(
                    radius: 30,
                    backgroundColor:
                        Colors.transparent, // Ensure transparent background
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/Carrot_icon.png',
                        fit: BoxFit
                            .contain, // Use BoxFit.contain to fit the image without clipping
                      ),
                    ),
                  ),
            const SizedBox(height: 20),
            Container(
              child: UnconstrainedBox(
                child: SizedBox(
                  width: 180,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all<double>(8),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (contect) => ordersHistory(
                            widget.displayName
                          ),
                        ));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            'Your Orders',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.shopping_bag_rounded)
                        ],
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to retrieve all cart items from the database
  Future<List<CartItem>> getAllCartItems() async {
    Dbfiles dbfiles = Dbfiles();
    return await dbfiles.getCartItems();
  }

  // Method to show added cart items in AlertDialog
  void showCartItems() async {
    List<CartItem> cartItems = await getAllCartItems();

    for (CartItem item in cartItems) {
      print('Title: ${item.title}');
      print('Image Path: ${item.imagePath}');
      print('-----------------------');
    }
    // }

// ignore_for_file: use_build_context_synchronously
    setState(() {
      showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter alertsetState) {
              bool isCartEmpty = cartItems.isEmpty;
              return AlertDialog(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.elliptical(20, 20),
                  ),
                ),
                title: const Text('Cart Items'),
                content: Container(
                  height: 400,
                  child: SingleChildScrollView(
                    child: Column(
                      children: cartItems.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            tileColor: const Color.fromARGB(255, 147, 201, 111),
                            contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            title: Text(
                              item.title,
                              style: const TextStyle(color: Colors.black),
                            ),
                            subtitle: Text(
                              '${item.qtySold} x ${item.price} Rs = ${item.qtySold * item.price} Rs',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 12),
                            ),
                            trailing: Wrap(
                              children: [
                                CircleAvatar(
                                    backgroundImage: AssetImage(item.imagePath),
                                    radius: 25,
                                    backgroundColor: Colors.grey),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () async {
                                    await Dbfiles()
                                        .deleteCartItem(item.productNo);
                                    alertsetState(() {
                                      cartItems.remove(item);
                                      print('Dialog content is being rebuilt');
                                    });
                                  },
                                  icon: Icon(Icons.delete),
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                actions: [
                  Center(
                    child: Container(
                      width: 170,
                      child: ElevatedButton(
                        onPressed: isCartEmpty
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CheckOut(
                                        displayName: widget.displayName,
                                        email: widget.email,
                                        photoUrl: widget.photoUrl),
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          elevation: 7,
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          backgroundColor: cartNotEmpty
                              ? const Color.fromARGB(255, 63, 158, 22)
                              : Colors.grey,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Check Out', style: TextStyle(fontSize: 14)),
                            SizedBox(width: 8),
                            Icon(Icons.shopping_cart_checkout_rounded,
                                size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the AlertDialog
                    },
                    child: const Text('Close'),
                  ),
                ],
              );
            },
          );
        },
      );
    });
  }
}
