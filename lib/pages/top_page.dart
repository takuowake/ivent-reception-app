import 'package:flutter/material.dart';
import 'package:webtotop/pages/add_task_page.dart';
import 'package:webtotop/pages/done_task_page.dart';
import 'package:webtotop/pages/undone_task_page.dart';

import '../model/task.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key, required this.title});
  final String title;

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  List<Task> undoneTaskList = [
    Task(title: '宿題', isDone: false, createdTime: DateTime.now()),
    Task(title: '買い出し', isDone: false, createdTime: DateTime.now()),
    Task(title: '買い出し', isDone: false, createdTime: DateTime.now()),
  ];

  List<Task> doneTaskList = [];
  bool showUndoneTaskPage = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase ×︎ Flutter for WEB'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          showUndoneTaskPage
              ? UndoneTaskPage(undoneTaskList: undoneTaskList, doneTaskList: doneTaskList)
              : DoneTaskPage(undoneTaskList: undoneTaskList, doneTaskList: doneTaskList),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    showUndoneTaskPage = true;
                    setState(() {

                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    color: Colors.redAccent,
                    child: Text(
                      '未完了タスク',
                      style: TextStyle(color: Colors.white, fontSize: 20),),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    showUndoneTaskPage = false;
                    setState(() {

                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    color: Colors.greenAccent,
                    child: Text('完了タスク', style: TextStyle(color: Colors.white, fontSize: 20),),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await Navigator.push(context, MaterialPageRoute(builder: (context) => AddTaskPage(undoneTaskList: undoneTaskList,)));
          setState(() {});
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}