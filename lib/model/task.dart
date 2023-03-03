import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String title;
  bool isDone;
  Timestamp createdTime;
  Timestamp? updatedTime;

  Task({
    required this.title,
    required this.isDone,
    required this.createdTime,
    this.updatedTime
  });

}