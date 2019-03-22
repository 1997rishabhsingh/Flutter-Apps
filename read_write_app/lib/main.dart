import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  var data = await readData();

  print(data);
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _dataController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Read/Write'),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(13.4),
        alignment: Alignment.topCenter,
        child: Column(
          children: <Widget>[
            TextField(
              controller: _dataController,
              decoration: InputDecoration(hintText: 'Write here'),
            ),
            FlatButton(
              color: Colors.red,
              onPressed: () {

                setState(() { //causes the text to update instantly!
                  writeData(_dataController.text);
                });
              },
              child: Text('Save Data'),
            ),
            FutureBuilder(
              future: readData(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if(snapshot.hasData) {
                  return Text(snapshot.data);
                } else {
                  return Text('Nothing....');
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/data.txt');
}

Future<File> writeData(String message) async {
  final file = await _localFile;

  return file.writeAsString(message);
}

Future<String> readData() async {
  try {
    final file = await _localFile;
    String data = await file.readAsString();
    return data;
  } catch (e) {
    return 'Nothing yet!';
  }
}
