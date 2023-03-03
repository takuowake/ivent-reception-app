import 'package:flutter/material.dart';

import '../model/task.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key, required this.undoneTaskList}) : super(key: key);
  final List<Task> undoneTaskList;

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  TextEditingController titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('タスクを追加'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text('タイトル'),
            ),
            Container(
                width: 500,
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder()
                  ),
                )
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                width: 250,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      //①新しく追加するタスクを作成
                      Task newTask  =Task(
                        title: titleController.text,
                        isDone: false,
                        createdTime: DateTime.now()
                      );
                      //②作成したタスクを未完了タスクリストに追加
                      widget.undoneTaskList.add(newTask);
                      //③追加が完了すれば下の画面に遷移
                      Navigator.pop(context);
                    },
                    child: Text('追加')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
