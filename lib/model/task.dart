class Task {
  String title;
  bool isDone;
  DateTime createdTime;
  DateTime? updatedTime;

  Task({
    required this.title,
    required this.isDone,
    required this.createdTime,
    this.updatedTime
  });

}