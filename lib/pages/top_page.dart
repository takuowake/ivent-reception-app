import 'package:flutter/material.dart';
import 'package:webtotop/pages/add_name_page.dart';
import 'package:webtotop/pages/attendance_name_page.dart';
import 'package:webtotop/pages/unconfirmed_name_page.dart';

import '../model/participant.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key, required this.name});
  final String name;

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  List<Participant> unconfirmedNameList = [];
  bool showUnconfirmedNamePage = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('イベント出欠管理アプリ'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          showUnconfirmedNamePage
              ? UnconfirmedNamePage()
              : const AttendanceNamePage(),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    showUnconfirmedNamePage = true;
                    setState(() {

                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    color: Colors.redAccent,
                    child: const Text(
                      '未確認',
                      style: TextStyle(color: Colors.white, fontSize: 20),),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    showUnconfirmedNamePage = false;
                    setState(() {

                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    color: Colors.greenAccent,
                    child: const Text('出席', style: TextStyle(color: Colors.white, fontSize: 20),),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddNamePage()));
          setState(() {});
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}