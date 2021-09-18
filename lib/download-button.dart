import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:note/transfers/transfer-queue/transfer-queue.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'note/dialogs/message-dialog.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

void appRunner() {
  runApp(
    MyApp(),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  await Firebase.initializeApp();

  appRunner();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DownLoadButton(),
      theme: ThemeData(
          primaryColor: Colors.blue,
          buttonColor: Colors.blue,
          textTheme: TextTheme(
            headline6: TextStyle(fontSize: 20, color: Colors.white),
            headline5: TextStyle(fontSize: 30, color: Colors.blue),
            bodyText2: TextStyle(fontSize: 20, color: Colors.black),
          )),
    );
  }
}

class DownLoadButton extends StatefulWidget {
  const DownLoadButton({Key key}) : super(key: key);

  @override
  _DownLoadButtonState createState() => _DownLoadButtonState();
}

class _DownLoadButtonState extends State<DownLoadButton> {
  int progress = 0;
  ReceivePort _recievePort = ReceivePort();
  static downLoadingCallBack(id, status, progress) {
    SendPort sendPort = IsolateNameServer.lookupPortByName("downloading");
    sendPort.send([id, status, progress]);
  }

  @override
  void initState() {
    //WidgetsFlutterBinding.ensureInitialized();
    // TODO: implement initState
    //await FlutterDownloader.initialize();
    super.initState();
    IsolateNameServer.registerPortWithName(
        _recievePort.sendPort, "downloading");
    _recievePort.listen((message) {
      setState(() {
        print("==================");
        print(message[2]);
        progress = message[2];
        print("==================");

      });
      print(progress);
    });
    FlutterDownloader.registerCallback(downLoadingCallBack);


  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${progress}",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20,),
          Center(
            child: RaisedButton(
              onPressed: () async {
                final appName = "note";
                String destination;
                if (Platform.isAndroid) {
                  if (await Permission.storage.request().isGranted) {
                    destination = '/storage/emulated/0/Download';
                  } else {
                    showMessageDialog(context,
                        ('$appName needs storage permissions in order to download files. You can grant this permission from app settings.'));
                  }
                } else {
                  destination = (await getApplicationDocumentsDirectory()).path;
                }
                if (destination != null) {
                  //transfers.addDownload("https://firebasestorage.googleapis.com/v0/b/note-40b44.appspot.com/o/images%2F73204image_picker8768255562701321956.jpg?alt=media&token=86f2c920-4ee0-46b6-8c3f-eaeaf571b0a4", '$destination/${"entry.name"}');
                  String url =
                      "https://firebasestorage.googleapis.com/v0/b/note-40b44.appspot.com/o/images%2F73204image_picker8768255562701321956.jpg?alt=media&token=86f2c920-4ee0-46b6-8c3f-eaeaf571b0a4";
                  try {
                    final taskId = await FlutterDownloader.enqueue(
                      //url: api.previewUrl(entry),
                      url: url,
                      //headers: api.http.authHeaders,
                      fileName: basename("$destination/entryname"),
                      savedDir: dirname("$destination/entryname"),
                      showNotification:
                          true, // show download progress in status bar (for Android)
                      openFileFromNotification:
                          true, // click on notification to open downloaded file (for Android)
                      //openFileFromNotification: true, // click on notification to open downloaded file (for Android)

                    );

                    print("done");
                    print(taskId);
                  } catch (e) {}
                  //   entries.forEach((entry) {
                  // });
                  //driveState.deselectAll();

                  // showSnackBar(
                  // trans('Queued :count items for download.', replacements: {'count': entries.length.toString()}),
                  // context,
                  // action: SnackBarAction(label: trans('View'), onPressed: () {
                  // rootNavigatorKey.currentState.pushNamed(TransfersScreen.ROUTE);
                  // }),
                  //
                  // );
                }
              },
              child: Text("download"),
            ),
          ),
        ],
      ),
    );
  }
}
