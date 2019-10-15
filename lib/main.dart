import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _currentPosition;
  var _livePosition;
  var _geoStatus;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Location'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Posição Atual', style: TextStyle(fontWeight: FontWeight.bold),),
            if (_currentPosition != null)
              Text(
                'Lat: ${_currentPosition.latitude}, Lng: ${_currentPosition.longitude}',
              ),
            if (_currentPosition != null) Text('Accuracy: ${_currentPosition.accuracy}'),
            if (_currentPosition != null) Text('Heading: ${_currentPosition.heading}'),
            if (_currentPosition != null) Text('Speed: ${_currentPosition.speed}'),
            if (_currentPosition != null) Text('Speed Accuracy: ${_currentPosition.speedAccuracy}'),
            if (_currentPosition != null) Text('Altitude: ${_currentPosition.altitude}'),
            if (_currentPosition != null) Text('TimeStamp ${_currentPosition.timestamp}'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text('High'),
                  onPressed: _getCurrentLocation(1),
                ),
                RaisedButton(
                  child: Text('Best'),
                  onPressed: _getCurrentLocation(2),
                ),
                RaisedButton(
                  child: Text('BFN'),
                  onPressed: _getCurrentLocation(3),
                ),
              ],
            ),
            SizedBox(height: 80,),
            Text('Live Position', style: TextStyle(fontWeight: FontWeight.bold),),
            if(_livePosition != null) Text('Lat: ${_livePosition.latitude.toString()}, Lng: ${_livePosition.longitude.toString()}'),
            if(_livePosition != null) Text('Accuracy: ${_livePosition.accuracy}'),
            if(_livePosition != null) Text('Heading: ${_livePosition.heading}'),
            if(_livePosition != null) Text('Speed: ${_livePosition.speed}'),
            if(_livePosition != null) Text('Speed Accuracy: ${_livePosition.speedAccuracy}'),
            if(_livePosition != null) Text('Altitude: ${_livePosition.altitude}'),
            if(_livePosition != null) Text('TimeStamp ${_livePosition.timestamp}'),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text('High'),
                  onPressed: _getLiveLocation(1),
                ),
                RaisedButton(
                  child: Text('Best'),
                  onPressed: _getLiveLocation(2),
                ),
                RaisedButton(
                  child: Text('BFN'),
                  onPressed: _getLiveLocation(3),
                ),
              ],
            ),
        //     Text('Status', style: TextStyle(fontWeight: FontWeight.bold),),
        //     if(_geoStatus != null)
        //       Text(_geoStatus),
        //       RaisedButton(
        //         child: Text('Get Status'),
        //         onPressed: _getStatus(),
        //       )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Increment',
        child: Icon(Icons.gps_fixed),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _getCurrentLocation(int accuracy) {
    print("Apertou o Botão");
    final Geolocator geolocator = Geolocator();
    var locationAccuracy = _setAccuracy(accuracy);

    geolocator
        .getCurrentPosition(desiredAccuracy: locationAccuracy)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getLiveLocation(int accuracy) {
    print("Apertou Live Location");
    final Geolocator geolocator = Geolocator();
    var locationAccuracy = _setAccuracy(accuracy);
    var locationOptions = LocationOptions(
        accuracy: locationAccuracy, distanceFilter: 5);

    StreamSubscription<Position> positionStream = geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      setState(() {
        _livePosition = position;
      });
    });
  }

  // _getStatus() async {
  //   final GeolocationStatus geolocatorStatus =
  //       await Geolocator().checkGeolocationPermissionStatus();
  //   setState(() {
  //     _geoStatus = geolocatorStatus.toString();
  //   });
  // }

  LocationAccuracy _setAccuracy(accuracy) {
    var locationAccuracy;

    switch (accuracy) {
      case 1:
        locationAccuracy = LocationAccuracy.high;
        break;
      case 2:
        locationAccuracy = LocationAccuracy.best;
        break;
      case 3:
        locationAccuracy = LocationAccuracy.bestForNavigation;
        break;
      default:
        locationAccuracy = null;
        break;
    }

    return locationAccuracy;
  }
}
