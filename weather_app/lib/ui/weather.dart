import 'dart:convert';

import 'package:flutter/material.dart';
import '../util/utils.dart';
import 'package:http/http.dart' as http;

class Weather extends StatefulWidget {
  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {

  String _enteredCity;
  void doStuff() async {
    Map s = await getWeather(apiId, defaultCity);
    print(s.toString());
  }

  Future _goToNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return ChangeCity();
    }));

    if(results!=null && results.containsKey('city')) {
      print(results['city']);
      _enteredCity = results['city'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather'),
        centerTitle: true,
        backgroundColor: Colors.orange,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _goToNextScreen(context);
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              'images/umbrella.png',
              width: 490,
              fit: BoxFit.fill,
              height: 1200,
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.fromLTRB(0, 10.9, 20.9, 0),
            //LTRB-Left, Top, Right, Bottom
            child: Text(
              _enteredCity == null ? defaultCity : _enteredCity,
              style: cityStyle(),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Image.asset('images/light_rain.png'),
          ),
          Container(

            child: updateTempWidget(_enteredCity),
          )
        ],
      ),
    );
  }

  Future<Map> getWeather(String appId, String city) async {
    String url =
        'http://api.openweathermap.org/data/2.5/weather?q=$city&APPID=$appId&units=metric';

    print(url);
    http.Response response = await http.get(url);

    return json.decode(response.body);
  }

  Widget updateTempWidget(String city) {
    return FutureBuilder(
      future: getWeather(apiId, city == null ? defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.hasData) {
          Map content = snapshot.data;
          if(content['cod'] == '404') {
            return Center(child: Container(
              margin: EdgeInsets.only(top: 150),
              child: Text('City not found!!', style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400)),
            ));
          }
          //_enteredCity = content['name'];
          print(content['main']['temp'].toString());
          return Container(
            margin: EdgeInsets.fromLTRB(30, 350, 0, 0),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    content['main']['temp'].toString() + ' °C',
                    style: tempStyle(),
                  ),
                  subtitle: ListTile(
                    title: Text(
                      'Humidity: ${content['main']['humidity'].toString()}\n'
                          'Min: ${content['main']['temp_min'].toString()}\n'
                          'Max: ${content['main']['temp_max'].toString()}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.9,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class ChangeCity extends StatelessWidget {
  final _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Change City'),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              'images/white_snow.png',
              width: 490,
              height: 1200,
              fit: BoxFit.fill,
            ),
          ),
          ListView(
            children: <Widget>[
              ListTile(
                title: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter City',
                  ),
                  controller: _cityController,
                  keyboardType: TextInputType.text,
                ),
              ),
              ListTile(
                title: FlatButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'city': _cityController.text
                    });
                  },
                  child: Text('Get Weather'),
                  textColor: Colors.white70,
                  color: Colors.redAccent,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

TextStyle cityStyle() {
  return TextStyle(
      color: Colors.white, fontSize: 22.9, fontStyle: FontStyle.italic);
}

TextStyle tempStyle() {
  return TextStyle(
      color: Colors.white,
      fontSize: 49.9,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500);
}
