// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter/material.dart';
// class GoogleSignIn extends StatefulWidget {
//   @override
//   _GoogleSignInState createState() => _GoogleSignInState();
// }
//
// class _GoogleSignInState extends State<GoogleSignIn> {
//   Future<UserCredential> signInWithGoogle() async {
//     // Trigger the authentication flow
//     final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
//
//     // Obtain the auth details from the request
//     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//
//     // Create a new credential
//     final credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );
//
//     // Once signed in, return the UserCredential
//     return await FirebaseAuth.instance.signInWithCredential(credential);
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Center(
//             child: RaisedButton(
//               onPressed: ()async{
//                 UserCredential userCredential=await signInWithGoogle() ;
//               },
//               child: Text("Signin"),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
