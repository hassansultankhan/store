import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'navigationScreen.dart';

class loginScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => navigationScreen(
              displayName: user.displayName ?? '',
              email: user.email ?? '',
              photoUrl: user.photoURL ?? '',
            ),
          ),
        );
      }
    } catch (error) {
      print('Error signing in with Google: $error');
      // Handle the error here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _handleGoogleSignIn(context),
          child: Text('Sign in with Google'),
        ),
      ),
    );
  }
}
