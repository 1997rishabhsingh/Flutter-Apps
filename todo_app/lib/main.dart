import 'package:flutter/material.dart';
import 'package:todo_app/ui/home.dart';

void main() => runApp(Home());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Home(),
    );
  }
}