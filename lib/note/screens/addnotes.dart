import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note/note/dialogs/loading-dialog.dart';
import 'package:note/note/state/Note.dart';
import 'package:note/note/state/note-state.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';


class AddNotes extends StatefulWidget {
  static const ROUTE = "addNote";
  AddNotes({Key key}) : super(key: key);
  @override
  _AddNotesState createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  CollectionReference notesref = FirebaseFirestore.instance.collection("notes");

  Reference ref;

  File file;

  var title, note_, imageurl;
  Note note;
 final Map<String,dynamic> map=new Map();

  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  addNotes(BuildContext context) async {
    final api=context.read<NoteState>().api;
    if (file == null){}
      // return AwesomeDialog(
      //     context: context,
      //     title: "هام",
      //     body: Text("please choose Image"),
      //     dialogType: DialogType.ERROR)
      //   ..show();
    var formdata = formstate.currentState;
    if (formdata.validate()) {
      //showLoading(context);
      LoadingDialog.show();
      formdata.save();
      await ref.putFile(file);
      
      imageurl = await ref.getDownloadURL();
      map.addAll({"imageurl":imageurl});
      map.addAll({"userid": FirebaseAuth.instance.currentUser.uid});
      await api.addNote(
        map
      , "notes").then((value) {
        LoadingDialog.hide();
        Navigator.of(context).pushNamedAndRemoveUntil("home", (_) => false);
      }).catchError((e) {
        LoadingDialog.hide();
        print("$e");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
      ),
      body: Container(
          child: Column(
        children: [
          Form(
              key: formstate,
              child: Column(children: [
                TextFormField(
                  validator: (val) {
                    if (val.length > 30) {
                      return "Title can't to be larger than 30 letter";
                    }
                    if (val.length < 2) {
                      return "Title can't to be less than 2 letter";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    //title = val;
                    map.addAll({"title":val});
                  },
                  maxLength: 30,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Title Note",
                      prefixIcon: Icon(Icons.note)),
                ),
                TextFormField(
                  validator: (val) {
                    if (val.length > 255) {
                      return "Notes can't to be larger than 255 letter";
                    }
                    if (val.length < 10) {
                      return "Notes can't to be less than 10 letter";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    //note = val;
                    map.addAll({"note":val});
                  },
                  minLines: 1,
                  maxLines: 3,
                  maxLength: 200,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Note",
                      prefixIcon: Icon(Icons.note)),
                ),
                RaisedButton(
                  onPressed: () {

                    showBottomSheet(context);
                  },
                  textColor: Colors.white,
                  child: Text("Add Image For Note"),
                ),
                RaisedButton(
                  onPressed: () async {
                    await addNotes(context);
                  },
                  textColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                  child: Text(
                    "Add Note",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                )
              ]))
        ],
      )),
    );
  }

  showBottomSheet(context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(20),
            height: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Please Choose Image",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () async {
                    var picked = await ImagePicker()
                        .getImage(source: ImageSource.gallery);
                    if (picked != null) {
                      file = File(picked.path);
                      var rand = Random().nextInt(100000);
                      var imagename = "$rand" + basename(picked.path);
                      ref = FirebaseStorage.instance
                          .ref("images")
                          .child("$imagename");
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.photo_outlined,
                            size: 30,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "From Gallery",
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      )),
                ),
                InkWell(
                  onTap: () async {
                    var picked = await ImagePicker()
                        .getImage(source: ImageSource.camera);
                    if (picked != null) {
                      file = File(picked.path);
                      var rand = Random().nextInt(100000);
                      var imagename = "$rand" + basename(picked.path);
                      ref = FirebaseStorage.instance
                          .ref("images")
                          .child("$imagename");
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.camera,
                            size: 30,
                          ),
                          SizedBox(width: 20),
                          Text(
                            "From Camera",
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      )),
                ),
              ],
            ),
          );
        });
  }
}
