import 'package:flutter/material.dart';

import 'Categories/cat0.dart';
import 'Categories/cat1.dart';

class navigationScreen extends StatefulWidget {
  const navigationScreen({super.key});

  @override
  State<navigationScreen> createState() => _navigationScreenState();
}

class _navigationScreenState extends State<navigationScreen> {
  var screens = [
    Cat0(),
    Cat1(),
  ];
  int selectedCat = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flavor up'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 186, 241, 35),
        ),
        body: screens[selectedCat],

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
