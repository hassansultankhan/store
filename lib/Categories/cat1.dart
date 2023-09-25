import 'package:flutter/material.dart';

class Cat1 extends StatefulWidget {
  const Cat1({Key? key}) : super(key: key);

  @override
  State<Cat1> createState() => _Cat1State();
}

class _Cat1State extends State<Cat1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cat 1'),
        backgroundColor: Color.fromARGB(255, 192, 100, 0),
      ),

      // body: ListView.builder(
      //   itemCount: ,
      //   itemBuilder: (BuildContext c, int index){

      //   }

      //   ),
    );
  }
}
