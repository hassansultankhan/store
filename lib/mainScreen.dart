import 'package:estore/Categories/cat0.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiver/strings.dart';

import 'Cart/cartItems.dart';
import 'Database/dbinitialization.dart';

class mainScreen extends StatefulWidget {
  mainScreen({super.key});

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  bool soldstatus = false;
  String mainScreenTitle = "eStore";
  List<String> imageAssetPaths = [
    'assets/images/packages/PanSauces.jpg',
    'assets/images/packages/package4.jpg',
    'assets/images/packages/package2.jpg',
    'assets/images/packages/platter.jpg',
    'assets/images/packages/package3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover),
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyLarge,
                        children: const [
                          TextSpan(text: "Try"),
                          TextSpan(
                              text: " DIP's ",
                              style: TextStyle(color: Colors.blue)),
                          TextSpan(text: "sauce bags")
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      Icons.commit_rounded,
                      size: 30,
                    )
                  ],
                ),
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                clipBehavior: Clip.antiAlias,
                height: 180,
                enlargeCenterPage: true,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 0.8,
              ),
              items: imageAssetPaths.map((String imageAssetPath) {
                return Builder(
                  builder: (BuildContext context) {
                    return ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: InkWell(
                          onTap: () => loadProduct(),
                          child: Image.asset(
                            imageAssetPath,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    // Element 1 of scroll sheet

                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: InkWell(
                        onTap: () {
                          Future.delayed(Duration.zero, () {
                            showDialog(
                              context: context, //create location tag
                              builder: (context) => itemAlert(
                                  "Add flavor to anything",
                                  context, //pass location tag to itemAlert, that where does itemAlert lyes
                                  'assets/images/sauces/Tomatosauce.jpg',
                                  "Tomato Sauce",
                                  "Sauces",
                                  "700ml",
                                  500,
                                  1,
                                  012,
                                  soldstatus, () {
                                // Logic to update soldStatus to true
                                setState(() {
                                  //function passed as parameter to itemAlert
                                  soldstatus = !soldstatus;
                                });
                              }),
                            );
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    fontFamily: 'Poppins regular',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black, // Default color
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Ketchup made from\n*rich ",
                                    ),
                                    TextSpan(
                                        text: "ORGANIC ",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 4, 155, 9))),
                                    TextSpan(
                                      text: "tomatoes",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    TextSpan(
                                      text: ".\nADD FLAVOR TO ANYTHING!",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 170,
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    10), // Adjust the radius as needed
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    5), // Same radius as the BoxDecoration
                                child: Image.asset(
                                  'assets/images/ketchupPouring.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Element 2 of scroll sheet

                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: InkWell(
                        onTap: () {
                          Future.delayed(Duration.zero, () {
                            showDialog(
                              context: context, //create location tag
                              builder: (context) => itemAlert(
                                  "Spice up your taste buds",
                                  context, //pass location tag to itemAlert, that where does itemAlert lyes
                                  'assets/images/bottles.png',
                                  "Hot Sauce",
                                  "Sauces",
                                  "500ml",
                                  400,
                                  1,
                                  013,
                                  soldstatus, () {
                                // Logic to update soldStatus to true
                                setState(() {
                                  //function passed as parameter to itemAlert
                                  soldstatus = !soldstatus;
                                });
                              }),
                            );
                          });
                        },
                        child: UnconstrainedBox(
                          alignment: Alignment.center,
                          child: Material(
                            color: Color.fromARGB(255, 172, 211, 242),
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white, width: 3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(15, 5, 25, 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          10), // Adjust the radius as needed
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          5), // Same radius as the BoxDecoration
                                      child: Image.asset(
                                        'assets/images/bottles.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    child: RichText(
                                      text: const TextSpan(
                                        style: TextStyle(
                                          fontFamily: 'Poppins regular',
                                          color: Colors.black, // Default color
                                        ),
                                        children: [
                                          TextSpan(
                                            text: "SPICE up your taste buds\n",
                                            style: TextStyle(
                                              fontWeight: FontWeight
                                                  .w600, // Apply font weight here
                                            ),
                                          ),
                                          TextSpan(
                                            text: "with HOT SAUCE",
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 221, 114, 20),
                                              fontWeight: FontWeight
                                                  .bold, // Apply font weight here
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Element 3 of scroll list

                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: InkWell(
                        onTap: () {
                          Future.delayed(Duration.zero, () {
                            showDialog(
                              context: context, //create location tag
                              builder: (context) => itemAlert(
                                  "Load the table",
                                  context, //pass location tag to itemAlert, that where does itemAlert lyes
                                  'assets/images/bottleVariety.png',
                                  "Variety Mix Box",
                                  "Sauces",
                                  "",
                                  3000,
                                  1,
                                  014,
                                  soldstatus, () {
                                // Logic to update soldStatus to true
                                setState(() {
                                  //function passed as parameter to itemAlert
                                  soldstatus = !soldstatus;
                                });
                              }),
                            );
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    fontFamily: 'Poppins regular',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black, // Default color
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Confused?\n",
                                    ),
                                    TextSpan(text: "Try "),
                                    TextSpan(
                                      text: "VARIETY MIX ",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Material(
                              color: Color.fromARGB(255, 221, 114, 20),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white, width: 3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 8,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                                child: Container(
                                  height: 100,
                                  width: 195,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'assets/images/bottleVariety.png',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // dormant function
  loadProduct() {}

  Widget itemAlert(
    String tagline,
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
            style: const TextStyle(
                color: Colors.green,
                fontFamily: 'Poppins regular',
                fontWeight: FontWeight.w600,
                fontSize: 20),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const SizedBox(
                  height: 10,
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
                        width: 300,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Text(
                    tagline,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 209, 120, 19),
                        fontFamily: 'Poppins regular',
                        fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
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
                                // After inserting into the database
                                // Print the image path to make sure the url value is passed
                                print(
                                    'Inserted Cart Item Image Path: ${cartItem.imagePath}');
                              } else {
                                // If _soldStatus is false, delete the entry with the given id
                                //   await dbfiles.deleteCartItem(cartItem.id);
                                await dbfiles
                                    .deleteCartItem(cartItem.productNo);

                                print(
                                    "item deleted on _soldStatus being false");
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
                                    'Image URL: ${cartItem.imagePath}\n'
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
  //mistakes reverted
}
