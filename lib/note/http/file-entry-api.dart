import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'app-http-client.dart';

class FileEntryApi {
  final AppHttpClient httpClient;
  FileEntryApi(this.httpClient);

  addNote(Map<String,dynamic> payload,String collection)async{
     await httpClient.addPost(payload, collection);
  }

  editNote(Map<String,dynamic> payload,String collection)async{
    await httpClient.editPost(payload, collection);
  }
   loadEntries(Map<String,String> payload,String collection){
    return  httpClient.get(payload, collection);
  }
  Future<QuerySnapshot> deleteFiles(List<String>  entryIds, {bool deleteForever})async{
    return await httpClient.delete(entryIds, deleteForever:deleteForever);
  }
}