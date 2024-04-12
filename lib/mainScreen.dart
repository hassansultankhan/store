import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class mainScreen extends StatefulWidget {
  mainScreen({super.key});

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
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
                          mainScreenAlertDialog(
                              "Organic Ketchep",
                              "Add flovor to anything",
                              "assets/images/sauces/Tomatosauce.jpg",
                              "Sauces");
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

                    // Element 3 of scroll list

                    Padding(
                      padding: EdgeInsets.only(top: 10),
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

  loadProduct() {}
  mainScreenAlertDialog(
      String item, String tagline, String imageAddress, String category) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Column(
            children: [
              Text(
                "$item",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Poppins regular',
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              Text(
                tagline,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Poppins regular',
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.width / 3,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[200],
                  image: DecorationImage(
                    image: AssetImage(imageAddress),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Poppins regular',
                          fontWeight: FontWeight.w600,
                          color: Colors.black, // Default color
                        ),
                        children: [
                          const TextSpan(text: "Select "),
                          TextSpan(
                              text: "\n${item}",
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 4, 155, 9))),
                          TextSpan(text: "\nfrom ${category}")
                        ]),
                  ),
                  // const SizedBox(width: 20),
                  Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.next_plan),
                    iconSize: 45,
                    color: Colors.green,
                  )
                ],
              )
            ],
          ));
        });
  }
}
