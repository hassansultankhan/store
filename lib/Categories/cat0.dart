import 'package:estore/Cart/cartItems.dart';
import 'menuItem.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:estore/Database/dbinitialization.dart';
// ignore: duplicate_import
import 'package:estore/Cart/cartItems.dart';

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
        qtySold: 1,
        productNo: 001),
    MenuItem(
        title: "Red Chatni",
        category: "chatnis",
        size: "200 ml",
        price: 340,
        imagePath: 'assets/images/redChatni.jpg',
        soldStatus: false,
        qtySold: 1,
        productNo: 002),
    MenuItem(
        title: "Yellow Chatni",
        category: "Chatnis",
        size: "700ml",
        price: 500,
        imagePath: 'assets/images/YellowChatni.jpg',
        soldStatus: false,
        qtySold: 1,
        productNo: 003),
  ];

  List<CartItem> cartItems = [];

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
                              menuItem.qtySold,
                              menuItem.productNo,
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
    int _qtySold,
    int _productNo,
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
                            onPressed: () async {
                              //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                              // update cart
                              updateSoldStatus();
                              alertSetState(() {
                                _soldStatus = !_soldStatus;
                              });
                              showToast(_soldStatus);

                              print('Title in itemAlert: $_title');

                              // Create a CartItem object
                              CartItem cartItem = CartItem.withoutId(
                                // id: remove id assignment as it will be autogenerated
                                title: _title,
                                category: _category,
                                size: _size,
                                price: _price,
                                imagePath: _imagePath,
                                qtySold: _qtySold,
                                productNo: _productNo,
                              );

                              // Get the database instance
                              Dbfiles dbfiles = Dbfiles();
                              await dbfiles
                                  .db; // Ensure the database is initialized

                              if (_soldStatus) {
                                // Insert the CartItem into the database
                                await dbfiles.insertCartItem(cartItem);
                              } else {
                                // If _soldStatus is false, delete the entry with the given id
                                await dbfiles.deleteCartItem(cartItem.id);
                              }

                              // Retrieve and print all cart items from the database
                              List<CartItem> allCartItems =
                                  await dbfiles.getCartItems();
                              for (CartItem cartItem in allCartItems) {
                                print('Cart Item ID: ${cartItem.id}\n'
                                    'Title: ${cartItem.title}\n'
                                    'Category: ${cartItem.category}\n'
                                    'Size: ${cartItem.size}\n'
                                    'Price: ${cartItem.price}\n'
                                    'Quantity Sold: ${cartItem.qtySold}\n'
                                    'Product No. : ${cartItem.productNo}\n');
                              }
                              setState(() {});
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
                            _qtySold = quantity;
                            print(_qtySold.toString());
                            
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
                          _qtySold = quantity;
                          print(_qtySold.toString());
                        });
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

  void showToast(bool SoldMessageStatus) async {
    String alertMessage;
    if (SoldMessageStatus) {
      alertMessage = "Order added to Cart";
    } else {
      alertMessage = "Product removed from Cart";
    }
    await Fluttertoast.showToast(
      msg: alertMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
