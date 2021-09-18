import 'dart:convert';


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;

class messaging extends StatefulWidget {
  static const ROUTE="notification";
  const messaging({Key key}) : super(key: key);

  @override
  _messagingState createState() => _messagingState();
}

class _messagingState extends State<messaging> {
  var fbm = FirebaseMessaging.instance;


  final String serverToken =
      'AAAAVRuDE5M:APA91bGWYhAnyZTZeViDSN-siGGUqFweQtm5uqNBiINtLcF7oWZx3a7_V3pKGghxCTm7v0yP0EKO8XkXPzHtCcUMN8yW64Co72cjG-fb6tNmFD9UNghZXfs7ij-_oI_3DjcKdZ7hpqBF';
  sendAndRetrieveMessage(int id, String title, String body) async {
    // await firebaseMessaging.requestNotificationPermissions(
    //   const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
    // );

    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': id.toString(),
            'status': 'done'
          },
          'to': await FirebaseMessaging.instance.getToken(),
        },
      ),
    );

    // final Completer<Map<String, dynamic>> completer =
    // Completer<Map<String, dynamic>>();
    //
    // firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     completer.complete(message);
    //   },
    // );

    //return completer.future;
  }

  initialMessage() async {
    //this uses when app in terminate state what happen when we press on it
    var message =await FirebaseMessaging.instance.getInitialMessage();
    //which means we press on notification
    if (message != null) {
      print("????????????????????????");
      print(message);
      Navigator.of(context).pushNamedAndRemoveUntil("home", (_) => false);
    }
  }

  //we use this in apple phone and call it in inial state
  requestPermision() async {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //get mobile token
    //notificarion when app in background accesses and in terminate
    //but when it in foreground not not appear but accesses
    fbm.getToken().then((value) => {print(value)});
    //this uses when app in foreground to applay an event when notification accesses
    FirebaseMessaging.onMessage.listen((event) {
      print("==========notification foreground=============");
      print(event.notification.body);
      print(event.notification.title);
      print(event.data["status"]);

    });

    //what happen when we press on message when our app in background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("=========================");
      print(event.notification.body);
      //Navigator.of(context).pushNamedAndRemoveUntil("home", (_) => false);
    });
    //
   initialMessage();
    //
    requestPermision();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(child: Text("send notification"),onPressed: (){
          sendAndRetrieveMessage(1,"title","body");
        },),
      ),
    );
  }
}
