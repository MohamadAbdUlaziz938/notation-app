import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:io';

class FireStorage extends StatefulWidget {
  const FireStorage({Key key}) : super(key: key);

  @override
  _FireStorageState createState() => _FireStorageState();
}

class _FireStorageState extends State<FireStorage> {
  File file;
  var imagePicker=ImagePicker();

  uploadImages()async{
    var imagePicked=await imagePicker.getImage(source: ImageSource.gallery);
    var imageName=basename(imagePicked.path);

    if (imagePicked!=null){
      file=File(imagePicked.path);
      //start uploading
      var random=Random().nextInt(10000000);
      var refStorage=FirebaseStorage.instance.ref("images/${imageName}${random}");
      //upload image
      await refStorage.putFile(file);
      //to get url image we uploaded it
      var url=await refStorage.getDownloadURL();
    }
  }
  getImagesName()async{
    var refStorage=await FirebaseStorage.instance.ref("image").list();
    //or we can get only two images
    //var refStorage=await FirebaseStorage.instance.ref("image").list(ListOptions(maxResults: 2));
     refStorage.items.forEach((element) {
       //will print images  name in directory image
       print(element);
     });
    refStorage.items.forEach((element) {
      //will print directories names in directory image
      print(element);
    });

  }
  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: RaisedButton(onPressed: (){uploadImages();},child: Text("Uoload-image"),),
        )
      ],
    );
  }
}
