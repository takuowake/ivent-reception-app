import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  TextEditingController titleController = TextEditingController();

  Future<void> insertTask(String title) async {
    final collection = FirebaseFirestore.instance.collection('task');
    collection.add({
      'title': title,
      'is_done': false,
      'created_time': Timestamp.now()
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('タスクを追加'),
      ),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text('タイトル'),
            ),
            SizedBox(
                width: 500,
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder()
                  ),
                )
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                    onPressed: () async{
                      await insertTask(titleController.text);
                      Navigator.pop(context);
                    },
                    child: const Text('追加')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
