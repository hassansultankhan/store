import 'package:estore/navigationScreen.dart';
import 'package:flutter/material.dart';

class thankyou extends StatelessWidget {
  final String displayName_;
  final String email_;
  final String photoUrl_;

  const thankyou({
    Key? key,
    required this.displayName_,
    required this.email_,
    required this.photoUrl_,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: Colors.green,
            size: 60,
          ),
          const SizedBox(
            height: 15,
          ),
          const Text("Thank you for your order!",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => navigationScreen(
                      displayName: displayName_,
                      email: email_,
                      photoUrl: photoUrl_),
                ),
              );
            },
            child: SizedBox(
                width: 150,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Home Screen'),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )
                  ],
                )),
          ),
        ]),
      ),
    );
  }
}
