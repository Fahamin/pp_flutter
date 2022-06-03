import 'dart:io';

import 'package:flutter/material.dart';
import 'package:m3u/m3u.dart';
import 'package:permission_handler/permission_handler.dart';

class GetFileFromStorage extends StatelessWidget {
  GetFileFromStorage({Key? key}) : super(key: key);

  bool externalStoragePermissionOkay = false;
  late String path;

  readFile() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (status.isGranted) {
        Directory dir = Directory('/storage/emulated/0/');
        String mp3Path = dir.toString();
        print(mp3Path);
        List<FileSystemEntity> _files;
        List<FileSystemEntity> _songs = [];
        _files = dir.listSync(recursive: true, followLinks: false);
        for (FileSystemEntity entity in _files) {
          path = entity.path;
          if (path.endsWith('.m3u')) _songs.add(entity);
        }
        print(path);
        print(_songs.length);

        final source = await File(path).readAsString();
        final m3u = await M3uParser.parse(source);
        for (final entry in m3u) {
          print(entry.title);
        }

        // We didn't ask for permission yet or the permission has been denied before but not permanently.
      } else {
        Map<Permission, PermissionStatus> statuses = await [
          // Permission.c,
          Permission.storage,
        ].request();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("m3u8"),
      ),
      body: Container(
        child: ElevatedButton(
          child: Text("getFile"),
          onPressed: () {
            readFile();
          },
        ),
      ),
    );
  }
}
