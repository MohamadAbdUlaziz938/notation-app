import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:note/note/state/file-entry.dart';
import 'package:note/notification/notification-id.dart';
import 'package:note/notification/notification.dart';
import 'package:note/transfers/downloads/download-manager.dart';
import 'package:note/transfers/transfer-queue/notifi-ids.dart';
import 'package:note/transfers/uploads/upload-progress.dart';
import 'package:note/utils/local-storage.dart';
import 'package:note/utils/text.dart';
import 'package:filesize/filesize.dart';
import 'package:path_provider/path_provider.dart';
import 'download-transfer.dart';
import 'file-transfer.dart';
import 'package:path/path.dart';

class TransferQueue extends ChangeNotifier {
  static const notifIds = {
    FileTransferType.download: 59658458,
    FileTransferType.upload: 19648471,
    FileTransferType.offline: 193148874,
  };

  static const fileName = 'transfer-queue.json';
  final Notifications notifications;
  final DownloadManager downloader;
  //final UploadManager uploader;
  final LocalStorage localStorage;

  String destination;
  bool cancelCompleted = false;
  get Destination => destination;
  get CancelCompleted => cancelCompleted;

  _LastProgressUpdate _lastProgressUpdate = _LastProgressUpdate();
  Map<String, FileTransfer> queue = {};
  Map<String, FileTransfer> queueAll = {};
  StreamController<FileEntry> _uploadCompletedCtrl;

  TransferQueue({this.downloader, this.localStorage, this.notifications}) {
    restoreQueue();
    //clearCompleted();
    _uploadCompletedCtrl = StreamController<FileEntry>.broadcast();
  }
  Stream<FileEntry> get uploadCompleted {
    return _uploadCompletedCtrl.stream;
  }

  void setDistination(String val) {
    destination = val;
    notifyListeners();
  }

  Future<String> CheckFileExist(String destination) async {
    File file = File('${dirname(destination)}/${basename(destination)}');
    int x = 1;
    while (await file.exists()) {
      file = File('${dirname(destination)}/${basename(destination)} (${x})');
      print(file.path);
      x = x + 1;
    }
    destination = '${file.path}';
    return destination;
  }

  // addUpload(FileUpload fileUpload) async {
  //   final callback = _createUploadCallback(fileUpload.fingerprint);
  //   final uploadId = await uploader.enqueue(
  //       fileUpload,
  //       callback: callback
  //   );
  //   queue = {
  //     ...queue,
  //     fileUpload.fingerprint: UploadTransfer(fileUpload, uploadId),
  //   };
  //   _updateNotification(FileTransferType.upload);
  //   notifyListeners();
  //   _persistQueue();
  //   return fileUpload.fingerprint;
  // }

  Future<String> addDownload(FileEntry fileEntry, String destination,
      {FileTransferType type = FileTransferType.download}) async {
    print("===========add download  ============");
    print(destination);
    destination = await CheckFileExist(destination);
    final fingerprint = base64Encode(utf8.encode("${destination}"));
    int localId = new Random().nextInt(10000);
    final callback = _createDownloadCallback(fingerprint, fileEntry, localId);
    final taskId =
        await downloader.enqueue(fileEntry, destination, callback: callback);
    if (taskId != null) {
      queue = {
        ...queue,
        fingerprint: DownloadTransfer(
            fileEntry, fingerprint, taskId, basename(destination),
            type: type, seen: false),
      };
      print("=========== update notification ===========");

      _updateNotification(type, localId: localId);
      notifyListeners();
      _persistQueue();
      return fingerprint;
    }
    return null;
  }

  updateProgress(String fingerprint, TransferProgress progress, int localId) {
    print("=========== update progress ===============");
    print(queue[fingerprint].status);
    final transfer = queue[fingerprint];
    if (_lastProgressUpdate.progress != progress && transfer != null) {
      final now = DateTime.now();
      // update on first, last and then throttle to one update every 350ms
      if (_lastProgressUpdate.time == null ||
          progress.percentage == 100 ||
          now.difference(_lastProgressUpdate.time).inMilliseconds > 350) {
        queue[fingerprint].progress = progress;
        _updateNotification(transfer.type, localId: localId);
        _lastProgressUpdate.set(now, progress);
        notifyListeners();
      }
    }
  }

  cancelTransfer(String fingerprint) {
    final transfer = queue[fingerprint];
    if (transfer != null) {
      final newQueue = {...queue};
      // transfer is UploadTransfer ? uploader.cancel(transfer) : downloader.cancel(transfer);
      downloader.cancel(transfer);
      newQueue.remove(fingerprint);
      queue = newQueue;
      _updateNotification(transfer.type);
      notifyListeners();
      _persistQueue();
    }
  }

