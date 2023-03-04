import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UndoneTaskPage extends StatefulWidget {
  @override
  State<UndoneTaskPage> createState() => _UndoneTaskPageState();
}

class _UndoneTaskPageState extends State<UndoneTaskPage> {
  TextEditingController editTitleController = TextEditingController();
  late CollectionReference tasks;

  @override
  void initState() {
    super.initState();
    tasks = FirebaseFirestore.instance.collection('task');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: tasks.snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              if(snapshot.data?.docs[index]['is_done']) return Container();
              return CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(snapshot.data?.docs[index]['title']),
                value: snapshot.data?.docs[index]['is_done'],
                onChanged: (bool? value) {
                  snapshot.data?.docs[index].reference.update({
                    'is_done': value,
                    'updated_time': Timestamp.now()
                  });
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
                                              onPressed: () async{
                                                await snapshot.data?.docs[index].reference.update({
                                                  'title': editTitleController.text
                                                });
                                                Navigator.pop(context);
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
                                  title: Text('${snapshot.data?.docs[index]['title']}を削除しますか？'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          snapshot.data?.docs[index].reference.delete();
                                          Navigator.pop(context);
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
            itemCount: snapshot.data?.docs.length,
          );
        } else {
          return Container();
        }
      }
    );
  }
}
