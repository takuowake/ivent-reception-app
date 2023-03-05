import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:webtotop/firebase_options.dart';

import 'pages/top_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const CheckForm(),
      home: const TopPage(name: '',),
    );
  }
}


