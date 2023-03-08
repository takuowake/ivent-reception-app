import 'dart:async';
import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';


class AddNamePage extends StatefulWidget {
  const AddNamePage({super.key});
  @override
  State<AddNamePage> createState() => _AddNamePageState();
}

class _AddNamePageState extends State<AddNamePage> {
  TextEditingController participantController = TextEditingController();
  List<String> lines = [];
  String qrData = '';

  @override
  void initState() {
    super.initState();
    participantController.addListener(() {
      setState(() {
        lines.clear();
        String value = participantController.text;
        lines.addAll(value.split('\n'));
      });
    });
  }

  Future<void> addNames() async {
    for (String line in lines) {
      await insertName(line);
    }
  }

  Future<void> insertName(String name) async {
    // Firestoreのparticipantコレクションにアクセスするための参照を作成
    final collection = FirebaseFirestore.instance.collection('participant');
    for (var line in lines) {
      await collection.add({
        'name': line.trim(),
        'attendance': false,
        'entered_time': Timestamp.now(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('参加者追加'),
      ),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text('名前'),
            ),
            SizedBox(
                width: 500,
                child: Column(
                  children: [
                    TextFormField(
                      controller: participantController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder()
                      ),
                    ),
                  ],
                ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      insertName(lines.join('\n'));
                      Navigator.pop(context);
                    },
                    child: const Text('追加')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SizedBox(
                width: 250,
                height: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white
                  ),
                  onPressed: () async{
                    setState(() {
                      qrData = 'window.location.href/check-form';
                    });
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QRDisplayScreen(qrData: qrData)
                      ),
                    );
                  },
                  child: const Text('参加者フォームのQRコードを生成', style: TextStyle(color: Colors.black))
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SizedBox(
                width: 250,
                height: 30,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white
                    ),
                    onPressed: () async {
                      const url = 'https://todo-2e1ff.firebaseapp.com/check-form';
                      await Clipboard.setData(ClipboardData(text: url));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Copied to Clipboard')),
                      );
                    },
                    child: const Text('参加者フォームのURLをコピー', style: TextStyle(color: Colors.black))
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class QRDisplayScreen extends StatelessWidget {
  final String qrData;
  const QRDisplayScreen({Key? key, required this.qrData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImage(
              data: qrData,
              version: QrVersions.auto,
              size: 250,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

