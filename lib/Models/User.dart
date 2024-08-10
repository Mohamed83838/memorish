class UserModel {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  final String? story;

  UserModel({
    this.story,
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'story':story,
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      story: map['story'] ??"",
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      photoUrl: map['photoUrl'],
    );
  }
}
