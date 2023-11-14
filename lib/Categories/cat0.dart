import 'dart:ffi';

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
      imagePath: 'assets/images/greenChatni.jpg',
    ),
    MenuItem(
        title: "red chatni",
        category: "chatnis",
        size: "200ml",
        price: 340,
        imagePath: 'assets/images/redChatni.jpg'),
    MenuItem(
        title: "Yellow Chatni",
        category: "Chatnis",
        size: "700ml",
        price: 500,
        imagePath: 'assets/images/YellowChatni.jpg'),
  ];

  int _hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: ((context, index) {
          MenuItem menuItem = menuItems[index];
          // return MouseRegion(
          //   onEnter: (_)
          //       // when cursor/mouse enter the regin (mouseregion)
          //       {
          //     setState(
          //       () {
          //         _hoveredIndex = index;
          //       },
          //     );
          //   },
          //   child: InkWell(
          //     onTap: () {},
          //     child: Column(
          //       children: [
          //         Container(
          //           //if _hovered Index value is equal to that of menuitem Index, enlarge the picture
          //           width: _hoveredIndex == index ? 120.0 : 100.0,
          //           height: _hoveredIndex == index ? 120.0 : 100.0,
          //           child: Image.asset(menuItem.imagePath),
          //         ),
          //       ],
          //     ),
          //   ),
          // );

          return Container(
            child: Column(children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                child: ListTile(
                    tileColor: const Color.fromARGB(255, 189, 223, 207),
                    leading: CircleAvatar(
                        backgroundImage: AssetImage('${menuItem.imagePath}'),
                        radius: 30,
                        backgroundColor: Colors.grey),
                    title: Text(menuItem.title),
                    subtitle: Text(menuItem.price.toString()),
                    trailing: IconButton(
                      icon: Icon(Icons.add_shopping_cart),
                      color: Color.fromARGB(255, 2, 116, 12),
                      onPressed: () {},
                    )),
              ),
            ]),
          );
        }),
      ),
    );
  }
}
