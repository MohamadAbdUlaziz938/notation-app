import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:note/note/http/file-entry-api.dart';

import 'package:note/note/state/file-entry.dart';
import 'package:note/transfers/transfer-queue/file-transfer.dart';
import 'package:path/path.dart';

typedef DownloadManagerCallback<T> = void Function(
    DownloadTaskStatus status, int progress, String ftaskId);

class DownloadManager {
  DownloadManager({
    this.api,
  }) {
   // init();
  }
  init() async {
    await FlutterDownloader.initialize(
      debug: false,
    ).then((_) {
      print("flutter downloader initailized");
      _bindBackgroundIsolate();
      FlutterDownloader.registerCallback(downloadCallback);
    });
  }

  final FileEntryApi api;
  //final Notifications notifications;

  bool initialized = false;
  ReceivePort _port = ReceivePort();
  bool debug = true;

  final Map<String, DownloadManagerCallback> _callbacks = {};
  final Map<String, int> _progressCounts = {};
  Future<String> enqueue(FileEntry fileEntry, String destination,
      {DownloadManagerCallback callback}) async {
    print("==============download start ===========================");
    final taskId = await FlutterDownloader.enqueue(
      //url: api.previewUrl(entry),
      url: fileEntry.url,
      //headers: api.http.authHeaders,
      fileName: basename(destination),
      savedDir: dirname(destination),
      showNotification:
          false, // show download progress in status bar (for Android)
      openFileFromNotification:
          false, // click on notification to open downloaded file (for Android)
    );
    print("==============download finish ===========================");
    if (callback != null) {
      registerCallback(taskId, callback);
    }

    return taskId;
  }

  pause(FileTransfer transfer) {
    FlutterDownloader.pause(taskId: transfer.taskId);
  }

  Future<String> resume(FileTransfer transfer) async {
    final oldTaskId = transfer.taskId;
    final newTaskId = await FlutterDownloader.resume(taskId: oldTaskId);
    _callbacks[newTaskId] = _callbacks[oldTaskId];
    _callbacks.remove(oldTaskId);
    return newTaskId;
  }

  cancel(FileTransfer transfer) {
    FlutterDownloader.cancel(taskId: transfer.taskId);
  }

  registerCallback(String taskId, DownloadManagerCallback callback) {
    _callbacks[taskId] = callback;
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      String taskId = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2] <= 0 ? 0 : data[2];
      final callback = _callbacks[taskId];

      final oldCount = _progressCounts[taskId];
      _progressCounts[taskId] = oldCount == null ? 0 : oldCount + 1;

      // TODO: remove after this is merged: https://github.com/fluttercommunity/flutter_downloader/pull/371
      if (progress > 100) {
        progress = min((_progressCounts[taskId] * 10), 90);
      }

      if (callback != null) {
        callback(status, progress, taskId);
        if (status == DownloadTaskStatus.complete) {
          _callbacks.remove(taskId);
        }
      }
    });
  }




  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }
}
