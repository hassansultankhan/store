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
      soldStatus: false,
      qtySold: 0,
    ),
    MenuItem(
      title: "Red Chatni",
      category: "chatnis",
      size: "200 ml",
      price: 340,
      imagePath: 'assets/images/redChatni.jpg',
      soldStatus: false,
      qtySold: 0,
    ),
    MenuItem(
      title: "Yellow Chatni",
      category: "Chatnis",
      size: "700ml",
      price: 500,
      imagePath: 'assets/images/YellowChatni.jpg',
      soldStatus: false,
      qtySold: 0,
    ),
  ];

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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    tileColor: const Color.fromARGB(255, 189, 223, 207),
                    leading: CircleAvatar(
                        backgroundImage: AssetImage(menuItem.imagePath),
                        radius: 30,
                        backgroundColor: Colors.grey),
                    title: Text(menuItem.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    subtitle: Text("${menuItem.price.toString()} Rs.",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    trailing: Icon(
                      Icons.add_shopping_cart_rounded,
                      size: 30,
                      color: menuItem.soldStatus
                          ? Colors.green
                          : const Color.fromARGB(255, 255, 255, 255),
                    ),
                    onTap: () {
                      Future.delayed(Duration.zero, () {
                        showDialog(
                          context: context, //create location tag
                          builder: (context) => itemAlert(
                              context, //pass location tag to itemAlert, that where does itemAlert lyes
                              menuItem.imagePath,
                              menuItem.title,
                              menuItem.category,
                              menuItem.size,
                              menuItem.price,
                              menuItem.soldStatus, () {
                            // Logic to update soldStatus to true
                            setState(() {
                              //function passed as parameter to itemAlert
                              menuItem.soldStatus = !menuItem.soldStatus;
                            });
                          }),
                        );
                      });
                    }),
              ),
            ]),
          );
        }),
      ),
    );
  }

  //Alert box for item details

  Widget itemAlert(
    BuildContext context,
    String _imagePath,
    String _title,
    String _category,
    String _size,
    int _price,
    bool _soldStatus,
    Function() updateSoldStatus,
  ) {
    int quantity = 1;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter alertSetState) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(5),
          elevation: 4,
          title: Text(
            _title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.green),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        _imagePath,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Category: $_category"),
                        const SizedBox(
                          height: 8,
                        ),
                        Text("Size: $_size"),
                        const SizedBox(
                          height: 8,
                        ),
                        Text("Price: $_price"),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 20),
                          child: IconButton(
                            onPressed: () {
                              updateSoldStatus();
                              alertSetState(() {
                                _soldStatus = !_soldStatus;
                              });
                            },
                            icon: Icon(
                              Icons.add_shopping_cart_rounded,
                              color: _soldStatus ? Colors.green : Colors.black,
                              size: 40,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 27, top: 10),
                          child: Text(
                            "Place Order",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (quantity > 1) {
                          alertSetState(() {
                            quantity--;
                            print(quantity.toString());
                          });
                        }
                      },
                      icon: Icon(Icons.remove_circle),
                    ),
                    SizedBox(
                      width: 50,
                      child: Center(
                        child: Text(
                          '$quantity',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        alertSetState(() {
                          quantity++;
                        });
                        print(quantity);
                      },
                      icon: Icon(Icons.add_box),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.close,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
