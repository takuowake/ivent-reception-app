import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SuccessAttendance extends StatefulWidget {
  final String name;
  const SuccessAttendance({Key? key, required this.name}) : super(key: key);

  @override
  State<SuccessAttendance> createState() => _SuccessAttendanceState();
}

class _SuccessAttendanceState extends State<SuccessAttendance> {
  late List<QueryDocumentSnapshot>? documents = [];
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    loadParticipant();
  }

  Future<void> loadParticipant() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('participant').where('name', isEqualTo: widget.name).get();
    setState(() {
      documents = querySnapshot.docs;
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('出席確認完了'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Container(
          width: 500,
          height: 300,
          decoration: BoxDecoration(color: Colors.blueAccent),
          child: Center(
            child: Text(
              '当イベントにご参加いただき\nありがとうございます。\n\n受付が完了いたしました。',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
