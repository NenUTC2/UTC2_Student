import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:utc2_student/models/firebase_file.dart';
import 'package:http/http.dart' as http;

class FirebaseApiGetFile {
  static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  static Future<List<FirebaseFile>> listAll(String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();

    final urls = await _getDownloadLinks(result.items);

    return urls
        .asMap()
        .map((index, url) {
          final ref = result.items[index];
          final name = ref.name;
          final file = FirebaseFile(ref: ref, name: name, url: url);

          return MapEntry(index, file);
        })
        .values
        .toList();
  }

  static Future downloadFile(
      String url, String name, BuildContext context) async {
    var status = await Permission.storage.status;
    // String url = await ref.getDownloadURL();

    Response response = await http.get(Uri.parse(url));
    if (status.isDenied) {
      await Permission.storage.request();
      final file = File('/storage/emulated/0/Download/$name');
      await file.writeAsBytes(response.bodyBytes);
    } else {
      final file = File('/storage/emulated/0/Download/$name');
      await file.writeAsBytes(response.bodyBytes);
    }
    final snackBar = SnackBar(
      content: Text('Downloaded $name'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
