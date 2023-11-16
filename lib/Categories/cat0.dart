
import 'package:flutter/foundation.dart';

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
      title: "Green Chatni",
      category: "chatnis",
      size: "500ml",
      price: 550,
      imagePath: 'assets/images/greenChatni.jpg',
    ),
    MenuItem(
        title: "Red Chatni",
        category: "chatnis",
        size: "200 ml",
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

          return Container(
            child: Column(children: [
              Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: ListTile(
                    shape: 
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    tileColor: const Color.fromARGB(255, 189, 223, 207),
                    leading: CircleAvatar(
                        backgroundImage: AssetImage(menuItem.imagePath),
                        radius: 30,
                        backgroundColor: Colors.grey),
                    title: Text(menuItem.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    
                    subtitle: Text("${menuItem.price.toString()} Rs.", 
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_shopping_cart_rounded,),
                      color: const Color.fromARGB(255, 255, 255, 255),
                      iconSize: 30,
                      onPressed: () {},
                    ),
                    onTap: (){
                      Future.delayed(Duration.zero,(){
                        showDialog(
                          context: context,
                          builder: (context)=> itemAlert(
                            menuItem.imagePath,
                            menuItem.title,
                            menuItem.category,
                            menuItem.size,
                            menuItem.price
                            ),
                          );
                    }
                    );
                    }
              ),
              ),
            ]
            
            ),
          );
        }),
      ),
    );
  }
  itemAlert(String _imagePath, String _title, String _category, String _size, int _price ){
    return AlertDialog(
      contentPadding: const EdgeInsets.all(5),
      elevation: 4,
      title:  Text(_title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.green),),
      content:
      SingleChildScrollView(child:ListBody(
        children: <Widget>[
          const SizedBox(height: 20,),
          Row(mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget> [
            ClipRRect(
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(_imagePath, height: 150, width: 150,
            fit: BoxFit.cover,),
            )
            ],
            ),
            Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[
             Column(crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                  Text("Category: $_category"),
                  const SizedBox(height: 8,),
                  Text("Size: $_size"),
                  const SizedBox(height: 8,),
                  Text("Price: $_price"),
                ],
                ),
                const SizedBox(width: 10,),
                IconButton(onPressed: (){}, 
                icon: const Icon(Icons.add_shopping_cart_rounded,
                size: 40,)
                ),
                ]
                ),
           
        ]
      ),
      ),
        

      actions: <Widget>[
        IconButton(
        icon:const Icon(
          Icons.remove_circle_outline,
          size: 30,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        ),

      ],
    );
  }
}
