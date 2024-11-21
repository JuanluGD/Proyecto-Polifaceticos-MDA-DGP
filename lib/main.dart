import 'package:flutter/material.dart';


import 'package:proyecto/interfaces/login.dart' as loginPage;

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
      home: loginPage.StudentListPage(),
    );
  }
}