  pauseTransfer(String fingerprint) {
    final transfer = queue[fingerprint];
    if (transfer != null) {
      transfer.status = TransferQueueStatus.paused;
      //transfer is UploadTransfer ? uploader.pause(transfer) :
      downloader.pause(transfer);
      _updateNotification(transfer.type);
      notifyListeners();
      _persistQueue();
    }
  }

  resumeTransfer(String fingerprint) async {
    final transfer = queue[fingerprint];
    if (transfer != null) {
      transfer.status = TransferQueueStatus.inProgress;
      //final newTaskId = transfer is UploadTransfer ? uploader.resume(transfer) : downloader.resume(transfer);
      final newTaskId = downloader.resume(transfer);
      transfer.taskId = await newTaskId;
      _updateNotification(transfer.type);
      notifyListeners();
      _persistQueue();
    }
  }

  completeTransfer(String fingerPrint, FileEntry fileEntry, int localId) {
    print("=========== completeTransfer =============");
    final transfer = queue[fingerPrint];
    if (transfer != null && transfer.status != TransferQueueStatus.completed) {
      transfer.status = TransferQueueStatus.completed;
      transfer.fileEntry = fileEntry;
      // if (transfer is UploadTransfer && fileEntry != null) {
      //   _uploadCompletedCtrl.add(fileEntry);
      // }

      _updateNotification(transfer.type, playSound: true, localId: localId);
      notifyListeners();
      _persistQueue();
    }
  }

  clearCompleted() {
    // List<FileTransfer> queueBool=
    // this.queue.values.where((e) => e.type == type).toList();
    //  List<FileTransfer> pending =
    // queue.values.where((e) => e.status == TransferQueueStatus.completed).toList();
    queue.keys.forEach((element) {
      queue.update(element, (value) {
        if (value.status == TransferQueueStatus.completed && !value.seen) {
          value.seen = true;
          cancelCompleted = true;
          return value;
        } else
          return value;
      });
    });
    final newQueue = {...queue};
    //newQueue.removeWhere((_, t) => t.status == TransferQueueStatus.completed);
    //newQueue.update(newQueue.)
    queue = newQueue;
    Map<TransferQueueStatus, int> notifIdType;
    FileTransferType.values.forEach((e) {
      _updateNotification(e);
    });
    notifyListeners();
    _persistQueue();
  }

  errorTransfer(String fingerprint, String error, int localId) {
    final transfer = queue[fingerprint];
    // transfer is UploadTransfer ? uploader.pause(transfer) : downloader.pause(transfer);
    downloader.pause(transfer);
    transfer.status = TransferQueueStatus.error;
    //transfer.backendError = error;
    _updateNotification(transfer.type, localId: localId);
    notifyListeners();
    _persistQueue();
  }

  @override
  void dispose() {
    _uploadCompletedCtrl.close();
    super.dispose();
  }

  _persistQueue() {
    print("============== queue to json =========================");
    print(queue.keys);
    final encoded = json.encode(queue);
    print("============== queue will store =========================");
    localStorage.permanent.put(TransferQueue.fileName, encoded);
    print("============== queue stored =========================");
  }

  restoreQueue() async {
    if (await localStorage.permanent.exists(fileName)) {
      Map<String, dynamic> decoded =
          json.decode(await localStorage.permanent.get(fileName));
      decoded.forEach((fingerprint, decodedTransfer) {
        // if (decodedTransfer['type'] == describeEnum(FileTransferType.upload)) {
        //   final transfer = UploadTransfer.fromJson(decodedTransfer);
        //   if (transfer.fileUpload.file.existsSync()) {
        //     queue[fingerprint] = transfer;
        //     if (transfer.status != TransferQueueStatus.completed) {
        //       final callback = _createUploadCallback(fingerprint);
        //       uploader.registerCallback(transfer.taskId, callback);
        //     }
        //   }
        // }
        //else {
        final transfer = DownloadTransfer.fromJson(decodedTransfer, downloader);
        queue[fingerprint] = transfer;
        if (transfer.status != TransferQueueStatus.completed) {
          final callback =
              _createDownloadCallback(fingerprint, transfer.fileEntry, 09);
          downloader.registerCallback(transfer.taskId, callback);
        }
        //}
      });
      FileTransferType.values.forEach((e) {
        _updateNotification(e, hideIfAllCompleted: true);
      });
      notifyListeners();
    }
  }

  DownloadManagerCallback _createDownloadCallback(
      String fingerprint, FileEntry fileEntry, int localId) {
    return (DownloadTaskStatus status, int progress, _) {
      if (status == DownloadTaskStatus.complete) {
        completeTransfer(fingerprint, fileEntry, localId);
      } else if (status == DownloadTaskStatus.running) {
        updateProgress(
            fingerprint,
            TransferProgress(queue[fingerprint].size, percentage: progress),
            localId);
      } else if (status == DownloadTaskStatus.failed) {
        errorTransfer(fingerprint, ('File download failed'), localId);
      }
    };
  }

