import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
class AnonymousLogIn extends StatelessWidget {
  UserCredential userCredential;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: RaisedButton(
              onPressed: ()async{
                userCredential= await FirebaseAuth.instance.signInAnonymously();
              },
              child: Text("Signin"),
            ),
          )
        ],
      ),
    );
  }
}

