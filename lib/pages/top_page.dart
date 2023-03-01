import 'package:flutter/material.dart';

import '../model/task.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key, required this.title});
  final String title;

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  List<Task> taskList = [
    Task(title: '宿題', isDone: false, createdTime: DateTime.now()),
    Task(title: '買い出し', isDone: false, createdTime: DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase ×︎ Flutter for WEB'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
              title: Text(taskList[index].title),
              value: taskList[index].isDone,
              onChanged: (bool? value) {
                taskList[index].isDone = !taskList[index].isDone;
                setState(() {

                });
              },
            );
          },
          itemCount: taskList.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}