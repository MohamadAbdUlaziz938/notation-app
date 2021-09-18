import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note/note/dialogs/loading-dialog.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:note/note/dialogs/message-dialog.dart';
import 'package:provider/provider.dart';

import '../auth-state.dart';

class Login extends StatefulWidget {
  static const ROUTE = "signin";
  Login({Key key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var mypassword, myemail;
  GlobalKey<FormBuilderState> formstate = new GlobalKey<FormBuilderState>();
  signIn(BuildContext context) async {
    var formdata = formstate.currentState;
    if (formdata.validate()) {
      formdata.save();
      try {
        LoadingDialog.show();
        await context
            .read<AuthState>()
            .logIn(Map.from(formstate.currentState.value));
        LoadingDialog.hide();
        if (context
            .read<AuthState>().getUser != null) {
          Navigator.of(context).pushNamedAndRemoveUntil("home", (_) => false);
        }
        //return userCredential;
      } catch (e) {
        LoadingDialog.hide();
        if (e.code == 'user-not-found') {
          print("not");
          // Navigator.of(context).pop();
          // AwesomeDialog(
          //     context: context,
          //     title: "Error",
          //     body: Text("No user found for that email"))
          //   ..show();
          showMessageDialog(context, "No user found for that email");
        } else if (e.code == 'wrong-password') {
          showMessageDialog(context, "Wrong password provided for that user");
        }
        else if (e.code == 'too-many-requests') {
          showMessageDialog(context, "too-many-requests");
        }
      }
    } else {
      print("Not Vaild");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: [
          SizedBox(
            height: 50,
          ),
          Center(child: Image.asset("assets/images/logo.png")),
          Container(
            padding: EdgeInsets.all(20),
            child: FormBuilder(
                key: formstate,
                child: Column(
                  children: [
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
                          prefixIcon: Icon(Icons.person_outline),
                          labelText: "Email",
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
                          prefixIcon: Icon(Icons.lock_outline),
                          //hintText: "password",
                          labelText: "Password",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1))),
                    ),
                    Container(
                        margin: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text("if you havan't accout "),
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushReplacementNamed("register");
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
                        await signIn(context);
                      },
                      child: Text(
                        "Sign in",
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
