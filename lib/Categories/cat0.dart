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
      imagePath: 'assets/images/greenChatni.png',
    ),
    MenuItem(
        title: "red chatni",
        category: "chatnis",
        size: "200ml",
        price: 340,
        imagePath: 'assets/images/redChatni.png'),
    MenuItem(
        title: "Yellow Chatni",
        category: "Chatnis",
        size: "700ml",
        price: 500,
        imagePath: 'assets/images/yellowChatni.png'),
  ];

  int _hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: ((context, index) {
          MenuItem menuItem = menuItems[index];
          return MouseRegion(
            onEnter: (_)
                // when cursor/mouse enter the regin (mouseregion)
                {
              setState(
                () {
                  _hoveredIndex = index;
                },
              );
            },
            child: InkWell(
              onTap: () {},
              child: Column(
                children: [
                  Container(
                    //if _hovered Index value is equal to that of menuitem Index, enlarge the picture
                    width: _hoveredIndex == index ? 120.0 : 100.0,
                    height: _hoveredIndex == index ? 120.0 : 100.0,
                    child: Image.asset(menuItem.imagePath),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
