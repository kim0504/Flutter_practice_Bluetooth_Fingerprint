// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_blue_example/file_provide.dart';
import 'package:flutter_blue_example/open_txt.dart';
import 'package:flutter_blue_example/predictPage.dart';
import 'package:flutter_blue_example/example.dart';
import 'package:flutter_blue_example/example2.dart';
import 'package:flutter_blue_example/widgets.dart';

// =====================================사용하려면 이거 리스트 수정해야댐.==================================
final List<String> name_list = ['Galaxy Tab A','Buds+', 'tony의 S21']; //이거 우리 집에 있는 tv랑, 내 버즈랑, 핸드폰으로 측정할 거 리스트로 만듬
// =====================================사용하려면 이거 리스트 수정해야댐.==================================

List<dynamic> scan_list = []; //블루투스 스캔할 때 한 번에 5~7개씩 값이 들어와서 중복 막으려고 만든 리스트
List<dynamic> device_list = []; //블루투스로 받은 기기 정보 볼려고 만든 리스트

List<dynamic> device1_rssi = []; //티비 rssi값
List<dynamic> device2_rssi = []; //버즈 rssi값
List<dynamic> device3_rssi = []; //핸드폰 rssi값

String inputs = ""; // 측정 공간 이름 -> 나중에 어디서 측정했는지 DB에 넣을려고 만듬
Map<String, dynamic> rssi_map = {};

int sum1=0, sum2=0, sum3=0, cnt1=0, cnt2=0, cnt3=0;
String save_rssi1='', save_rssi2='', save_rssi3='';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(

          primarySwatch: Colors.lightBlue,
        ),      home: ContainerWidget()
    );
  }
}

class ContainerWidget extends StatelessWidget {

  late final Storage storage = Storage();
  String contents = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Flutter example',
                style: TextStyle(color: Colors.white))
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 50, bottom: 5),
              ),
              RaisedButton(
                child: Text('Scan',
                    style: TextStyle(color: Colors.white)),
                onPressed: (){
                  blue_scan();
                },
                color: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                ),
              ),

              // RaisedButton(
              //   child: Text('Info',
              //       style: TextStyle(color: Colors.white)),
              //   onPressed: (){
              //     print('=================================================================');
              //     print(device_list);
              //     print('=================================================================');
              //     print(scan_list);
              //     print('=================================================================');
              //     print('sum1 : ${sum1}, cnt1 : ${cnt1}, sum2 : ${sum2}, cnt2 : ${cnt2}, sum3 : ${sum3}, cnt3 : ${cnt3}');
              //     print(rssi_map);
              //     print('=================================================================');
              //     print(rssi_map);
              //   },
              //   color: Colors.lightBlue,
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8)
              //   ),
              // ),


              Container(
                child: TextField(
                  style: TextStyle(fontSize: 20, color: Colors.lightBlue),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(),
                  onChanged: (String str) {
                    inputs = str;
                  },
                ),
                padding: EdgeInsets.only(top: 50, bottom: 5),
                width: 200,
              ),


              RaisedButton(
                child: Text('Save RSSI',
                    style: TextStyle(color: Colors.white)),
                onPressed: (){
                  storage.writeFile("[]${inputs};"
                      "${(sum1/cnt1).toStringAsFixed(2).toString()};"
                      "${(sum2/cnt2).toStringAsFixed(2).toString()};"
                      "${(sum3/cnt3).toStringAsFixed(2).toString()};");
                },
                color: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                ),
              ),

              Container(
                padding: EdgeInsets.only(top: 50, bottom: 20),
              ),

              RaisedButton(
                child: Text('ListView',
                    style: TextStyle(color: Colors.white)),
                onPressed: (){
                  contents = storage.sendText();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>readPage(contents, name_list)),
                  );
                },
                color: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                ),
              ),

              Container(
                padding: EdgeInsets.only(top: 5, bottom: 20),
              ),

              RaisedButton(
                child: Text('Predict',
                    style: TextStyle(color: Colors.white)),
                onPressed: (){
                  //blue_scan();
                  contents = storage.sendText();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>predictPage(contents, name_list)),
                  );
                },
                color: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                ),
              ),

              // RaisedButton(
              //   child: Text('example'),
              //   onPressed: (){
              //     //blue_scan();
              //     contents = storage.sendText();
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context)=>MyHomePage()),
              //     );
              //   },
              //   color: Colors.lightBlue,
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8)
              //   ),
              // ),

              // RaisedButton(
              //   child: Text('example2'),
              //   onPressed: (){
              //     blue_scan();
              //   },
              //   color: Colors.lightBlue,
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8)
              //   ),
              // )


            ] // children
          )
        )
    );
  }
}

// void blue_scan() {
//
//   rssi_map = {};
//
//   //초기화
//   scan_list = [];
//   device_list = [];
//
//   // Future<FlutterBlue> flutterBlue = getData();
//   FlutterBlue flutterBlue = FlutterBlue.instance;
//   flutterBlue.startScan(timeout: Duration(seconds: 4));
//
//   var subscription = flutterBlue.scanResults.listen((results) {
//     for (ScanResult r in results) {
//       print("===== ${r.device.name} : ${r.rssi} =====");
//       if(name_list.contains(r.device.name)){
//         if(!(scan_list.contains(r.device.name))){
//           device_list.add(r);
//           scan_list.add(r.device.name);
//           rssi_map.update(r.device.name, (value)=>r.rssi, ifAbsent: ()=> r.rssi);
//           if(r.device.name == name_list[0]){
//             device1_rssi.add(rssi_map[name_list[0]]);
//           }
//           if(r.device.name == name_list[1]){
//             device2_rssi.add(rssi_map[name_list[1]]);
//           }
//           if(r.device.name == name_list[2]){
//             device3_rssi.add(rssi_map[name_list[2]]);
//           }
//         }
//       }
//     }
//   });
//   print(rssi_map);// Listen to scan results
// }



void blue_scan(){

  sum1=0; sum2=0; sum3=0; cnt1=0; cnt2=0; cnt3=0;

  FlutterBlue flutterBlue = FlutterBlue.instance;
  flutterBlue.startScan(timeout: Duration(seconds: 10));

  var subscription = flutterBlue.scanResults.listen((results) {
    for (ScanResult r in results) {
      if(name_list.contains(r.device.name)) {
        print("===== ${r.device.name} : ${r.rssi} =====");
      }
      if(r.device.name == name_list[0]){
        sum1 += r.rssi;
        cnt1 += 1;
      }
      if(r.device.name == name_list[1]){
        sum2 += r.rssi;
        cnt2 += 1;
      }
      if(r.device.name == name_list[2]){
        sum3 += r.rssi;
        cnt3 += 1;
      }
    }
  });
}

// void avg_button(){
//
//   sum1=0;
//   sum2=0;
//   sum3=0;
//
//   device1_rssi.sort();
//
//   for(var i=1; i<device1_rssi.length-1; i++) {
//     sum1 += device1_rssi[i];
//     save_rssi1 = (sum1 / (device1_rssi.length - 2)).toString();
//   }
//   for(var i=1; i<device2_rssi.length-1; i++){
//     sum2 += device2_rssi[i];
//     save_rssi2 = (sum2/(device2_rssi.length-2)).toString();
//   }
//   for(var i=1; i<device3_rssi.length-1; i++){
//     sum3 += device3_rssi[i];
//     save_rssi3 = (sum3/(device3_rssi.length-2)).toString();
//   }
//
// }