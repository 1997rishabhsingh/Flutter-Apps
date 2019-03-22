import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
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
  String _savedMessage ;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.
    if (prefs.getString('data') != null && prefs.getString('data').isNotEmpty) {
      _savedMessage = prefs.getString('data');
    } else {
      _savedMessage = 'Empty..';
    }
  }

  _saveData(String message) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('data', message);
  }

  _clearData() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.clear();
  }

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
                setState(() {
                  _saveData(_dataController.text);
                });

              },
              child: Text('Save Data'),
            ),
            Text(_savedMessage),
            RaisedButton(
              child: Text('Clear Data'),
              onPressed: () {
                setState(() {
                  _clearData();
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
