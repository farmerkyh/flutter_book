import 'package:firebase_database/firebase_database.dart';

class Review {
  String key;
  String id;
  String review;
  String createTime;

  Review(this.id, this.review, this.createTime);

  Review.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        id = snapshot.value['id'],
        review = snapshot.value['review'],
        createTime = snapshot.value['createTime'];

  toJson() {
    return {
      'id': id,
      'review': review,
      'createTime': createTime,
    };
  }
}
