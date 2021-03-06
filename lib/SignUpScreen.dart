import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_study_app/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  bool _isObscure1 = true;
  bool _isObscure2 = true;
  bool _visibilityErr1 = false;
  bool _visibilityErr2 = false;
  //Create the textfield controller
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _repasswordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // ignore: avoid_unnecessary_containers
    return Scaffold(
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          height: size.height,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                    child: Center(
                  child: Image(
                    image: AssetImage("assets/images/background_signup.png"),
                    width: 210,
                    height: 210,
                  ),
                )),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Please enter the detail to continue!",
                      style: TextStyle(color: Colors.pink, fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                      child: TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                            hintText: "Username",
                            prefixIcon: Icon(Icons.supervised_user_circle,
                                color: Color.fromRGBO(80, 207, 116, 1))),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            hintText: "User Email",
                            prefixIcon: Icon(Icons.mail,
                                color: Color.fromRGBO(80, 207, 116, 1))),
                      ),
                    ),
                    const SizedBox(height: 0),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                      child: TextField(
                          controller: _passwordController,
                          obscureText: _isObscure1,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                              hintText: "Enter password",
                              prefixIcon: const Icon(Icons.lock,
                                  color: Color.fromRGBO(80, 207, 116, 1)),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isObscure1 = !_isObscure1;
                                    });
                                  },
                                  icon: Icon(_isObscure1
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  color:
                                      const Color.fromARGB(255, 2, 67, 119)))),
                    ),
                    const SizedBox(height: 0),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                      child: TextField(
                        controller: _repasswordController,
                        obscureText: _isObscure2,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                            hintText: "Retype password",
                            prefixIcon: const Icon(
                                Icons.replay_circle_filled_sharp,
                                color: Color.fromRGBO(80, 207, 116, 1)),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isObscure2 = !_isObscure2;
                                  });
                                },
                                icon: Icon(_isObscure2
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                color: const Color.fromARGB(255, 2, 67, 119))),
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Warning email or password invalid
                    Visibility(
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                        child: Text(
                          'Please check your password again!',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                      visible: _visibilityErr1,
                    ),
                    //Warning invalid password
                    Visibility(
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                        child: Text(
                          'Please check your password again!',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                      visible: _visibilityErr2,
                    ),
                    const SizedBox(height: 8),
                    // ignore: sized_box_for_whitespace
                    Center(
                      child: SizedBox(
                          width: 150,
                          child: RawMaterialButton(
                            fillColor: Color.fromRGBO(13, 209, 33, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            onPressed: () {
                              //
                              //
                              //Create new account
                              createNewUser(context);
                            },
                            //
                            child: const Text(
                              "SignUp",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text("Don't forget your password!",
                            style: TextStyle(color: Colors.blue, fontSize: 16)),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.pink,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function add new uer
  void createNewUser(BuildContext context) {
    if (_passwordController.text == _repasswordController.text) {
      setState(() {
        _visibilityErr1 = false;
        _visibilityErr2 = false;
      });
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text)
          .then((value) {
        //Th??m user v?? firebase store
        addUserWithFirestore(_emailController.text, _usernameController.text);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const LoginScreen())); //Chuy???n v??? HomeScreen
      }).onError((error, stackTrace) {
        setState(() {
          _visibilityErr1 = true;
        });
        print("Error ${error.toString()}");
      });
    } else {
      setState(() {
        _visibilityErr1 = false;
        _visibilityErr2 = true;
      });
    }
  }

  //Create function create user for firestore:
  Future<void> addUserWithFirestore(String email, String username) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference addUsers =
        FirebaseFirestore.instance.collection('users');
    return addUsers
        .doc(user!.uid)
        .set({
          'email': email,
          'username': username,
        })
        // .add({
        //   'email': email,
        //   'username': username,
        // })
        .then((value) => print('User Added'))
        .catchError((e) => print("Failed to add user: $e"));
  }
}
