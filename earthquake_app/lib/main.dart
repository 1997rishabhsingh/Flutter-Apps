import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Quake App'),
          centerTitle: true,
          backgroundColor: Colors.pinkAccent,
        ),
        body: Center(
          child: FutureBuilder(
            future: getQuake(),
            builder: (context, AsyncSnapshot map) {
              if(map.hasData) {
                if(map.data != null) {
                  List features = map.data['features'];
                  return ListView.separated(
                    separatorBuilder: (BuildContext context, int index) => Divider(),
                    itemCount: features.length,
                    padding: EdgeInsets.all(15),
                    itemBuilder: (BuildContext context, int position) {

                      // https://pub.dartlang.org/packages/intl#-readme-tab-
                      // https://pub.dartlang.org/documentation/intl/latest/intl/DateFormat-class.html


                      var timeFormat = DateFormat.yMMMMd("en_US").add_jm();

                      return ListTile(
                        leading: CircleAvatar(
                          child: Text('${features[position]['properties']['mag']}'),
                        ),
                        title: Text(
                          '${features[position]['properties']['place']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'At ${timeFormat.format(DateTime.fromMillisecondsSinceEpoch(features[position]['properties']['time']))}',
                          style: TextStyle(
                              fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          var coordinates = features[position]['geometry']['coordinates'];
                          showAlertDialog(context, coordinates);
                        },
                      );
                    },
                  );
                }
              }
              else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      )));
}

Future<Map> getQuake() async {
  String apiUrl = 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson';

  // String apiUrl = 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson';

  http.Response response = await http.get(apiUrl);

  return json.decode(response.body);
}

void showAlertDialog(BuildContext context, var coordinates) {
  debugPrint('${coordinates[0]}, ${coordinates[1]}');

  var alert = AlertDialog(
    title: Center(child: Text('Coordinates')),
    content: Text('${coordinates[0]}, ${coordinates[1]}'),
    actions: <Widget>[
      FlatButton(
        child: Text('OK'),
        onPressed: () {
          // Navigator.pop(context);
          Navigator.of(context).pop();
        },
      )
    ],
  );

  showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) => alert);
}
