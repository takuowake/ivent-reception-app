import 'package:cloud_firestore/cloud_firestore.dart';

class Participant {
  String name;
  bool attendance;
  Timestamp enteredTime;
  Timestamp? updatedTime;

  Participant({
    required this.name,
    required this.attendance,
    required this.enteredTime,
    this.updatedTime
  });

}