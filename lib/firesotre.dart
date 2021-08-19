import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestTwo extends StatefulWidget {
  TestTwo({Key key}) : super(key: key);
  @override
  _TestTwoState createState() => _TestTwoState();
}

class _TestTwoState extends State<TestTwo> {
  getonedoc() async {
    //get user collection

    DocumentReference doc = FirebaseFirestore.instance
        .collection("users")
        .doc("CUOkRNzRgrHOqmYOot4M");
    await doc.get().then((value) => {if (value.exists) print(value.data())});
  }

  getdata() async {
    //get user collection

    CollectionReference collection =
        FirebaseFirestore.instance.collection("users");
// QuerySnapshot querySnapshot=await collection.get();
// List<QueryDocumentSnapshot> queryListSnapshot=querySnapshot.docs;
// queryListSnapshot.forEach((element) {
//   print(element.data());
// });

    //or
    await collection.get().then((value) => {
          value.docs.forEach((element) {
            print(element.data());
          })
        });
  }

  ///filtering
  getFiltteringData() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("users");
    //get users where username is equal to mohamad and his age 20
    await collectionReference
        .where("name", isEqualTo: "mohamad")
        .where("age", isEqualTo: 20)
        .get()
        .then((value) => {value.docs.forEach((element) {})});
  }

//ordered data
  ///filtering
  getOrderingData() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("users");
    //get users from smaller to bigger according to age
    await collectionReference
        .orderBy("age", descending: false)
        .get()
        .then((value) => {value.docs.forEach((element) {})});
//get firt 2 users
    await collectionReference
        .limit(2)
        .get()
        .then((value) => {value.docs.forEach((element) {})});
    //get last 2 users
    await collectionReference
        .limitToLast(2)
        .get()
        .then((value) => {value.docs.forEach((element) {})});
//order all user and get users that there age start from 20
    await collectionReference
        .orderBy("age")
        .startAt([20])
        .get()
        .then((value) => {value.docs.forEach((element) {})});
  }

  //realtime
  getRealTimeData() async {
    FirebaseFirestore.instance.collection("users").snapshots().listen((event) {
      event.docs.forEach((element) {
        print(element.data());
      });
    });
  }

  //add Data
  AddData() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("users");
    collectionReference.add(
        {"username": "mohamad", "age": 20, "email": "mohamad.samer.abdulazi"});
    //to add new data with specific id
    collectionReference.doc("123456789").set(
        {"username": "mohamad", "age": 20, "email": "mohamad.samer.abdulazi"});
  }

//update Data
  updateData() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("users");
    collectionReference.doc("123456789").update({"age": 35, "username": "ali"});
    //or we can use set but set delete all data and then rewrite
    collectionReference.doc("123456789").set({"age": 35, "username": "ali"});
    //to make it like update we use
    collectionReference
        .doc("123456789")
        .set({"age": 35, "username": "ali"}, SetOptions(merge: true));

    ///to know what resault that firebase returns it we use "then"
    collectionReference
        .doc("123456789")
        .set({"age": 35, "username": "ali"}, SetOptions(merge: true))
        .then((value) => {print("success")})
        .catchError((e) {
          print(e);
        });
  }

  deleteData() {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("users");
    collectionReference
        .doc("123456789")
        .delete()
        .then((value) => {})
        .catchError((e) {});
  }

  //how to get collection inside doc
  nestedCollectionData() {
    CollectionReference collectionAddress = FirebaseFirestore.instance
        .collection("users")
        .doc("123456789")
        .collection("addresss");
  }

  //transaction we use it to ensure all data write successflully
  //to ensure writing process has done last data in server
  //so that it raeds data and then write
  trans() async {
    DocumentReference doc =
        FirebaseFirestore.instance.collection("users").doc("123456789");

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot documentSnapshot = await transaction.get(doc);

      if (documentSnapshot.exists) {
        transaction.update(doc, {"age": 20});
      }
    });
  }

  //batch write make more than one writing process at same time "update set delete..."
  //all process success all faild
  batchWrite() async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection("users").doc("123456789");
    DocumentReference docRef2 =
        FirebaseFirestore.instance.collection("users").doc("55555555");
    //I want to delete doceRef and update docRef2

    WriteBatch writeBatch = FirebaseFirestore.instance.batch();
    writeBatch.delete(docRef);
    writeBatch.update(docRef2, {"age": 23});
    //to run batch
    writeBatch.commit();
  }

  //get data and show it on interface
  //if we use futureBuilder we don't need list and this function like ex2 belloow
  List users = [];
  getDataInterface() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("user");
    QuerySnapshot querySnapshot = await collectionReference.get();
    querySnapshot.docs.forEach((element) {
      //to use parameter in interface we use set state
      setState(() {
        users.add(element.data());
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference collectionReference =
    FirebaseFirestore.instance.collection("user");
    return Scaffold(
        appBar: AppBar(
          title: Text('Test Two'),
        ),
        body:
        // ListView.builder(
        //     itemCount: users.length,
        //     itemBuilder: (context, i) {
        //       return Text("${users[i]["username"]}");
        //     })

        ///ex 2
      // FutureBuilder(
      //     future: collectionReference.get(),
      //     builder: (context,snapshot){
      //       if(snapshot.hasData){
      //         return ListView.builder(
      //           itemCount: snapshot.data.docs.length,
      //         itemBuilder: (context, index) {
      //           return Text("${snapshot.data.docs[index].data()["username"]}");
      //         },);
      //       }
      //       else if(snapshot.hasError){
      //         return Text("error");
      //       }
      //       else if(snapshot.connectionState==ConnectionState.waiting){
      //         return Text("loading");
      //       }
      //
      //     })


      ///stream builder we use it with realtime wehen data updated on server will update automatically on interfaee
      StreamBuilder(stream: collectionReference.snapshots(),
        builder: (context,snapshpt){
        if(snapshpt.hasError){
          return Text("error");
        }
        else if(snapshpt.hasData){
          return ListView.builder(
            itemCount: snapshpt.data.docs.length,
              itemBuilder: (context,index){
              return Text("${snapshpt.data.docs[index].data()["username"]}");
              });
        }
        else return Text("loading");

        },
      )
    );
  }
}
