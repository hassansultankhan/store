import 'package:estore/navigationScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background1.jpeg"))),
        child: Center(
          child: Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.green,
                size: 60,
              ),
              const SizedBox(
                height: 15,
              ),
              const Text("Thank you for your order!",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
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
                child: const SizedBox(
                    width: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Home Screen',
                          style: TextStyle(
                            fontFamily: 'Poppins regular',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
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
        ),
      ),
    );
  }
}
