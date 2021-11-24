import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';


class Storage {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/radio_map.txt');
  }

  Future<void> readText()async{
    File file = await _localFile;
    String text = await file.readAsString();
    print(text);
  }


  Future<String> readFile() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      // 에러가 발생할 경우 0을 반환
      return e.toString();
    }
  }

  Future<File> writeFile(String s) async {
    final file = await _localFile;
    print(file);
    return file.writeAsString('$s\n', mode: FileMode.append);
  }
}