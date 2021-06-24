import 'package:flutter/material.dart';
import 'package:utc2_student/utils/utils.dart';

class ScheduleTable extends StatefulWidget {
  @override
  _ScheduleTableState createState() => _ScheduleTableState();
}

class _ScheduleTableState extends State<ScheduleTable> {
  Widget textHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget headerTable() {
    return Container(
      color: ColorApp.lightOrange,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(flex: 3, child: textHeader('Buổi')),
          Expanded(flex: 3, child: textHeader('Thứ 2')),
          Expanded(flex: 3, child: textHeader('Thứ 3')),
          Expanded(flex: 3, child: textHeader('Thứ 4')),
          Expanded(flex: 3, child: textHeader('Thứ 5')),
          Expanded(flex: 3, child: textHeader('Thứ 6')),
          Expanded(flex: 3, child: textHeader('Thứ 7')),
        ],
      ),
    );
  }

  Widget textRow(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget rowTable(String buoi) {
    return Container(
      color: ColorApp.lightOrange.withOpacity(.2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(flex: 3, child: textRow(buoi)),
          Expanded(flex: 3, child: textRow('Thứ 2')),
          Expanded(flex: 3, child: textRow('Thứ 3')),
          Expanded(flex: 3, child: textRow('Thứ 4')),
          Expanded(flex: 3, child: textRow('Thứ 5')),
          Expanded(flex: 3, child: textRow('Thứ 6')),
          Expanded(flex: 3, child: textRow('Thứ 7')),
        ],
      ),
    );
  }

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
          'Thời khóa biểu',
          style: TextStyle(color: ColorApp.black),
        ),
      ),
      body: Container(
        height: size.height / 2,
        child: ListView.builder(
            itemCount: 1,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container(
                  height: size.height,
                  width: size.width * 2,
                  child: Column(children: [
                    headerTable(),
                    SizedBox(
                      height: 5,
                    ),
                    rowTable('Sáng'),
                    Divider(),
                    rowTable('Chiều'),
                    Divider(),
                    rowTable('Tối')
                  ]));
            }),
      ),
    );
  }
}
