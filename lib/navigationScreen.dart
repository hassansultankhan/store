import 'package:estore/Cart/cartItems.dart';
import 'package:estore/Cart/ordersHistory.dart';
import 'package:estore/loginScreen.dart';
import 'package:estore/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:estore/Database/dbinitialization.dart';
import 'package:estore/Cart/checkOut.dart';

import 'Categories/cat0.dart';
import 'Categories/cat1.dart';

class navigationScreen extends StatefulWidget {
  final String displayName;
  final String email;
  final String photoUrl;

  navigationScreen({
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // late List<Widget> screens;

  int selectedCat = 0;
  bool cartNotEmpty = true;

  @override
  Widget build(BuildContext context) {
    var screens = [
      mainScreen(),
      Cat0(),
      Cat1(),
    ];
    // Set the status bar color here
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(
          255, 14, 41, 0), // Change this color to your desired color
    ));
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(
            "Flavor Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          // add avatar of photo Url from constructor
          backgroundColor: Color.fromARGB(255, 63, 158, 22),
          leading: Row(children: [
            // IconButton(
            //     icon: const Icon(
            //       Icons.arrow_back,
            //       color: Colors.white,
            //     ),
            //     tooltip: "Back to previous screen",
            //     onPressed: () async {
            //       //pops back to previous screen without leaving a trace of route
            //       Navigator.pushAndRemoveUntil(
            //           context,
            //           MaterialPageRoute(builder: (context) => loginScreen()),
            //           (route) => false);
            //     }),

            IconButton(
                icon: const Icon(
                  Icons.list,
                  color: Colors.white,
                  size: 30,
                ),
                tooltip: "Back to previous screen",
                onPressed: () async {
                  _scaffoldKey.currentState?.openDrawer();
                }),
          ]),
          actions: [
            IconButton(
              onPressed: () {
                // Show added cart items in AlertDialog  XXXXXXXXXXXXX

                showCartItems();
              },
              icon: const Icon(
                Icons.shopping_cart_rounded,
                size: 30,
                color: Colors.white,
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
        drawer: Drawer(
            width: 100,
            child: Container(
              color: Color.fromARGB(255, 214, 236, 200),
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.bottomLeft,
                    child: Image.asset(
                      'assets/images/drawer.png',
                    ),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    child: ListView(
                      padding: const EdgeInsets.only(
                        top: 70.0,
                      ),
                      children: [
                        InkWell(
                          onTap: () {
                            drawerAlertDialog(1);
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 80,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/drawerLogo.png"),
                                        fit: BoxFit.contain)),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              const Text(
                                "Contact Us",
                                style: TextStyle(
                                  fontFamily: 'Poppins regular',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        IconButton(
                          iconSize: 40,
                          color: Colors.orange[800],
                          onPressed: () {
                            drawerAlertDialog(0);
                          },
                          icon: Icon(Icons.design_services),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
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
                icon: Icon(Icons.food_bank), label: "Main Page"),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Chatnis"),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Sauces"),
          ],
        ));
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
                          builder: (context) =>
                              OrdersHistory(widget.displayName),
                        ));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            'Your Orders',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Icon(
                            Icons.shopping_bag_rounded,
                            color: Colors.black,
                          ),
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
                            tileColor: Color.fromARGB(255, 172, 211, 242),
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
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.blueGrey,
                                  ),
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
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black, width: 0.25),
                            borderRadius: BorderRadius.circular(10),
                          ),
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
                            Text('Check Out',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                )),
                            SizedBox(width: 8),
                            Icon(
                              Icons.shopping_cart_checkout_rounded,
                              size: 25,
                              color: Colors.white,
                            ),
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

  void toggleToSaucesCategory() {
    setState(() {
      selectedCat = 2; // Index of "Sauces" category
    });
  }

  drawerAlertDialog(int dialognumber) {
    if (dialognumber == 1) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Contact Us",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins regular',
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 192, 106, 26),
              ),
            ),
            content: Container(
              alignment: Alignment.center,
              height: 200,
              width: 100,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                image: DecorationImage(
                    image: AssetImage("assets/images/sauces/sauces.jpeg"),
                    fit: BoxFit.fitHeight,
                    colorFilter:
                        ColorFilter.mode(Colors.white10, BlendMode.dstATop)),
              ),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'Poppins regular',
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 16, // Default color
                    ),
                    children: [
                      TextSpan(text: 'If you have any complaints\n'),
                      TextSpan(text: 'Or'),
                      TextSpan(text: '\nwant to join '),
                      TextSpan(
                        text: 'DIP',
                        style: TextStyle(
                          color: Colors.blueAccent,
                        ),
                      ),
                      TextSpan(
                        text: ' as Vendor',
                      ),
                      TextSpan(text: '\n\nEmail us at'),
                      TextSpan(
                          text: '\nluxonoffice@gmail.com',
                          style: TextStyle(
                            color: Color.fromARGB(255, 5, 75, 7),
                          )),
                    ]),
              ),
            ),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Desinged and Developed by",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Poppins regular',
                  fontWeight: FontWeight.w600,
                  color: Colors.blueAccent,
                  fontSize: 16),
            ),
            content: Container(
              alignment: Alignment.center,
              height: 180,
              width: 100,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: const Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/images/logo.png'),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Hassan Sultan Khan",
                        style: TextStyle(
                          fontFamily: 'Poppins regular',
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.phone),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "(PAK) 92-3004661668",
                          style: TextStyle(
                              fontFamily: 'Poppins regular',
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 12),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              AssetImage('assets/icons/whatsapp.png'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.email),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "hassansultankhan@gmail.com",
                            style: TextStyle(
                                fontFamily: 'Poppins regular',
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 12),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundImage:
                              AssetImage('assets/icons/github.png'),
                        ),
                        SizedBox(width: 7),
                        Text(
                          "hassansultankhan",
                          style: TextStyle(
                              fontFamily: 'Poppins regular',
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 12),
                        ),
                      ],
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
}