  // UploadManagerCallback _createUploadCallback(String fingerprint) {
  //   return (UploadTaskStatus status, int progress, String taskId, FileEntry fileEntry, BackendError err) {
  //     if (status == UploadTaskStatus.complete) {
  //       completeTransfer(fingerprint, fileEntry);
  //     } else if (status == UploadTaskStatus.running) {
  //       updateProgress(fingerprint, TransferProgress(queue[fingerprint].size, percentage: progress));
  //     } else if (status == UploadTaskStatus.failed) {
  //       errorTransfer(fingerprint, err);
  //     }
  //   };
  // }

  _updateNotification(FileTransferType type,
      {bool hideIfAllCompleted = false, bool playSound = false, int localId}) {
    if (Platform.isIOS) return;
    final notifId = notifIds[type];
    Map<TransferQueueStatus, int> notifIdType;
    List<FileTransfer> queue = this
        .queue
        .values
        .where((e) => e.type == type && e.seen == false)
        .toList();
    List<FileTransfer> pending =
        queue.where((e) => e.status != TransferQueueStatus.completed).toList();

    String payload =
        json.encode({'notifId': NotificationType.transferProgress});

    // // if no transfers in queue, hide notif
    // if (queue.length == 0 || (hideIfAllCompleted && pending.isEmpty)) {
    //   notifications.cancel(notifId);
    //   return;
    // }

    String action;
    if (type == FileTransferType.download) {
      action = 'download';
      notifIdType = notifIdsDownload;
    } else if (type == FileTransferType.upload) {
      action = 'upload';
    } else {
      action = 'offline';
    }
    if (CancelCompleted) {
      try{notifications.cancel(notifIdType[TransferQueueStatus.completed]);}catch(e){print("cancell error");}
      cancelCompleted = false;
      return;
    }
    // if (queue.length == 0 || (hideIfAllCompleted && pending.isEmpty)) {
    //   notifications.cancel(notifIdType[TransferQueueStatus.completed]);
    //   return;
    // }
    if (queue.length == 0) return;

    // all completed
    if (pending.isEmpty) {
      final message = queue.length == 1
          ? '${action.capitalize()}ed "${queue.first.displayName}"'
          : '${action.capitalize()}ed ${queue.length} files';
      notifications.cancel(notifIdType[TransferQueueStatus.inProgress]);
      notifications.notify(message,
          localId: notifIdType[TransferQueueStatus.completed],
          payload: payload,
          runSound: true);
    }

    // all paused
    else if (pending.every((e) => e.status == TransferQueueStatus.paused)) {
      final message = pending.length == 1
          ? '${action.capitalize()}ing "${pending.first.displayName}"'
          : '${action.capitalize()}ing ${pending.length} files';
      notifications.notify(message,
          body: 'Paused',
          progress: 0,
          localId: notifIdType[TransferQueueStatus.paused],
          payload: payload,
          runSound: false);
    }

    // all errored
    else if (pending.every((e) => e.status == TransferQueueStatus.error)) {
      final message = pending.length == 1
          ? 'Could not $action "${pending.first.displayName}"'
          : 'Could not $action ${pending.length} files';
      notifications.notify(message,
          localId: notifIdType[TransferQueueStatus.error],
          payload: payload,
          runSound: true);
    }

    // some are still in progress
    else {
      final message = pending.length == 1
          ? '${action.capitalize()}ing "${pending.first.displayName}"'
          : '${action.capitalize()}ing ${pending.length} files';
      //: '${action.capitalize()}ing "${pending.first.displayName}"';
      final body = filesize(
          pending.fold(0, (prev, curr) => prev + curr.progress.bytesLeft));
      //final body = filesize(pending.fold(0, (prev, curr) => curr.progress.bytesLeft));
      final progress = pending
          .fold(
              0,
              (prev, curr) =>
                  (prev + curr.progress.percentage) / pending.length)
          .floor();
      //final progress = pending.fold(0, (prev, curr) => (curr.progress.percentage)).floor();
      notifications.notify(message,
          body: body,
          progress: progress,
          localId: notifIdType[TransferQueueStatus.inProgress],
          payload: payload,
          runSound: false);
    }
  }
}

class _LastProgressUpdate {
  _LastProgressUpdate([this.time, this.progress]);
  DateTime time;
  TransferProgress progress;

  set(DateTime time, TransferProgress progress) {
    this.time = time;
    this.progress = progress;
  }
}
