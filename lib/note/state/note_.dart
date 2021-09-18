import 'dart:convert';

class Note_  {
  String title;
  String note;
  String imageUrl;

  Note_({this.title, this.note, this.imageUrl,});

  factory Note_.fromRawJson(String str) => Note_.fromJson(json.decode(str));
  factory Note_.fromJson(json) => Note_(
    title: json['title'],
    note: json['note'],
    imageUrl: json['imageurl'],


  );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
    'title': this.title,
    'body': this.note,
    'imageurl': this.imageUrl,


  };

}
