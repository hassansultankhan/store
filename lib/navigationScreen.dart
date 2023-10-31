import 'package:estore/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
          actions: [
            IconButton(
              onPressed: () {},
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
            backgroundColor: Color.fromARGB(255, 74, 230, 8),
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
}
