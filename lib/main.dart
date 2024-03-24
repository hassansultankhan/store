import 'package:estore/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // incase extra time is required for any services to load use delay for splash screen.
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // // await Future.delayed(Duration(seconds: 5));
  // // FlutterNativeSplash.remove() ;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'eStore',
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontFamily: 'Poppins regular', // default font family
            fontWeight: FontWeight.w600, //  default font weight
          ),
        ),
      ),
      home: loginScreen(),
    );
  }
}
