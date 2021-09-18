import 'dart:convert';

import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:note/note/http/app-http-client.dart';
import 'package:note/notification/payloads/notification-payload.dart';
import 'package:note/transfers/transfer-screen/transfer-screen.dart';

import 'notification-id.dart';

class Notifications {
  Notifications(this.http) {
    _initFirebaseMessaging(this);
    _initLocalNotifications(local, _onSelectNotification);
  }
  final AppHttpClient http;
  final local = FlutterLocalNotificationsPlugin();
  final fcm = FirebaseMessaging.instance;

  notify(String title, {String body, String payload, int localId, int progress,bool runSound=false})async {
    if (runSound){FlutterRingtonePlayer.playNotification(asAlarm: true);}
    final platformChannelSpecifics = NotificationDetails(
      android: _androidNotifDetails(progress,runsound: runSound),
      iOS: IOSNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: runSound,
      ),
    );
    if (localId == null) {
      localId = new Random().nextInt(10000);
    }
   await local.show(localId, title, body, platformChannelSpecifics, payload: payload);
  }

  cancel(int notifId) {
    local.cancel(notifId);

  }
}

Future<dynamic> _onSelectNotification(String encodedPayload) async {
  //final state = rootNavigatorKey.currentContext.read<DriveState>();
  //state.payload = NotificationPayload.fromRawJson(encodedPayload);
  final payload = NotificationPayload.fromRawJson(encodedPayload);
  if (payload.notifId == NotificationType.transferProgress) {
     TransfersScreen.open();
     //rootNavigatorKey.currentState.pushNamed(TransfersScreen.ROUTE);

    //Navigator.of(context).push();
  }
  // else if (payload.notifId == NotificationType.fileShared) {
  //   final fileNotifPayload = FileSharedNotifPayload.fromRawJson(encodedPayload);
  //   if (state.activePage is! SharesPage) {
  //     rootNavigatorKey.currentState.pushNamed(SharedScreen.ROUTE);
  //   }
  //   if ( ! fileNotifPayload.multiple) {
  //     final entry = state.entryCache.get(fileNotifPayload.entryId);
  //     if (entry != null) {
  //       //FilePreviewScreen.open(state.entryCache.get(fileNotifPayload.entryId));
  //     }
  //   }
  // }
}
_initFirebaseMessaging(Notifications notifs) async {
  //request permision for ios
  // NotificationSettings notificationSettings=await notifs.fcm.requestPermission(
  //   sound: true
  // );
  //await FirebaseMessaging.instance.requestNotificationPermissions(IosNotificationSettings(sound: false));
  FirebaseMessaging.onMessage.listen((msg) async{
    print("===========title========");
    print(msg.notification.title);
    notifs.notify(msg.notification.title, body: msg.notification.body, payload: json.encode(msg.data));
  }) ;
  // notifs.fcm.configure(
  //   onMessage: (Map<String, dynamic> msg) async {
  //     notifs.notify(msg['notification']['title'], body: msg['notification']['body'], payload: json.encode(msg['data']));
  //   },
  //   onLaunch: (Map<String, dynamic> msg) async {
  //     _onSelectNotification(json.encode(msg['data']));
  //   },
  //   onResume: (Map<String, dynamic> msg) async {
  //     _onSelectNotification(json.encode(msg['data']));
  //   },
  // );
}

Future<bool> _initLocalNotifications(FlutterLocalNotificationsPlugin local, SelectNotificationCallback callback) {
  const initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  final initializationSettingsIOS =  IOSInitializationSettings(
    defaultPresentAlert: false,
    defaultPresentBadge: true,
    defaultPresentSound: false,

  );
  final initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  return local.initialize(
      initializationSettings,
      onSelectNotification: callback
  );
}

AndroidNotificationDetails _androidNotifDetails(int progress,{bool runsound=false}) {

  return AndroidNotificationDetails(
    'default', 'default', 'Default channel for the app.',
    importance: Importance.defaultImportance,
    priority: Priority.defaultPriority,

    //showWhen: true,
    category: 'social',
    playSound: runsound,
    fullScreenIntent: true,
    enableVibration: false,
    showProgress: progress != null,
    maxProgress: 100,
    progress: progress,
  );
}