import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';


class Storage {

  String filename = 'radio_map';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$filename.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // 파일 읽기
      String contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // 에러가 발생할 경우 0을 반환
      return 0;
    }
  }

  Future<File> writeCounter(List<dynamic> s) async {
    final file = await _localFile;

    // 파일 쓰기
    return file.writeAsString('$s\n', mode: FileMode.append);
  }
}