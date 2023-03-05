import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:webtotop/pages/success_attendance_page.dart';

class CheckForm extends StatefulWidget {
  const CheckForm({Key? key}) : super(key: key);

  @override
  State<CheckForm> createState() => _CheckFormState();
}

class _CheckFormState extends State<CheckForm> {
  final myController = TextEditingController();
  late String name;

  // Firestoreのparticipantコレクションにアクセスするための参照を作成
  final participantCollection = FirebaseFirestore.instance.collection('participant');

  // participantを更新するメソッド
  Future<void> updateAttendance(String name) async {
    final participants = await participantCollection.where('name', isEqualTo: name).get();
    if(participants.docs.isNotEmpty) {
      // 参加者が見つかった場合、出席状況を更新
      final participant = participants.docs.first;
      await participant.reference.update({'attendance': true});
      Navigator.push(context, MaterialPageRoute(builder: (context) => SuccessAttendance(name: '',)),);
    } else {
        // 参加者が見つからなかった場合、エラーメッセージを表示
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('⚠️エラー️', textAlign: TextAlign.center,),
            content: Text(
              'ご入力されたお名前が見つかりませんでした。\nもう一度、ご登録されたお名前を入力いただく\nもしくは、スタッフまでお声掛けください。',
              style: TextStyle(
                fontSize: 12.5
              ),
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('出席確認'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: myController,
                decoration: InputDecoration(
                  labelText: 'お名前をご入力ください',
                ),
                style: TextStyle(
                  fontSize: 20,
                ),
                onChanged: (text) {
                  name = text;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: ElevatedButton(
                  child: Text('出席'),
                  onPressed: () async {
                    // 参加者の出席を更新
                    await updateAttendance(name);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
