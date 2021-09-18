import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:note/auth/user.dart';
import 'package:note/utils/local-storage.dart';

import 'file-entry.dart';
import 'note.dart';

class EntryCache  {
  LocalStorageAdapter storage;
    User currentUser;
   Map<String, FileEntry> _entries = {};

  EntryCache(LocalStorage localStorage, this.currentUser) {
    storage = localStorage.temporary.scopedToUser(currentUser);
  }
  void clear_entries(){
    _entries={};
  }
  get all {
    return _entries;
  }
  FileEntry get(String entryId) {
    return _entries[entryId];
  }
  Future getAll() {
    return Future.value(_entries);
  }

  void set(String entryId, FileEntry entry) {
    _entries[entryId] = entry;
    //notifyListeners();
  }

  cacheResponse(String response, Map<String, String> params) {
    storage.put(_responseCacheKey(params), response);
  }
  Future<String> getResponse(Map<String, String> params) {
    return storage.get(_responseCacheKey(params));
  }

  String _responseCacheKey(Map<String, String> params) {
    final string = params.toString().replaceAll(' ', '');
    final hash = md5.convert(utf8.encode(string)).toString();
    return hash;
  }
}