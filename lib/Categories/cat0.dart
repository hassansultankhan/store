import 'menuItem.dart';
import 'package:flutter/material.dart';

class Cat0 extends StatefulWidget {
  const Cat0({Key? key}) : super(key: key);

  @override
  State<Cat0> createState() => _Cat0State();
}

class _Cat0State extends State<Cat0> {
  List<MenuItem> menuItems = [
    MenuItem(
      title: "green chatni",
      category: "chatnis",
      size: "500ml",
      price: 550,
      imagePath: 'assets/images/apple.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(),
    );
  }
}
