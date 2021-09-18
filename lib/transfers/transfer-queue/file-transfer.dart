import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:note/note/state/file-entry.dart';
import 'package:note/transfers/uploads/upload-progress.dart';

enum FileTransferType {
  upload,
  download,
  offline,
}

enum TransferQueueStatus {
  paused,
  inProgress,
  completed,
  error,
}
enum NotificationTap {
  taped,
  notTaped,
}
extension TransferQueueStatusValue on TransferQueueStatus {
  String get value => describeEnum(this);
  TransferQueueStatus fromValue(String value) {
    if (value == TransferQueueStatus.paused.value) {
      return TransferQueueStatus.paused;
    } else if (value == TransferQueueStatus.completed.value) {
      return TransferQueueStatus.completed;
    } else if (value == TransferQueueStatus.error.value) {
      return TransferQueueStatus.error;
    } else {
      return TransferQueueStatus.inProgress;
    }
  }
}

abstract class FileTransfer {
  FileEntry fileEntry;
  TransferProgress progress;
  String taskId;
  TransferQueueStatus status;
  //BackendError backendError;
  String get displayName;
  String get fingerprint;
  int get size;
  bool seen;
  FileTransferType get type;


  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() {
    return {
      "fileEntry": fileEntry != null ? fileEntry.toJson() : null,
      "progress": progress.toJson(),
      "status": status.value,
      "fingerprint": fingerprint,
      "taskId": taskId,
      "seen":seen
  //    "backednError": backendError != null ? backendError.toJson() : null,
    };
  }
}