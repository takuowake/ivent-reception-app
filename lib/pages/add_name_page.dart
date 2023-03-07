import 'dart:ui';
import 'dart:async';
import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:webtotop/pages/check_form.dart';


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
                      // Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('参加者用のQRコードを生成しますか？', textAlign: TextAlign.center,),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('キャンセル'),
                            ),
                            TextButton(
                                onPressed: () async {
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
                              child: const Text('はい'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('追加')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckForm()));
                },
                child: const Text('参加者フォームへ移動', style: TextStyle(color: Colors.black))
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

  get qrImagePainter => null;

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
            TextButton(
              onPressed: () async {
                final qrImage = QrImage(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 250,
                );
                final uiImage = await qrImagePainter.toImage(250, 250);

                  // Convert the Image object to a byte array
                var ui;
                final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
                final bytes = byteData!.buffer.asUint8List();

                final blob = html.Blob([bytes]);

                final url = html.Url.createObjectUrlFromBlob(blob);

                //QRコードをダウンロード
                final anchor = html.AnchorElement()
                  ..href = url
                  ..setAttribute('download', 'qr_code.png')
                  ..style.display = 'block';

                html.document.body?.children.add(anchor);
                anchor.click();

                await Future.delayed(Duration.zero);

                html.document.body?.children.remove(anchor);
                html.Url.revokeObjectUrl(url);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('QRコードを保存しました！'),
                  ),
                );
              },
              child: const Text('ダウンロード'),
            ),
          ],
        ),
      ),
    );
  }
}

