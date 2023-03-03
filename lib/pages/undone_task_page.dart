import 'dart:html';

import 'package:flutter/material.dart';

import '../model/task.dart';

class UndoneTaskPage extends StatefulWidget {
  const UndoneTaskPage({Key? key, required this.undoneTaskList, required this.doneTaskList}) : super(key: key);
  final List<Task> undoneTaskList;
  final List<Task> doneTaskList;

  @override
  State<UndoneTaskPage> createState() => _UndoneTaskPageState();
}

class _UndoneTaskPageState extends State<UndoneTaskPage> {
  TextEditingController editTitleController = TextEditingController();

  List<Task> undoneTaskList = [];
  Future<void> getUndoneTasks() async {
    var collection = Firestore.instance.collection('task');
    var snapshot = await collection.where('is_done', isEqualTo: false).getDocument();
    snapshot.documents.forEach((task) {
      Task undoneTask = Task(
        title: task.data['title'],
        isDone: task.data['is_done'],
        createdTime: task.data['created_time']
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(widget.undoneTaskList[index].title),
            value: widget.undoneTaskList[index].isDone,
            onChanged: (bool? value) {
              //①完了未完了の情報を更新
              widget.undoneTaskList[index].isDone = value!;
              //②完了したタスクを完了タスクリストに追加
              widget.doneTaskList.add(widget.undoneTaskList[index]);
              //③完了したタスクを未完了タスクリストから削除
              widget.undoneTaskList.removeAt(index);
              //④画面を再描画
              setState(() {});
            },
            secondary: IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () {
                //ボトムシートを表示
                showModalBottomSheet(context: context, builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text('編集'),
                        leading: Icon(Icons.edit),
                        onTap: () {
                          //編集の処理
                          //①ボトムシートを非表示
                          Navigator.pop(context);
                          //②編集用のダイアログを表示
                          showDialog(context: context, builder: (context) {
                            return SimpleDialog(
                              titlePadding: EdgeInsets.all(20),
                              title: Container(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    Text('タイトル先を編集'),
                                    Container(
                                      width: 500,
                                      child: TextField(
                                        controller: editTitleController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder()
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 30.0),
                                      child: Container(
                                        width: 200,
                                        height: 30,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            widget.undoneTaskList[index].title = editTitleController.text;
                                            widget.undoneTaskList[index].updatedTime = DateTime.now();
                                            Navigator.pop(context);
                                            setState(() {});
                                          },
                                          child: Text('編集'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                        },
                      ),
                      ListTile(
                        title: Text('削除'),
                        leading: Icon(Icons.delete),
                        onTap: () {
                          //削除の処理
                          //①ボトムシートを非表示
                          Navigator.pop(context);
                          //②編集用のダイアログを表示
                          showDialog(context: context, builder: (context) {
                            return AlertDialog(
                              title: Text('${widget.undoneTaskList[index].title}を削除しますか？'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      widget.undoneTaskList.removeAt(index);
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    child: Text('はい')
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('キャンセル'),
                                ),
                              ],
                            );
                          });
                        },
                      )
                    ],
                  );
                });
              },
            ),
          );
        },
        itemCount: widget.undoneTaskList.length,
    );
  }
}
