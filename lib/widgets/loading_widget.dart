import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:utc2_student/utils/utils.dart';

Widget loadingWidget() {
  return SpinKitThreeBounce(
    size: 25,
    color: ColorApp.orange,
  );
}
