import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:note/firesotre.dart';
import 'package:note/firestorage.dart';
import 'package:note/routs.dart';

import 'auth/screen/register.dart';
import 'auth/screen/signin.dart';
import 'note/screens/addnotes.dart';
import 'note/screens/homepage.dart';



bool islogin;


Future backgroudMessage(RemoteMessage message) async {
  print("=================== BackGroud Message ========================") ;
  print("${message.notification.body}") ;
}

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  //FirebaseMessaging.onBackgroundMessage(backgroudMessage) ;

  var user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    islogin = false;
  } else {
    islogin = true;
  }
  //runApp(DevicePreview(builder: (context)=>MyApp(),enabled: !kReleaseMode,));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


        return MaterialApp(
          // navigatorObservers: [
          //   SentryNavigatorObserver(),
          // ],
          debugShowCheckedModeBanner: false,
          //home: islogin == false ? Login() : HomePage(),
          initialRoute: islogin?HomePage.ROUTE:Login.ROUTE,
           //home: FireStorage(),
          theme: ThemeData(
            // fontFamily: "NotoSerif",
              primaryColor: Colors.blue,
              buttonColor: Colors.blue,
              textTheme: TextTheme(
                headline6: TextStyle(fontSize: 20, color: Colors.white),
                headline5: TextStyle(fontSize: 30, color: Colors.blue),
                bodyText2: TextStyle(fontSize: 20, color: Colors.black),
              )),
          // routes: {
          //   "login": (context) => Login(),
          //   "signup": (context) => SignUp(),
          //   "homepage": (context) => HomePage(),
          //   "addnotes": (context) => AddNotes(),
          //   "testtwo": (context) => TestTwo()
          // },
          //key: rootNavigatorKey,
          onGenerateRoute: (RouteSettings settings) =>
              buildRoute(settings),
        );
    // return ScreenUtilInit(
    //   designSize: Size(360, 640),
    //   builder: () {
    //     return MaterialApp(
    //       debugShowCheckedModeBanner: false,
    //       home: islogin == false ? Login() : HomePage(),
    //       // home: Test(),
    //       theme: ThemeData(
    //         // fontFamily: "NotoSerif",
    //           primaryColor: Colors.blue,
    //           buttonColor: Colors.blue,
    //           textTheme: TextTheme(
    //             headline6: TextStyle(fontSize: 20, color: Colors.white),
    //             headline5: TextStyle(fontSize: 30, color: Colors.blue),
    //             bodyText2: TextStyle(fontSize: 20, color: Colors.black),
    //           )),
    //       routes: {
    //         "login": (context) => Login(),
    //         "signup": (context) => SignUp(),
    //         "homepage": (context) => HomePage(),
    //         "addnotes": (context) => AddNotes(),
    //         "testtwo": (context) => TestTwo()
    //       },
    //     );
    //   }
    // );
  }
}
