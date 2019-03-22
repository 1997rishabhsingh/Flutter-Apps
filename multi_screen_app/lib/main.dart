import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MaterialApp(home: Home()));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _nameController = TextEditingController();

  Future _gotToNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return NextScreen(name: _nameController.text,);
      })
    );

    if(results!=null && results.containsKey('info')) {
      _nameController.text = results['info'].toString();
    } else {
      print('Noooo');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Screen'),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Enter Name'),
            ),
          ),
          ListTile(
            title: RaisedButton(
              onPressed: () {
                _gotToNextScreen(context);
              },
              child: Text('Next screen'),
            ),
          )
        ],
      ),
    );
  }
}

class NextScreen extends StatefulWidget {
  final String name;

  NextScreen({Key key, this.name}) : super(key: key);

  @override
  _NextScreenState createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {

  var _backController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
      ),
//      body: ListTile(
//        title: Text('${widget.name}'),
//      ),

      body: Container(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('${widget.name}'),
            ),
            ListTile(
              title: TextField(
                controller: _backController,
              ),
            ),
            ListTile(
              title: FlatButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'info': _backController.text
                  });
                },
                child: Text('Send Back'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
