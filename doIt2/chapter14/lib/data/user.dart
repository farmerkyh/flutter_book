import 'package:firebase_database/firebase_database.dart';

class User {
  String? key;
  String id;
  String pw;
  String createTime;

  //User({required this.id, required this.pw, required this.createTime});
  //User({required this.key, required this.id, required this.pw, required this.createTime});
  User(this.id, this.pw, this.createTime);

  User.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key.toString(),
        //: key = snapshot.value['key'],
        id = snapshot.value['id'],
        pw = snapshot.value['pw'],
        createTime = snapshot.value['createTime'];

  toJson() {
    return {
      'id': id,
      'pw': pw,
      'createTime': createTime,
    };
  }
}
