import 'dart:async';
import 'dart:io';
import 'package:flutter_blue_example/file_provide.dart';
import 'package:flutter_blue_example/main.dart';
import 'package:flutter/material.dart';

class readPage extends StatelessWidget{

  String contents = '';

  readPage(this.contents);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("첫 페이지"),
      ),
      body: Center(
        child: Column(
          children:[
            Text(contents),
          ]
        )
      ),
    );
  }
}