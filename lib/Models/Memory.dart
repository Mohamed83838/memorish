import 'package:firebase_auth/firebase_auth.dart';

class Memory {
  String title;
  String originalmemory;
  String ownerid;
  String? username;
  String? userphoto;
  bool favorite;
  String description;
  String type;
  String? id;
  String? imageUrl;
  String signaturePhotoUrl;
  String state;
  String date;
  String generated;
  Memory({
    required this.ownerid,
    required this.originalmemory,
    required this.favorite,
    this.username,
    this.userphoto,
    this.id,
    required this.title,
    required this.description,
    required this.type,
    this.imageUrl,
    required this.generated,
    required this.signaturePhotoUrl,
    required this.state,
    required this.date,
  });

  // Factory constructor to create a Memory object from a map
  factory Memory.fromMap(Map<String, dynamic> map) {
    return Memory(
      ownerid: map["ownerid"],
      originalmemory: map["originalmemory"],
      favorite: map["favorite"],
      username: map["username"],
      userphoto: map["user-photo"],
      id: map["id"],
      generated: map["generated"],
      title: map['title'],
      description: map['description'],
      type: map['type'],
      imageUrl: map['imageUrl'],
      signaturePhotoUrl: map['signaturePhotoUrl'],
      state: map['state'],
      date: map['date'],
    );
  }

  // Method to convert a Memory object to a map
  Map<String, dynamic> toMap() {
    return {
      "originalmemory":originalmemory,
      "ownerid":ownerid,
      "username":username,
      "user-photo":userphoto,
      "favorite":favorite,
      "id":id,
      "generated":generated,
      'title': title,
      'description': description,
      'type': type,
      'imageUrl': imageUrl,
      'signaturePhotoUrl': signaturePhotoUrl,
      'state': state,
      'date': date,
    };
  }
}
