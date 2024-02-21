import 'package:flutter/material.dart';
import 'package:loginpage/loginpage.dart';


void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

