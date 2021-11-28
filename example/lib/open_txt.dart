import 'dart:async';
import 'dart:io';
import 'package:flutter_blue_example/file_provide.dart';
import 'package:flutter_blue_example/main.dart';
import 'package:flutter/material.dart';

class readPage extends StatelessWidget{

  String contents = '';
  List name_list = [];

  readPage(this.contents, this.name_list);

  @override
  Widget build(BuildContext context) {
    Map radio_map = split_contents(contents);
    List map_list = radio_map.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("첫 페이지"),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: map_list.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Icon(Icons.align_vertical_bottom),
            title: Text(map_list[index]),
            subtitle: Text("${radio_map[map_list[index]]}"),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
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