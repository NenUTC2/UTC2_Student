import 'dart:math';

import 'package:flutter/material.dart';

class ColorApp {
  static const Color lightOrange = Color(0xFFFF9046);
  static const Color orange = Color(0xFFFE6804);
  static const Color mediumOrange = Color(0xFFCE5402);
  static const Color grey = Color(0xFFE4BFA6);
  static const Color lightGrey = Color(0xFFD8B39A);
  static const Color black = Color(0xFF221502);
  static const Color red = Color(0xffD94A50);
}

String generateRandomString(int len) {
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}
