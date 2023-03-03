import 'package:flutter/material.dart';

import '../model/task.dart';

class DoneTaskPage extends StatefulWidget {
  const DoneTaskPage({Key? key, required this.undoneTaskList, required this.doneTaskList}) : super(key: key);
  final List<Task> undoneTaskList;
  final List<Task> doneTaskList;


  @override
  State<DoneTaskPage> createState() => _DoneTaskPageState();
}

class _DoneTaskPageState extends State<DoneTaskPage> {
  TextEditingController editTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(widget.doneTaskList[index].title),
          value: widget.doneTaskList[index].isDone,
          onChanged: (bool? value) {
            widget.doneTaskList[index].isDone = value!;
            widget.undoneTaskList.add(widget.doneTaskList[index]);
            widget.doneTaskList.removeAt(index);
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
                                          widget.doneTaskList[index].title = editTitleController.text;
                                          widget.doneTaskList[index].updatedTime = DateTime.now();
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
                            title: Text('${widget.doneTaskList[index].title}を削除しますか？'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    widget.doneTaskList.removeAt(index);
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
      itemCount: widget.doneTaskList.length,
    );
  }
}
