import 'package:flutter/material.dart';


import 'package:proyecto/interfaces/hu3.dart' as principal;

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colegio San Rafael',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: principal.StudentLoginPage(),
    );
  }
}

