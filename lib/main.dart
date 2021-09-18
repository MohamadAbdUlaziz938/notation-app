import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:note/auth/auth-state.dart';
import 'package:note/note/http/file-entry-api.dart';
import 'package:note/note/state/file-entry.dart';
import 'package:note/note/state/note-state.dart';
import 'package:note/routs.dart';
import 'package:note/transfers/downloads/download-manager.dart';
import 'package:note/transfers/transfer-queue/transfer-queue.dart';
import 'package:note/utils/local-storage.dart';
import 'package:provider/provider.dart';
import 'auth/screen/signin.dart';
import 'config/app-config.dart';
import 'custom-tab-bar.dart';
import 'note/screens/file-list/root_screen.dart';
import 'note/state/entry_cach.dart';
import 'note/state/root-navigator-key.dart';
import 'notification/notification.dart';

bool islogin;

Future backgroudMessage(RemoteMessage message) async {
  print("=================== BackGroud Message ========================");
  print("${message.notification.body}");
}

void appRunner(AppConfig appConfig) async {
  final httpClient = appConfig.httpClient;
  final localStorage = await LocalStorage().init();
  final fileEntryApi = FileEntryApi(httpClient);
  final downloadManager = DownloadManager(api: fileEntryApi);
  await downloadManager.init();
  final notifications = Notifications(httpClient);
  final authState = AuthState(httpClient);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthState>.value(value: authState),
        Provider.value(value: httpClient),
        Provider.value(value: appConfig),
        Provider.value(value: localStorage),
        Provider.value(value: notifications),
        Provider.value(value: fileEntryApi),
        Provider(
            create: (context) =>
                EntryCache(localStorage, FirebaseAuth.instance.currentUser)),
        Provider.value(value: downloadManager),
        ChangeNotifierProvider<NoteState>(
            create: (context) => NoteState(
                  api: fileEntryApi,
                  entryCache: context.read<EntryCache>(),
                )),
        ChangeNotifierProvider<TransferQueue>(
            create: (context) => TransferQueue(
                downloader: downloadManager,
                localStorage: localStorage,
                notifications: notifications)),
        ChangeNotifierProvider<FileEntry>(create: (context) => FileEntry()),
      ],
      child: MyApp(),
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //this function must be in top level this for bachground state and terminate state
  FirebaseMessaging.onBackgroundMessage(backgroudMessage);
  final appConfig = await AppConfig().init();
  var user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    islogin = false;
  } else {
    islogin = true;
  }
  appRunner(appConfig);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: rootNavigatorKey,
      initialRoute: islogin ? RootScreen.ROUTE : Login.ROUTE,
      //home: CustomTabBar(),
      theme: ThemeData(
          // fontFamily: "NotoSerif",
          primaryColor: Color(0xFF21BFBD),
          buttonColor: Colors.blue,
          scaffoldBackgroundColor: Color(0xFF21BFBD),
          iconTheme: IconThemeData(color: Colors.white),
          textTheme: TextTheme(
            headline6: TextStyle(fontSize: 20, color: Colors.white),
            headline5: TextStyle(fontSize: 30, color: Colors.blue),
            bodyText2: TextStyle(fontSize: 20, color: Colors.black),
          )),

      onGenerateRoute: (RouteSettings settings) => buildRoute(settings),
    );
  }
}
