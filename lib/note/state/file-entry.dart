import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:note/note/http/file-entry-api.dart';

import 'note.dart';
import 'note_.dart';

class FileEntry with ChangeNotifier {
  FileEntry({
    this.userId,
    this.documentId,
    this.name,
    this.description,
    this.fileName,
    this.fileSize,
    this.url,
    this.downloadFingerprint,
    // this.note,
    this.password,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.type,
    this.extension,
  });

  String documentId;
  String userId;
  String name;
  String description;
  String fileName;
  //String mime;
  int fileSize;
  int parentId;
  String password;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime deletedAt;
  //String path;
  String diskPrefix;
  String type;
  String extension;
  //bool public;
  //bool thumbnail;
  //int workspaceId;
  String hash;
  String url;
  Note_ note;
  //List<FileEntryUser> users;
  //List<Tag> tags;
  List<EntryPermission> permissions;
  String downloadFingerprint;

  factory FileEntry.fromRawJson(String str) =>
      FileEntry.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FileEntry.fromJson(Map<String, dynamic> e) {
    return FileEntry(
      documentId: e["documentId"],
      userId: e["userId"],
      name: e["name"],
      description: e["description"] ?? "",
      fileName: e["fileName"],
      fileSize: e["fileSize"],
      url: e["url"] ?? "",
      downloadFingerprint: e["downloadFingerprint"] ?? "",
      type: e["type"],
      extension: e["extension"],
      password: e["password"] ?? "",
      // createdAt: e["createdAt"],
      // updatedAt: e["updatedAt"] == null ? "" : e["updatedAt"],
      // deletedAt: e["deletedAt"] == null ? "" : e["deletedAt"]
      //note: e["note"]?"":Note.fromJson(e["note"])
    );
  }

  Map<String, dynamic> toJson({bool forLocalSql = false, FileEntryApi api}) => {
        "id": documentId,
        "name": name,
        "description": description,
        "fileName": fileName,
        "fileSize": fileSize,
        "url": url,
        "downloadFingerprint": downloadFingerprint,
        "type": type,
        "extension": extension,
        "password": password,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "deletedAt": deletedAt,
      };

// addToStarred() {
//   if ( ! isStarred()) {
//     tags.add(Tag(id: 1, name: 'starred'));
//   }
// }

// removeFromStarred() {
//   if (isStarred()) {
//     tags.removeWhere((t) => t.name == 'starred');
//   }
// }

// isStarred() {
//   return tags.firstWhere((t) => t.name == 'starred', orElse: () => null) != null;
// }
}

List<EntryPermission> _buildPermissionList(dynamic permissions) {
  if (permissions == null) {
    return [];
  } else {
    return (permissions as Map<String, dynamic>)
        .entries
        .takeWhile((e) => e.value)
        .map((p) {
      switch (p.key) {
        case 'files.download':
          return EntryPermission.download;
        case 'files.update':
          return EntryPermission.update;
        case 'files.delete':
          return EntryPermission.delete;
      }
    }).toList();
  }
}

enum EntryPermission {
  download,
  update,
  delete,
}

extension EntryPermissionExtension on EntryPermission {
  get value => describeEnum(this);
}
