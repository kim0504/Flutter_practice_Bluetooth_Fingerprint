// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_blue_example/file_provide.dart';
import 'package:flutter_blue_example/widgets.dart';


final List<String> name_list = ['[TV] Samsung Q90 Series (65)','Buds+', 'tony의 S21']; //이거 우리 집에 있는 tv랑, 내 버즈랑, 핸드폰으로 측정할 거 리스트로 만듬
List<dynamic> scan_list = []; //블루투스 스캔할 때 한 번에 5~7개씩 값이 들어와서 중복 막으려고 만든 리스트
List<dynamic> device_list = []; //블루투스로 받은 기기 정보 볼려고 만든 리스트

List<dynamic> device1_rssi = []; //티비 rssi값
List<dynamic> device2_rssi = []; //버즈 rssi값
List<dynamic> device3_rssi = []; //핸드폰 rssi값

String inputs = ""; // 측정 공간 이름 -> 나중에 어디서 측정했는지 DB에 넣을려고 만듬

// rssi 평균 값 계산하려고 일단 만들어 놓음
num sum1=0, sum2=0, sum3=0;
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

          primarySwatch: Colors.green,
        ),      home: ContainerWidget()
    );
  }
}

class ContainerWidget extends StatelessWidget {

  late final Storage storage = Storage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Flutter example')
        ),
        body: Center(
          child: Column(
            children: [
              RaisedButton(
                child: Text('Scan'),
                onPressed: (){
                  blue_scan(); // 블루투스 스캔 기능
                },

                color: Colors.lightGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                ),
              ),


              RaisedButton(
                child: Text('Info'),
                onPressed: (){
                  print('=================================================================');
                  print(device_list);
                  print('=================================================================');
                  print(scan_list);
                  print('=================================================================');
                },
                color: Colors.lightGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                ),
              ),


              Container(
                child: TextField(
                  style: TextStyle(fontSize: 32, color: Colors.red),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(hintText: '입력해 주세요'),
                  onChanged: (String str) {
                    inputs = str;
                  },
                ),
                padding: EdgeInsets.only(top: 10, bottom: 10),
                width: 300,
              ),


              RaisedButton(
                child: Text('Save RSSI'),
                onPressed: (){
                  avg_button(); // 파일에 저장할 rssi 평균 값 만들 함수
                  print("${inputs}\n${name_list[0].toString()}:${(sum1/(device1_rssi.length-2)).toString()}");
                  storage.writeFile("${inputs}\n${name_list[0].toString()}:${(sum1/(device1_rssi.length-2)).toString()}");
                },
                color: Colors.lightGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                ),
              ),


              RaisedButton(
                child: Text('print File'),
                onPressed: (){
                  storage.readText();
                },
                color: Colors.lightGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                ),
              ),


            ] // children
          )
        )
    );
  }
}


void blue_scan() {

  Map<String, dynamic> rssi_map = {};

  //초기화
  scan_list = [];
  device_list = [];

  FlutterBlue flutterBlue = FlutterBlue.instance;
  flutterBlue.startScan(timeout: Duration(seconds: 4));

  Future.delayed(const Duration(milliseconds: 4000), () {
    var subscription = flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        if(name_list.contains(r.device.name)){
          if(!(scan_list.contains(r.device.name))){
            device_list.add(r);
            scan_list.add(r.device.name);
            rssi_map.update(r.device.name, (value)=>r.rssi, ifAbsent: ()=> r.rssi);
            print(rssi_map);
            device1_rssi.add(rssi_map[name_list[0]]);
            device2_rssi.add(rssi_map[name_list[1]]);
            device3_rssi.add(rssi_map[name_list[2]]);
          }
        }
      }
    });
  });// Listen to scan results
}

void avg_button(){

  sum1=0;
  sum2=0;
  sum3=0;

  device1_rssi.sort();

  for(var i=1; i<device1_rssi.length-1; i++){
    sum1 += device1_rssi[i];
    save_rssi1 = (sum1/(device1_rssi.length-2)).toString();
  }
  // for(int i in device2_rssi){
  //   sum2 += i;
  // }
  // for(int i in device3_rssi){
  //   sum3 += i;
  // }
  print('=====================================================================');
  print('device1_rssi list : ${device1_rssi},,, sum = ${sum1},,, avg = ${sum1/(device1_rssi.length-2)}');
  // print('device1_rssi list : ${device2_rssi},,, sum = ${sum2}\n');
  // print('device1_rssi list : ${device3_rssi},,, sum = ${sum3}\n');
  print('=====================================================================');
}