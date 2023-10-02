import 'package:estore/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Categories/cat0.dart';
import 'Categories/cat1.dart';

class navigationScreen extends StatefulWidget {
  const navigationScreen({super.key});

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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(
          255, 78, 226, 9), // Change this color to your desired color
    ));
    return Scaffold(
        body: SizedBox(
          //set size of sized box to maximum size of screen
          height: MediaQuery.of(context).size.height * .97,
          child: screens[selectedCat],
        ),
        // Build bottom navigation bar with product categories
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectedCat,
            backgroundColor: Color(0xfffece20),
            selectedItemColor: Colors.brown[800],
            unselectedItemColor: Colors.brown,
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
