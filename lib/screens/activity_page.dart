import 'dart:math';
import 'package:utc2_student/screens/classroom/class_detail_screen.dart';
import 'package:utc2_student/screens/classroom/new_class.dart';
import 'package:utc2_student/utils/color_random.dart';
import 'package:utc2_student/utils/utils.dart';
import 'package:flutter/material.dart';

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  List activity = [
    {
      'title': 'Đồ án tốt nghiệp',
      'name': 'Phan Thành Nên',
      'subAct': ['Báo Cáo tiến độ']
    },
    {
      'title': 'AI.GTVT.2.20-21',
      'name': 'Nguyễn Đình Hiển',
      'subAct': [
        'BT1 (Nhóm) : Tìm hiểu về AI',
        'BT2 (Nhóm) : Thuật Giải Heuristic',
        'BT3 (Nhóm) : Phương pháp tìm kiếm'
      ]
    },
    {
      'title': 'Phân tích thiết kế hướng đối tượng (k58-utc2)',
      'name': 'Nguyễn Quang Phúc',
      'subAct': []
    },
    {'title': 'data minning 20-21', 'name': 'Trần Phong Nhã', 'subAct': []},
  ];

  showAlertDialog(BuildContext context, String name) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Thoát"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Rời khỏi"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(name),
      content: Text("Bạn có muốn rời khỏi lớp học này ?"),
      actions: [
        continueButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showBottomSheet(BuildContext context, Size size, String title) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          color: Color.fromRGBO(0, 0, 0, 0.001),
          child: DraggableScrollableSheet(
            initialChildSize: 0.75,
            minChildSize: 0.2,
            maxChildSize: 0.85,
            builder: (_, controller) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0),
                  ),
                ),
                child: Column(
                  children: [
                    Center(
                        child: Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: ColorApp.grey,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(3),
                          topRight: const Radius.circular(3),
                        ),
                      ),
                      height: 3,
                      width: 50,
                    )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: Text(
                          title,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 0.5,
                      height: 5,
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: controller,
                        itemCount: 1,
                        itemBuilder: (_, index) {
                          return NewClass();
                        },
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: size.width * 0.2, vertical: 10),
                            child: Text("Tạo mới",
                                style: TextStyle(
                                    fontSize: size.width * 0.045,
                                    letterSpacing: 1,
                                    wordSpacing: 1,
                                    fontWeight: FontWeight.normal)),
                          ),
                          style: ButtonStyle(
                              tapTargetSize: MaterialTapTargetSize.padded,
                              shadowColor: MaterialStateProperty.all<Color>(
                                  Colors.lightBlue),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.blue),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(color: Colors.red)))),
                          onPressed: () {}),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: activity.length,
            itemBuilder: (context, index) {
              return customList(size, context, activity[index]['title'],
                  activity[index]['name'], activity[index]['subAct']);
            },
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            splashColor: ColorApp.blue.withOpacity(.4),
            hoverColor: ColorApp.lightGrey,
            foregroundColor: ColorApp.blue,
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => NewClass()));
            },
            child: Icon(Icons.add),
          ),
        )
      ],
    );
  }

  Widget customList(Size size, BuildContext context, String className,
      String teacherName, List sub) {
    return Container(
      margin: EdgeInsets.all(size.width * 0.03),
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          border: Border.all(color: ColorApp.lightGrey, width: 1.5)),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailClassScreen(
                            className: className,
                            listClass: activity,
                          )));
            },
            child: Container(
              height: 150,
              width: size.width,
              padding: EdgeInsets.all(size.width * 0.03),
              decoration: BoxDecoration(
                gradient: new LinearGradient(
                    colors: ColorRandom
                        .colors[Random().nextInt(ColorRandom.colors.length)],
                    stops: [0.0, 1.0],
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomRight,
                    tileMode: TileMode.repeated),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          className.toUpperCase(),
                          softWrap: true,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            showAlertDialog(context, className.toUpperCase());
                          },
                          icon: Icon(
                            Icons.more_horiz_rounded,
                            color: Colors.white,
                          )),
                    ],
                  ),
                  Text(
                    teacherName,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          sub.isNotEmpty
              ? Container(
                  width: size.width,
                  padding: EdgeInsets.all(size.width * 0.03),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.05),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      border: Border.all(color: ColorApp.lightGrey, width: 1)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(sub.length, (index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(sub[index].toString()),
                          index == sub.length - 1
                              ? Container()
                              : Divider(
                                  color: ColorApp.black,
                                )
                        ],
                      );
                    }),
                  ))
              : Container(),
        ],
      ),
    );
  }
}
