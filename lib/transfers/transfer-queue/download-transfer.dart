
import 'package:flutter/foundation.dart';

import 'package:note/note/state/file-entry.dart';
import 'package:note/transfers/downloads/download-manager.dart';
import 'package:note/transfers/uploads/upload-progress.dart';

import 'file-transfer.dart';

class DownloadTransfer extends FileTransfer {
  DownloadTransfer(this.fileEntry, this.fingerprint, this.taskId,this.displayName_,{this.status = TransferQueueStatus.inProgress, this.type = FileTransferType.download,this.seen}) {
    progress = TransferProgress(fileEntry.fileSize, percentage: 0);
  }

  final FileEntry fileEntry;
  final String fingerprint;
  final String displayName_;
  String taskId;
  TransferQueueStatus status;
  String get displayName => this.displayName_;
  int get size => fileEntry?.fileSize;
  bool seen=false;
  FileTransferType type;

  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['taskId'] = taskId;
    json['displayName']=displayName_;
    json['type'] = describeEnum(FileTransferType.download);
    json['seen'] = seen;
    return json;
  }

  factory DownloadTransfer.fromJson(Map<String, dynamic> e, DownloadManager downloadManager) {
    final transfer = DownloadTransfer(
      FileEntry.fromJson(e['fileEntry']),
      e['fingerprint'],
      e['taskId'],
      e['displayName'],
      status: TransferQueueStatus.paused.fromValue(e['status']),
      type: e['type'] == 'offline' ? FileTransferType.offline : FileTransferType.download,
      seen: e["seen"]
    );
    return transfer;
  }


}