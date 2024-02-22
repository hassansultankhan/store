import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


class mainScreen extends StatefulWidget {
  mainScreen({super.key});

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  String mainScreenTitle = "eStore";
  List<String> imageAssetPaths = [
    'assets/images/image1.jpeg',
    'assets/images/image2.jpeg',
  ];

List<Map<String, dynamic>> packageData = [
  {'imagePath': 'assets/images/packages/package1.jpg', 'fontColor': Colors.black},
  {'imagePath': 'assets/images/packages/package2.jpg', 'fontColor': Colors.green},
  {'imagePath': 'assets/images/packages/package3.jpg', 'fontColor': Colors.green},
  {'imagePath': 'assets/images/packages/package4.jpg', 'fontColor': Colors.green},
];
  //   List<Color> fontColors =[
  //   Colors.black,
  //   Colors.green,
  //   Colors.green,
  //   Colors.green,
  // ];

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  enlargeCenterPage: true,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                ),
                items: imageAssetPaths.map((String imageAssetPath) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                        ),
                        child: InkWell(
                          onTap: () => loadProduct(),
                          child: Image.asset(
                            imageAssetPath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
                child: Column(
                  children: <Widget>[
                    Padding(
                      
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: 150,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              color: Colors.lightGreen,
                              image: DecorationImage(
                                image: AssetImage('assets/images/packages/package1.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 16,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.add_shopping_cart_rounded),
                                  onPressed: () {},
                                  color: Colors.green,
                                  iconSize: 60,
                                ),
                                SizedBox(width: 10), // Adjust the spacing as needed
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "HOME MADE",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 30,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "Package of 3 sauces",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),




                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  loadProduct() {}
}
