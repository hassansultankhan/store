import 'package:estore/loginScreen.dart';
import 'package:estore/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
                // Navigator.popUntil(context, ModalRoute.withName('/'));
                // Navigator.pop(context);
              }),
          actions: [
            // create a back button on the left of appbar that navigates back to the login screen
            IconButton(onPressed: _signOut, icon: const Icon(Icons.logout)),

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
                child: ClipOval(
                  child: widget.photoUrl.startsWith("http")
                      ? Image.network(widget.photoUrl)
                      : Image.asset('assets/images/Carrot_icon.png'),
                ),
                backgroundColor: Colors.white,
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

    // You can also add additional cleanup code for Firestore or other services

    // Navigate to the login screen or home screen as needed

    // Navigator.pop(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) =>
    //             const loginScreen())); // Replace with your routes

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const loginScreen()),
        (route) => false);
  }

  showCredentials(name, email, photo) {
    return AlertDialog(
      // Main title of alert box
      // title: Text("Your login details are"),

      // cross button for alert box
      actions: [
        IconButton(
          icon: const Icon(
            Icons.check_rounded,
            size: 40,
            color: Colors.greenAccent,
          ),
          onPressed: () {
            Navigator.pop(context); // Close the AlertDialog
          },
        ),
      ],

      // Display details of login (login credentials)
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text('You are logged in as $name'),
            Text('$email'),
            //display argument photo in avatar of redius 15
            // Display either network or asset image based on the condition
            SizedBox(height: 20),
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
          ],
        ),
      ),
    );
  }
}
