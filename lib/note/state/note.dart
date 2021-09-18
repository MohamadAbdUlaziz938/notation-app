import 'dart:convert';

class Note  {
  String title;
  String note;
  String imageUrl;
  String userId;
  String documentId;

  Note({this.title, this.note, this.imageUrl, this.userId, this.documentId});

  factory Note.fromRawJson(String str) => Note.fromJson(json.decode(str));
  factory Note.fromJson(json) => Note(
        title: json['title'],
        note: json['note'],
        imageUrl: json['imageurl'],
        userId: json['userid'],
        documentId: json["documentid"],
      );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        'title': this.title,
        'body': this.note,
        'imageurl': this.imageUrl,
        'userid': this.userId,
        'documentid': this.documentId
      };

  // get getTitle => this.title;
  // get getNote => this.note;
  // get getImageUrl => this.imageUrl;
  // get getUserId => this.userId;
  // get getDocumentId => this.documentId;
  //
  //  Note getNot()=>Note(
  //   title: getTitle,
  //    note: getNote,
  //    imageUrl: getImageUrl,
  //    userId: getUserId,
  //    documentId: getDocumentId
  // );


}
