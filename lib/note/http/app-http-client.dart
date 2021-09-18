import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:note/note/state/note.dart';

class AppHttpClient {
  Future<UserCredential> LoginPost(Map<String, String> payload) async {
    UserCredential userCredential;
    userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: payload["email"].toString().trim(),
        password: payload["password"].toString().trim());
    return userCredential;
  }

  Future<UserCredential> RegisterPost(Map<String, String> payload) async {
    UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: payload["email"].toString().trim(),
          password: payload["password"].toString().trim());
    } finally {
      return userCredential;
    }
  }

  addUserPost(Map<String, String> payload) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .add({"username": payload["username"], "email": payload["username"]});
    } catch (e) {}
  }

  addPost(Map<String, dynamic> payload, String collection) async {
    await FirebaseFirestore.instance.collection(collection).add(payload);
  }

  editPost(Map<String, dynamic> payload, String collection) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(payload["documentid"])
        .update(payload);
  }
   get(Map<String, String> payload, String collection)async{
    CollectionReference notesref = FirebaseFirestore.instance.collection("notations");
    // final snapshot = await notesref
    //     .where("userId",
    //     isEqualTo: FirebaseAuth.instance.currentUser.uid)
    //     .get();
    // final snapshot= await notesref
    //     .where("userId",
    //     isEqualTo: FirebaseAuth.instance.currentUser.uid).snapshots().listen((event) { return event;});

 final snap= FirebaseFirestore.instance.collection("notations").snapshots().listen((event) {
       return event;});

 return snap;



    //snap.onData((data) {print(data.docs);});
    //return snapshot;
    //return snapshot;
  }
  Future<QuerySnapshot> delete(List<String>  entryIds, {bool deleteForever})async{
    CollectionReference notesref = FirebaseFirestore.instance.collection("notes");

    entryIds.map((docId)async{
    await notesref
        .doc(docId)
        .delete();
    final docSnapshot=await notesref.doc(docId).get();
    final dataSnapshot=docSnapshot.data;
        await FirebaseStorage.instance
            .refFromURL(Note.fromJson(dataSnapshot).imageUrl)
        .delete()
        .then((value) {
    });

    });

  }
}
