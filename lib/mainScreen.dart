import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class mainScreen extends StatefulWidget {
  const mainScreen({super.key});

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  String mainScreenTitle = "eStore";
  List<String> imageAssetPaths = [
    'assets/images/image1.jpeg',
    'assets/images/image2.jpeg',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:Container(
  
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            //create pictoral slider
            // Expanded(
            //   child:
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
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
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
            )
          ],
        ),
      ),

      // ),
    );
  }

  loadProduct() {}
}
