import 'dart:async';
import 'dart:io';
import 'package:flutter_blue_example/file_provide.dart';
import 'package:flutter_blue_example/main.dart';
import 'package:flutter/material.dart';
import "dart:math";

Map mse_map = {};

class predictPage extends StatelessWidget{

  String contents = '';
  List name_list = [];
  List now_rssi = [];

  predictPage(this.contents, this.name_list, this.now_rssi);

  @override
  Widget build(BuildContext context) {
    Map radio_map = split_contents(contents);
    List map_list = radio_map.keys.toList();

    List predict_value = predict_MSE(map_list, radio_map, now_rssi);

    return Scaffold(
        appBar: AppBar(
          title: Text("현재 위치 예측"),
        ),
        body: Center(
          child : Column(
              children: [
                Text(
                  "Predict_local : ${predict_value[0].toString()}",
                  style: TextStyle(fontSize: 25, color: Colors.red),),
              ]
          )
        )
    );
  }
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

List<dynamic> predict_MSE(List name_list, Map radio_map, List now){
  double min = 999999;
  String min_loc = '';
  double mse ;
  for(var loc in name_list) {
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
  return [min_loc, min];
}