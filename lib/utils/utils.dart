import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ColorApp {
  static const Color lightOrange = Color(0xFFFA8D45);
  static const Color orange = Color(0xFFFF6600);
  static const Color mediumOrange = Color(0xFFCE4302);
  static const Color grey = Color(0xFFE4BFA6);
  static const Color lightGrey = Color(0xFFE4E4E4);
  static const Color black = Color(0xFF221502);
  static const Color red = Color(0xffD94A50);
}

String generateRandomString(int len) {
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}

void unfocus(BuildContext context) {
  final FocusScopeNode currentScope = FocusScope.of(context);
  if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
    FocusManager.instance.primaryFocus.unfocus();
  }
}
bool isImage(String fileName) {
  return [
    '.jpeg',
    '.jpg',
    '.png',
    '.PNG',
    '.JPG',
    '.JPEG',
    '.heic',
    '.HEIC',
    '.tiff',
    '.TIFF',
    '.bmp',
    '.BMP',
  ].any(fileName.contains);
}
 bool isLink(String link) {
    return [
      'http://',
      'https://',
    ].any(link.contains);
  }
  String formatTime(String time) {
    DateTime parseDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(time);
    return DateFormat("HH:mm").format(parseDate);
  }