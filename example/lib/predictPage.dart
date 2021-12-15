import 'dart:async';
import 'dart:io';
import 'package:flutter_blue_example/file_provide.dart';
import 'package:flutter_blue_example/main.dart';
import 'package:flutter/material.dart';
import "dart:math";
import 'package:flutter_blue/flutter_blue.dart';

Map mse_map = {};

double min = 999999;
String min_loc = '';

Map radio_map = {};
List map_list = [];

class predictPage extends StatelessWidget{

  String contents = '';
  List name_list = [];

  predictPage(this.contents, this.name_list);

  @override
  Widget build(BuildContext context) {
    radio_map = split_contents(contents);
    map_list = radio_map.keys.toList();
    print(radio_map);
    return Scaffold(
        appBar: AppBar(
          title: Text("현재 위치 예측",
              style: TextStyle(color: Colors.white)),
        ),
        body: predPage(),
    );
  }

  Map<dynamic,dynamic> split_contents(String contents){
    Map radio_map = {};
    List temp2 = [];
    List temp = contents.split('[]');
    temp.removeAt(0);
    for(var x in temp){
      temp2 = x.split(';');
      radio_map[temp2[0]] = [double.parse(temp2[1]), double.parse(temp2[2]), double.parse(temp2[3])];
    }
    return radio_map;
  }
}

class predPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new predPageState();


  //context를 반환하는 함수 'of'를 static으로 생성한다.
  // tic predPageState of(BuildContext context) =>
  //     context.findAncestorStateOfType<predPageState>(); sta
}

class predPageState extends State<predPage> {

  FlutterBlue flutterBlue = FlutterBlue.instance;
  String contents = '';
  List name_list = [];

  String cur_loc = 'where';

  @override Widget build(BuildContext context) {

    return Center(child:
    Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
          children:[
        Container(
          margin: EdgeInsets.only(top: 20, right : 20),
          child:RaisedButton(
            child: Text('Start',
                style: TextStyle(color: Colors.white)),
            onPressed: (){
              pred_scan(flutterBlue, map_list, radio_map);
            },
            color: Colors.lightBlue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20, left : 20),
          child:RaisedButton(
            child: Text('Stop',
                style: TextStyle(color: Colors.white)),
            onPressed: (){
              flutterBlue.stopScan();
            },
            color: Colors.lightBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            ),
          ),
        ),
      ]),

      Container(
        child: Text(
          "room2",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.lightBlue)
        ),
        padding: EdgeInsets.only(top: 200, bottom: 15),
        width: 300,
      ),
    ]));
  }

void predict_MSE(List name_list, Map radio_map, List now){

  print(radio_map);

  min = 999999;
  min_loc = '';
  double mse ;

  for(var loc in name_list) {
    print('${loc}');

    mse = 0;
    for (var i = 0; i < now.length; i++) {
      mse += pow(radio_map[loc][i]-now[i],2);
    }
    mse /= now.length;
    mse_map[loc] = mse;
    if (mse < min) {
      min = mse;
      min_loc = loc;

    }
  }
}

void pred_scan(FlutterBlue flutterBlue, List map_list, Map radio_map){

  List<dynamic> location = [0,0,0];

  flutterBlue = FlutterBlue.instance;
  flutterBlue.startScan(timeout: Duration(seconds: 5));

  var subscription = flutterBlue.scanResults.listen((results) {
    for (ScanResult r in results) {
      if(r.device.name == name_list[0]){
        location[0] = r.rssi;
      }
      if(r.device.name == name_list[1]){
        location[1] = r.rssi;
      }
      if(r.device.name == name_list[2]){
        location[2] = r.rssi;
      }
      print('location : ${location}');
      predict_MSE(map_list, radio_map, location);
    }
  });
}

void change_loc() {
    setState(() {
      cur_loc = min_loc;
    });
  }
}
