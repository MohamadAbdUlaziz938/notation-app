import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note/note/dialogs/loading-dialog.dart';
import 'package:note/note/http/file-entry-api.dart';
import 'package:note/note/state/note.dart';
import 'package:note/note/state/note-state.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
class EditNotesArgs{
  final note;
  EditNotesArgs( this.note);
}
class EditNotes extends StatefulWidget {
  static const ROUTE="editNote";
  final Note note;
  EditNotes({Key key, this.note}) : super(key: key);
  @override
  _EditNotesState createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  CollectionReference notesref = FirebaseFirestore.instance.collection("notes");

  Reference ref;

  File file;

  var title, note, imageurl;

  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  editNotes(BuildContext context) async {
    final api=context.read<NoteState>().api;
    var formdata = formstate.currentState;

    if (file == null) {
      if (formdata.validate()) {
      LoadingDialog.show();
        formdata.save();
        await api.editNote(widget.note.toJson(), "notes")
          .then((value) {
          LoadingDialog.hide();
          Navigator.of(context).pushNamedAndRemoveUntil("home",(_)=>false);
        }).catchError((e) {
          LoadingDialog.hide();
          print("$e");
        });
      }
    } else {
      if (formdata.validate()) {
        showLoading(context);
        formdata.save();
        await ref.putFile(file);
        widget.note.imageUrl = await ref.getDownloadURL();
        await api.editNote(widget.note.toJson(), "notes")
            .then((value) {
            Navigator.of(context).pushNamedAndRemoveUntil("home",(_)=>false);
          }).catchError((e) {
            print("$e");
          });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
      ),
      body: Container(
          child: Column(
        children: [
          Form(
              key: formstate,
              child: Column(children: [
                TextFormField(
                  initialValue: widget.note.title,
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
                    widget.note.title = val;
                  },
                  maxLength: 30,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Title Note",
                      prefixIcon: Icon(Icons.note)),
                ),
                TextFormField(
                  initialValue: widget.note.note,
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
                    widget.note.note = val;
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
                  child: Text("Edit Image For Note"),
                ),
                RaisedButton(
                  onPressed: () async {
                    await editNotes(context);
                  },
                  textColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                  child: Text(
                    "Edit Note",
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
                  "Edit Image",
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
