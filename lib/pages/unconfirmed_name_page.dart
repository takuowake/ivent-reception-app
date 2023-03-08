import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UnconfirmedNamePage extends StatefulWidget {
  const UnconfirmedNamePage({super.key});

  @override
  State<UnconfirmedNamePage> createState() => _UnconfirmedNamePageState();
}

class _UnconfirmedNamePageState extends State<UnconfirmedNamePage> {
  TextEditingController editNameController = TextEditingController();
  late CollectionReference participants;

  @override
  void initState() {
    super.initState();
    // Firestoreのparticipantコレクションにアクセスするための参照を作成
    participants = FirebaseFirestore.instance.collection('participant');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            '未確認'
        ),
        backgroundColor: Colors.redAccent,
      ),
        body: StreamBuilder<QuerySnapshot>(
            stream: participants.snapshots(),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    if(snapshot.data?.docs[index]['attendance']) return Container();
                    return Column(
                      children: [
                        CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(snapshot.data?.docs[index]['name']),
                          value: snapshot.data?.docs[index]['attendance'],
                          onChanged: (bool? value) {
                            snapshot.data?.docs[index].reference.update({
                              'attendance': value,
                              'entered_time': Timestamp.now()
                            });
                          },
                          secondary: IconButton(
                            icon: const Icon(Icons.more_horiz),
                            onPressed: () {
                              //ボトムシートを表示
                              showModalBottomSheet(context: context, builder: (context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      title: const Text('編集'),
                                      leading: const Icon(Icons.edit),
                                      onTap: () {
                                        //編集の処理
                                        //①ボトムシートを非表示
                                        Navigator.pop(context);
                                        //②編集用のダイアログを表示
                                        showDialog(context: context, builder: (context) {
                                          return SimpleDialog(
                                            titlePadding: const EdgeInsets.all(20),
                                            title: Container(
                                              color: Colors.white,
                                              child: Column(
                                                children: [
                                                  const Text('タイトル先を編集'),
                                                  SizedBox(
                                                    width: 500,
                                                    child: TextField(
                                                      controller: editNameController,
                                                      decoration: const InputDecoration(
                                                          border: OutlineInputBorder()
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 30.0),
                                                    child: SizedBox(
                                                      width: 200,
                                                      height: 30,
                                                      child: ElevatedButton(
                                                        onPressed: () async{
                                                          await snapshot.data?.docs[index].reference.update({
                                                            'name': editNameController.text
                                                          });
                                                          if(!mounted) return;
                                                          Navigator.pop(context);
                                                        },
                                                        child: const Text('編集'),
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
                                    Divider(
                                      thickness: 1,
                                      color: Colors.grey[300],
                                      indent: 16,
                                      endIndent: 16,
                                    ),
                                    ListTile(
                                      title: const Text('削除'),
                                      leading: const Icon(Icons.delete),
                                      onTap: () {
                                        //削除の処理
                                        //①ボトムシートを非表示
                                        Navigator.pop(context);
                                        //②編集用のダイアログを表示
                                        showDialog(context: context, builder: (context) {
                                          return AlertDialog(
                                            title: Text('${snapshot.data?.docs[index]['name']}を削除しますか？'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    snapshot.data?.docs[index].reference.delete();
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('はい')
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('キャンセル'),
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
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey[300],
                          indent: 16,
                          endIndent: 16,
                        ),
                      ],
                    );
                  },
                  itemCount: snapshot.data?.docs.length,
                );
              } else {
                return Container();
              }
            }
        )
    );
  }
}
