import 'package:utc2_student/screens/profile_screen/work/chart.dart';
import 'package:utc2_student/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';

class TaskPerformanceScreen extends StatefulWidget {
  @override
  _TaskPerformanceScreenState createState() => _TaskPerformanceScreenState();
}

class _TaskPerformanceScreenState extends State<TaskPerformanceScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: ColorApp.black,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Khối lượng công việc',
            style: TextStyle(color: ColorApp.black),
          ),
        ),
        body: Container(
          child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  PieChartSample3(),
                  Container(
                    padding: EdgeInsets.all(size.width * 0.03),
                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                    width: size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: ColorApp.orange.withOpacity(0.05),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset(0, 1), // changes position of shadow
                          )
                        ]),
                    child: Text('Công việc của bạn thế nào ?'),
                  )
                ],
              )),
        ));
  }
}
