import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
        decoration: BoxDecoration(
            // image: DecorationImage(
            //     image: AssetImage("assets/images/background1.jpeg"),
            //     fit: BoxFit.fitHeight),
            ),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 0, 5),
                child: RichText(
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
            SizedBox(
              height: 25,
            ),
            Expanded(
            child: SingleChildScrollView(
              
              scrollDirection: Axis.vertical,

              child:
              Column(
       
                children: [
                  Row(
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
                                      color: Color.fromARGB(255, 4, 155, 9))),
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
                      SizedBox(width: 10,),
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
                                    
                  // Second ELement 

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 30),
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
                              fontWeight: FontWeight.w600,
                              color: Colors.black, // Default color
                            ),
                            children: [
                              TextSpan(
                                text: "SPICE it up\n",
                              ),
                              TextSpan(
                                  text: "with our ",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 4, 155, 9))),
                              TextSpan(
                                text: "hot sauce",
                                style: TextStyle(color: Color.fromARGB(255, 221, 114, 20)),
                              ),
                              
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 120,
                    color: Colors.green,
                  )

                  //Second element of scroll
                
                
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
}
