

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:note/auth/auth-state.dart';
import 'package:note/note/dialogs/cofirm-dialog.dart';
import 'package:note/note/screens/editnotes.dart';
import 'package:note/note/screens/file-list/file-preview/file-preview-note.dart';
import 'package:note/note/state/file_pages.dart';
import 'package:note/note/state/note.dart';
import 'package:provider/provider.dart';

import 'base_file_list_screen.dart';
/*
class RootScreen extends StatefulWidget {
  static const ROUTE="home";
  //static const ROUTE = '/';
  RootScreen({Key key}) : super(key: key);

  @override
  _RootScreen createState() => _RootScreen();
}

class _RootScreen extends State<RootScreen> {
  CollectionReference notesref = FirebaseFirestore.instance.collection("notes");

  getUser() {
    //get current user
    var user = FirebaseAuth.instance.currentUser;
    print(user.email);
  }

  var fbm = FirebaseMessaging.instance;


 initalMessage() async {

   var message =   await FirebaseMessaging.instance.getInitialMessage() ;

   if (message != null){

     Navigator.of(context).pushNamed("addnotes") ;

   }

 }


 requestPermssion() async {

    FirebaseMessaging messaging = FirebaseMessaging.instance;

      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        print('User granted provisional permission');
      } else {
        print('User declined or has not accepted permission');
      }

 }

 
  @override
  void initState() {
    requestPermssion() ;
     initalMessage() ;
    fbm.getToken().then((token) {
      print("=================== Token ==================");
      print(token);
      print("====================================");
    });




    FirebaseMessaging.onMessage.listen((event) {
      print("===================== data Notification ==============================") ;

      //  AwesomeDialog(context: context , title: "title" , body: Text("${event.notification.body}"))..show() ;

      Navigator.of(context).pushNamed("addnotes") ;

    }) ;


   // getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   return

    //   floatingActionButton: FloatingActionButton(
    //       backgroundColor: Theme.of(context).primaryColor,
    //       child: Icon(Icons.add),
    //       onPressed: () {
    //         Navigator.of(context).pushNamed("addNote");
    //       }),
    //   body:
     FutureBuilder(
               future: notesref
                   .where("userid",
                       isEqualTo: FirebaseAuth.instance.currentUser.uid)
                   .get(),
               builder: (context, snapshot) {
                 if (snapshot.hasData) {
                   return ListView.builder(
                     physics:BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics(),),
                     addAutomaticKeepAlives: true,
                     clipBehavior: Clip.antiAliasWithSaveLayer,
                       itemCount: snapshot.data.docs.length,
                       itemBuilder: (context, i) {
                        // Note.fromJson(snapshot.data.docs[i]);
                         return ListNotes(
                             note: Note.fromJson(snapshot.data.docs[i]));
                        //  return Dismissible(
                        //      onDismissed: (diretion) async {
                        //        await notesref
                        //            .doc(snapshot.data.docs[i].id)
                        //            .delete();
                        //        await FirebaseStorage.instance
                        //            .refFromURL(snapshot.data.docs[i]['imageurl'])
                        //            .delete()
                        //            .then((value) {
                        //          print("=================================");
                        //          print("Delete");
                        //        });
                        //      },
                        //      key: UniqueKey(),
                        //      child: ListNotes(
                        //        note: Note.fromJson(snapshot.data.docs[i]),
                        //        //docid: snapshot.data.docs[i].id,
                        //      ));
                       });
                 }
                 return Center(child: CircularProgressIndicator());
               });
  }
}*/


class RootScreen extends BaseFileListScreen {
  static const ROUTE = '/';
  final page = RootFolderPage();
}
