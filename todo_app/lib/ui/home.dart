import 'package:flutter/material.dart';
import 'package:todo_app/ui/todo_screen.dart';


class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('ToDo'),
          backgroundColor: Colors.black54,
        ),
        body: ToDoScreen(),
      ),
    );
  }
}
