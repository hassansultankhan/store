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
    {
      'imagePath': 'assets/images/packages/package1.jpg',
      'fontColor': Color.fromARGB(255, 87, 10, 10),
      'title': 'HOME MADE',
      'subtitle': 'Package of 3 sauces',
    },
    {
      'imagePath': 'assets/images/packages/package2.jpg',
      'fontColor': Color.fromARGB(255, 87, 10, 10),
      'title': 'IMPORTED YUMS',
      'subtitle': 'Package of 6',
    },
    {
      'imagePath': 'assets/images/packages/package3.jpg',
      'fontColor': Color.fromARGB(255, 87, 10, 10),
      'title': 'FASTFOOD DELICIAS',
      'subtitle': 'Package of 5',
    },
    {
      'imagePath': 'assets/images/packages/package4.jpg',
      'fontColor': Color.fromARGB(255, 87, 10, 10),
      'title': 'SPECIAL OFFERS',
      'subtitle': 'Limited Offer',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 189, 223, 207),
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
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: packageData.length,
                  itemBuilder: (context, index) {
                    final data = packageData[index];
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 20.0),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  color: Colors.lightGreen,
                                  image: DecorationImage(
                                    image: AssetImage(data['imagePath']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                left: 16,
                                child: Container(
                                  child: DecoratedBox(
                                    decoration:
                                        //set color to traslucent white
                                        BoxDecoration(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 0.5)),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                              Icons.add_shopping_cart_rounded),
                                          onPressed: () {},
                                          color: const Color.fromARGB(
                                              255, 16, 219, 23),
                                          iconSize: 50,
                                        ),
                                        // SizedBox(width: 5),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data['title'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20,
                                                color: data["fontColor"],
                                              ),
                                            ),
                                            Text(
                                              data['subtitle'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20,
                                                color: data["fontColor"],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 10)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
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
