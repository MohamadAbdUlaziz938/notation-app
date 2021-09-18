
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:note/note/dialogs/loading-dialog.dart';
import 'package:note/note/dialogs/message-dialog.dart';
import 'package:provider/provider.dart';
import '../auth-state.dart';

class SignUp extends StatefulWidget {
  static const ROUTE = "register";
  SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var myusername, mypassword, myemail;
  GlobalKey<FormBuilderState> formstate = new GlobalKey<FormBuilderState>();

  signUp(BuildContext context) async {
    var formdata = formstate.currentState;
    if (formdata.validate()) {
      ///to store values in variables
      formdata.save();

      try {
        LoadingDialog.show();
        UserCredential userCredential = await context
            .read<AuthState>()
            .register(Map.from(formstate.currentState.value));
        if (context.read<AuthState>().getUser != null) {

          Navigator.of(context).pushNamedAndRemoveUntil("home", (_) => false);
        }
        LoadingDialog.hide();
      } on FirebaseAuthException catch (e) {
        LoadingDialog.hide();
        if (e.code == 'weak-password') {
          showMessageDialog(context, "Password is too weak");
        } else if (e.code == 'email-already-in-use') {
          //Navigator.of(context).pop();
          // AwesomeDialog(
          //     context: context,
          //     title: "Error",
          //     body: Text("The account already exists for that email"))
          //   ..show();
          showMessageDialog(
              context, "The account already exists for that email");
        }
      } catch (e) {
        print(e);
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 100),
          Center(child: Image.asset("assets/images/logo.png")),
          Container(
            padding: EdgeInsets.all(20),
            child: FormBuilder(
                key: formstate,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: "username",
                      onSaved: (val) {
                        myusername = val;
                      },
                      validator: (val) {
                        if (val.length > 100) {
                          return "username can't to be larger than 100 letter";
                        }
                        if (val.length < 2) {
                          return "username can't to be less than 2 letter";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: "username",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1))),
                    ),
                    SizedBox(height: 20),
                    FormBuilderTextField(
                      name: "email",
                      onSaved: (val) {
                        myemail = val;
                      },
                      validator: (val) {
                        if (val.length > 100) {
                          return "Email can't to be larger than 100 letter";
                        }
                        if (val.length < 2) {
                          return "Email can't to be less than 2 letter";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined),
                         // hintText: "email",
                          labelText: "Password",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1))),
                    ),
                    SizedBox(height: 20),
                    FormBuilderTextField(
                      name: "password",
                      onSaved: (val) {
                        mypassword = val;
                      },
                      validator: (val) {
                        if (val.length > 100) {
                          return "Password can't to be larger than 100 letter";
                        }
                        if (val.length < 4) {
                          return "Password can't to be less than 4 letter";
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock_open_outlined),
                          //hintText: "password",
                          labelText: "Password",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1))),
                    ),
                    Container(
                        margin: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text("if you have Account "),
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushReplacementNamed("signin");
                              },
                              child: Text(
                                "Click Here",
                                style: TextStyle(color: Colors.blue),
                              ),
                            )
                          ],
                        )),
                    Container(
                        child: RaisedButton(
                      textColor: Colors.white,
                      onPressed: () async {
                        await signUp(context);
                        //print("===================");
                        // if (response != null) {
                        //   await FirebaseFirestore.instance
                        //       .collection("users")
                        //       .add({"username": myusername, "email": myemail});
                        //   Navigator.of(context)
                        //       .pushNamedAndRemoveUntil("home",(_)=>false);
                        // } else {
                        //   print("Sign Up Faild");
                        // }
                        // print("===================");
                      },
                      child: Text(
                        "Sign Up",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ))
                  ],
                )),
          )
        ],
      ),
    );
  }
}
