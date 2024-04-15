import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:estore/signupScreen.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:quiver/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'navigationScreen.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool log = false;
  String guestName = '';

  @override
  void initState() {
    super.initState();
    loginStatusCheck();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(
          255, 14, 41, 0), // Change this color to your desired color
    ));

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/item_list/sauce_2.png"),
              fit: BoxFit.cover),
        ),
        child: Center(
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              color: Color.fromRGBO(106, 235, 50, 0.698),
            ),
            height: 300,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(fixedSize: Size(240, 50)),
                  onPressed: () => _handleGoogleSignIn(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sign in with Google',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                        ),
                        width: 40,
                        height: 40,
                        padding: EdgeInsets.all(5),
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/icons/google.png"),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () => signin(context),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            4.0), // Adjust the radius as needed
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 87, 215, 252)),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Ink.image(
                        image: AssetImage("assets/icons/store_signin.jpg"),
                        fit: BoxFit.cover,
                        width: 198,
                        height: 50,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.65),
                            borderRadius: BorderRadius.all(
                              Radius.elliptical(3, 3),
                            )),
                        height: 25,
                        width: 200,
                      ),
                      const Text(
                        "Sign in with Store Account",
                        style: TextStyle(
                          color: Colors.black, // Set text color as needed
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  //this function will assign new guest name and save it to firestore "guests" collection
                  //also it will save it to sharedPreferance
                  //so that it checks if there is already a guest name assigned to application.

                  onTap: () async {
                    if (guestName.isEmpty) {
                      guestName = await generateUniqueGuestName();
                      saveGuestNameToSharedPreferences(guestName);
                      saveGuestToFirestore(guestName);
                    }

                    // ignore: use_build_context_synchronously
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => navigationScreen(
                          displayName: guestName,
                          email: 'No email provided',
                          photoUrl: '',
                          callbackSauceScreenStatus: false,
                        ),
                      ),
                      (route) =>
                          false, // This is the predicate to stop popping routes
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white, // Set border color
                            width: 3, // Set border width
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              AssetImage("assets/images/Carrot_icon.png"),
                        ),
                      ),
                      SizedBox(width: 7),
                      Container(
                        alignment: Alignment.center,
                        width: 158,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadiusDirectional.horizontal(
                              end: Radius.circular(20)),
                        ),
                        child: const Text(
                          'Sign in as guest',

                          //give text green color

                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      print(log);
      // Sign out from Google Sign-In (clear previous credentials)
      if (log == true) {
        print('signing out');
        await _googleSignIn.signOut();
      }
      print("process start");

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print("sign in step 1");
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      print("sign in step 2");
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        log = await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => navigationScreen(
              displayName: user.displayName ?? '',
              email: user.email ?? '',
              photoUrl: user.photoURL ?? '',
              callbackSauceScreenStatus: false,
            ),
          ),
          (Route) => false,
        );

        print('$log');

        // Check at database
        saveGoogleProfile(user);
      }
    } catch (error, stackTrace) {
      print('Error signing in with Google: $error');
      print(stackTrace);
      // Handle the error here
    }
  }

  void signin(BuildContext context) {
    // Check if the user is already logged in
    User? user = _auth.currentUser;
    if (user != null) {
      // User is already logged in, navigate to navigationScreen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => navigationScreen(
            displayName: user.displayName ?? '',
            email: user.email ?? '',
            photoUrl: user.photoURL ?? '',
            callbackSauceScreenStatus: false,
          ),
        ),
        (route) => false,
      );
    } else {
      // User is not logged in, show the sign-in dialog

      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.top,
              ),
            );
            return Wrap(children: [
              ListTile(
                leading: Icon(Icons.login),
                title: Text('Sign In'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  // Show the sign-in AlertDialog
                  showSignInDialog(context);
                  print("object");
                },
              ),
              ListTile(
                  leading: Icon(Icons.person_add),
                  title: Text('Sign Up'),
                  onTap: () async {
                    Navigator.pop(context); // Close the bottom sheet
                    final success = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );

                    if (success == true) {
                      // Handle successful sign up (you can show a success message here)
                    }
                  }),
              // const SizedBox(height: 150,)
            ]);
          });
    }
  }

  void showSignInDialog(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    bool isLoading = false;
    String errorText = '';

    Future.delayed(Duration(milliseconds: 100), () {
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Sign In'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    isLoading
                        ? CircularProgressIndicator()
                        : SizedBox(
                            height: 0), // Hide the indicator when not loading
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    SizedBox(height: 10),
                    // Inside the StatefulBuilder's builder function
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        errorText,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Close the sign-in dialog
                        // Implement password recovery logic
                        sendLoginInformation(context, emailController.text);
                      },
                      child: const Text(
                        'Forgot your password?',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the sign-in dialog
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });

                            String email = emailController.text;
                            String password = passwordController.text;

                            try {
                              UserCredential userCredential = await FirebaseAuth
                                  .instance
                                  .signInWithEmailAndPassword(
                                email: email,
                                password: password,
                              );

                              // Successfully signed in
                              //If the sign-in is successful (i.e., the email and password are correct),
                              // a UserCredential object is returned, containing information about the user.
                              User? user = userCredential.user;
                              if (user != null) {
                                // ignore: use_build_context_synchronously
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => navigationScreen(
                                      displayName: user.displayName ?? '',
                                      email: user.email ?? '',
                                      photoUrl: user.photoURL ?? '',
                                      callbackSauceScreenStatus: false,
                                    ),
                                  ),
                                );
                              }
                            } catch (error) {
                              setState(() {
                                isLoading = false;
                                if (error is FirebaseAuthException) {
                                  if (error.code == 'user-not-found') {
                                    errorText =
                                        'There is no account against this email.';
                                  } else if (error.code == 'wrong-password') {
                                    errorText = 'Wrong password.';
                                  } else {
                                    errorText =
                                        'An error occurred. Please try again.';
                                  }
                                }
                              });
                            }
                          },
                          child: Text('Sign In'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    });
  }

  void sendLoginInformation(BuildContext context, String emailValue) {
    showDialog(
      context: context,
      builder: (context) {
        String errorMessage =
            ''; // Add this variable to store the error message
        return AlertDialog(
          title: Text('Confirmation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Are you sure you want to send related information to your email?',
              ),
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ), // Display error message here
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Implement the logic to send login information to the user's email
                try {
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(email: emailValue);
                  Navigator.pop(context); // Close the dialog
                  // ignore: use_build_context_synchronously
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Email Sent'),
                      content: const Text(
                          'Check your email account for login-related information.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the alert dialog
                          },
                          child: Text('Close'),
                        ),
                      ],
                    ),
                  );
                } catch (error) {
                  setState(() {
                    errorMessage = 'An error occurred while sending the email.';
                  });
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void loginStatusCheck() async {
    final SharedPreferences loginStatus = await SharedPreferences.getInstance();
    bool isLoggedIn = loginStatus.getBool('login') ?? false;

    if (isLoggedIn) {
      // If the user has logged in, retrieve the guest name from shared preferences
      String? guestName = loginStatus.getString('guestName');
      if (guestName != null && guestName.isNotEmpty) {
        // Navigate to navigationScreen with the retrieved guest name
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => navigationScreen(
              displayName: guestName,
              email: 'No email provided',
              photoUrl: '',
              callbackSauceScreenStatus: false,
            ),
          ),
          (route) => false,
        );
      }
    }
  }

  Future<String> saveGuestToFirestore(String guestName) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Check if the guest name already exists in Firestore
    bool exists = await checkIfGuestExists(guestName);

    if (!exists) {
      // If the guest name doesn't exist, save it to Firestore
      await firestore.collection('guests').add({
        'name': guestName,
        // Add any other guest information you want to save
      });

      // Save the guest name to shared preferences
      await saveGuestNameToSharedPreferences(guestName);

      return guestName; // Return the original guest name
    } else {
      // If the guest name already exists in Firestore, retrieve and return it
      return guestName;
    }
  }

  Future<void> saveGuestNameToSharedPreferences(String guestName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('guestName', guestName);
  }

  Future<bool> checkIfGuestExists(String guestName) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await firestore
        .collection('guests')
        .where('name', isEqualTo: guestName)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<String> generateUniqueGuestName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if the guest name is already stored in shared preferences
    String storedGuestName = prefs.getString('guestName') ?? '';

    if (storedGuestName.isNotEmpty) {
      return storedGuestName;
    } else {
      // If the guest name is not stored, generate a new one
      int randomNumber = Random().nextInt(100000) + 1;
      String newGuestName = 'Guest_$randomNumber';

      // Save the new guest name to shared preferences
      await prefs.setString('guestName', newGuestName);

      return newGuestName;
    }
  }

  // Check at database

  Future<void> saveGoogleProfile(User user) async {
    try {
      print("execution of google profile save code");
      CollectionReference googleProfileCollection =
          FirebaseFirestore.instance.collection('googleProfile');
      Map<String, dynamic> googleProfileData = {
        'displayName': user.displayName,
        'email': user.email,
      };
      await googleProfileCollection.add(googleProfileData);
    } catch (error) {
      print('Error saving google profile: $error');
    }
  }
}
