import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';

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

  bool _modoAviao = false;
  bool _bluetooth = false;
  bool _wifiStatus = false;
  bool _wifiRede = false;
  bool _hotSpotPresenca = false;
  bool _hotSpotInternet = false;

  List _dataList = [];

  StreamSubscription<Position> positionStream;

  @override
  void initState() {
    super.initState();

    _getData().then((data) {
      _dataList = jsonDecode(data);
    });
  }

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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.restore_page),
            onPressed: _resetList,
          )
        ],
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
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SwitchListTile(
              title: Text("Modo Avião"),
              secondary: Icon(Icons.flight),
              value: _modoAviao,
              onChanged: (bool value) {
                setState(() {
                  _modoAviao = value;
                });
                print("Modo Avião " + _modoAviao.toString());
              },
            ),
            SwitchListTile(
              title: Text("Bluetooth"),
              secondary: Icon(Icons.bluetooth),
              value: _bluetooth,
              onChanged: (bool value) {
                setState(() {
                  _bluetooth = value;
                });
                print("Bluetooth " + _bluetooth.toString());
              },
            ),
            SwitchListTile(
              title: Text("Wifi Status Int."),
              secondary: Icon(Icons.wifi_lock),
              value: _wifiStatus,
              onChanged: (bool value) {
                setState(() {
                  _wifiStatus = value;
                });
                print("Bluetooth " + _wifiStatus.toString());
              },
            ),
            SwitchListTile(
              title: Text("Wifi Rede Conectada"),
              secondary: Icon(Icons.wifi),
              value: _wifiRede,
              onChanged: (bool value) {
                setState(() {
                  _wifiRede = value;
                });
                print("WifiRede " + _wifiRede.toString());
              },
            ),
            SwitchListTile(
              title: Text("Hotspot Presença"),
              secondary: Icon(Icons.phone_iphone),
              value: _hotSpotPresenca,
              onChanged: (bool value) {
                setState(() {
                  _hotSpotPresenca = value;
                });
                print("Hotspot Presença " + _hotSpotPresenca.toString());
              },
            ),
            SwitchListTile(
              title: Text("Hotspot Internet"),
              secondary: Icon(Icons.phonelink_ring),
              value: _hotSpotInternet,
              onChanged: (bool value) {
                setState(() {
                  _hotSpotInternet = value;
                });
                print("Hotspot Internet " + _hotSpotInternet.toString());
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text('Iniciar'),
                  onPressed: () => _getLiveLocation(3),
                  color: Colors.blueAccent,
                ),
                SizedBox(
                  width: 20,
                ),
                RaisedButton(
                  child: Text('Parar'),
                  onPressed: _destroyLiveLocationSubscribe,
                  color: Colors.red,
                ),
                // RaisedButton(
                //   child: Text('Best'),
                //   onPressed: _getCurrentLocation(2),
                // ),
                // RaisedButton(
                //   child: Text('BFN'),
                //   onPressed: _getCurrentLocation(3),
                // ),
              ],
            ),
            // Text(
            //   'Posição Atual',
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            // if (_currentPosition != null)
            //   Text(
            //     'Lat: ${_currentPosition.latitude}, Lng: ${_currentPosition.longitude}',
            //   ),
            // if (_currentPosition != null)
            //   Text('Accuracy: ${_currentPosition.accuracy}'),
            // if (_currentPosition != null)
            //   Text('Heading: ${_currentPosition.heading}'),
            // if (_currentPosition != null)
            //   Text('Speed: ${_currentPosition.speed}'),
            // if (_currentPosition != null)
            //   Text('Speed Accuracy: ${_currentPosition.speedAccuracy}'),
            // if (_currentPosition != null)
            //   Text('Altitude: ${_currentPosition.altitude}'),
            // if (_currentPosition != null)
            //   Text('TimeStamp ${_currentPosition.timestamp}'),
            // SizedBox(
            //   height: 80,
            // ),
            Text('Live Position', style: TextStyle(fontWeight: FontWeight.bold),),
            if(_livePosition != null) Text('Lat: ${_livePosition.latitude.toString()}, Lng: ${_livePosition.longitude.toString()}'),
            if(_livePosition != null) Text('Accuracy: ${_livePosition.accuracy}'),
            if(_livePosition != null) Text('Heading: ${_livePosition.heading}'),
            if(_livePosition != null) Text('Speed: ${_livePosition.speed}'),
            if(_livePosition != null) Text('Speed Accuracy: ${_livePosition.speedAccuracy}'),
            if(_livePosition != null) Text('Altitude: ${_livePosition.altitude}'),
            if(_livePosition != null) Text('TimeStamp ${_livePosition.timestamp}'),
            //  Row(
            //    mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     RaisedButton(
            //       child: Text('High'),
            //       onPressed: _getLiveLocation(1),
            //     ),
            //     RaisedButton(
            //       child: Text('Best'),
            //       onPressed: _getLiveLocation(2),
            //     ),
            //     RaisedButton(
            //       child: Text('BFN'),
            //       onPressed: _getLiveLocation(3),
            //     ),
            //   ],
            // ),
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
        onPressed: _printJson,
        tooltip: 'Increment',
        child: Icon(Icons.gps_fixed),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _getCurrentLocation(int accuracy) {
    print("Apertou o Botão");
    final Geolocator geolocator = Geolocator();
    var locationAccuracy = _setAccuracy(accuracy);

    geolocator
        .getCurrentPosition(desiredAccuracy: locationAccuracy)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _addList(_currentPosition);
      });
    }).catchError((e) {
      print(e);
      _neverSatisfied(e);
    });
  }

  void _checkLocation(int accuracy) {
    print("apertou checklocation");
    final Geolocator geolocator = Geolocator();

    var locationAccuracy = _setAccuracy(accuracy);

    geolocator
        .getCurrentPosition(desiredAccuracy: locationAccuracy)
        .timeout(Duration(seconds: 2))
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _addList(_currentPosition);
      });
    }).catchError((e) {
      print(e);
      _neverSatisfied(e);
    });
  }

  void _getLiveLocation(int accuracy) {
    print("Apertou Live Location");
    final Geolocator geolocator = Geolocator();
    var locationAccuracy = _setAccuracy(accuracy);
    var locationOptions =
        LocationOptions(accuracy: locationAccuracy, distanceFilter: 1, timeInterval: 5);

    positionStream = geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      setState(() {
        _livePosition = position;
        _addList(_livePosition);
      });
    });
  }

  void _destroyLiveLocationSubscribe() {
    print("cancelando subscribe");
    positionStream.cancel();
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

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    print("File Path: ${directory.path}/data.json");
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = jsonEncode(_dataList);

    final file = await _getFile();
    print("Salvando no JSON");
    return file.writeAsString(data);
  }

  Future<String> _getData() async {
    try {
      final file = await _getFile();

      return file.readAsString();
    } catch (e) {
      print("ERROR: " + e);
    }
  }

  void _printJson() {
    _getData().then((data) {
      print(jsonDecode(data));
    });
  }

  void _addList(Position position) {
    Map<String, dynamic> newData = Map();
    setState(() {
      newData["Modo Avião"] = _modoAviao.toString();
      newData["Bluetooth"] = _bluetooth.toString();
      newData["Wifi Status Int."] = _wifiStatus.toString();
      newData["Wifi Rede Conectada"] = _wifiRede.toString();
      newData["Hotspot Presença"] = _hotSpotPresenca.toString();
      newData["Hotspot Internet"] = _hotSpotInternet.toString();
      newData["Lat"] = position.latitude.toString();
      newData["Lng"] = position.longitude.toString();
      newData["accuracy"] = position.accuracy.toString();
      newData["heading"] = position.heading.toString();
      newData["speed"] = position.speed.toString();
      newData["speed accuracy"] = position.speedAccuracy.toString();
      newData["altitude"] = position.altitude.toString();
      newData["timestamp"] = position.timestamp.toString();
      _dataList.add(newData);
      print("Salvo na Lista");
      _saveData();
    });
  }

  void _resetList() {
    _dataList = [];
  }

  Future<void> _neverSatisfied(e) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(e),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
