import 'dart:io';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utc2_student/repositories/google_signin_repo.dart';
import 'package:utc2_student/screens/2d_map.dart';
import 'package:utc2_student/screens/login/login_screen.dart';
import 'package:utc2_student/screens/profile_screen/attendance_screen.dart';
import 'package:utc2_student/screens/profile_screen/help_screen.dart';
import 'package:utc2_student/screens/profile_screen/schedule_table.dart';
import 'package:utc2_student/screens/profile_screen/profile_info.dart';
import 'package:utc2_student/screens/profile_screen/setting_screen.dart';
import 'package:utc2_student/screens/profile_screen/work/point_table_screen.dart';
import 'package:utc2_student/service/firestore/student_database.dart';
import 'package:utc2_student/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProFilePage extends StatefulWidget {
  final Student student;

  const ProFilePage({Key key, this.student}) : super(key: key);
  @override
  _ProFilePageState createState() => _ProFilePageState();
}

class _ProFilePageState extends State<ProFilePage> {
  GoogleSignInRepository _googleSignIn = GoogleSignInRepository();
  File _image;
  final picker = ImagePicker();
  Future getImage(bool isCamere) async {
    final pickedFile = await picker.getImage(
        source: isCamere ? ImageSource.gallery : ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  _show(
    Size size,
  ) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: new Text("Chọn ảnh",
                style: TextStyle(
                    color: Colors.black, fontSize: size.width * 0.05)),
            insetAnimationCurve: Curves.easeOutQuart,
            content: Container(
                padding: EdgeInsets.only(top: 10),
                child: new Text("Bạn vui lòng chọn ảnh !",
                    style: TextStyle(
                        color: Colors.black87, fontSize: size.width * 0.035))),
            actions: <Widget>[
              TextButton(
                child: Text('Chụp ảnh mới',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.w500,
                    )),
                onPressed: () {
                  getImage(false);
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('Chọn ảnh từ thư viện',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.w400,
                    )),
                onPressed: () {
                  getImage(true);
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  List buttonList = [
    {'title': 'Thông tin cá nhân', 'icon': Icons.person_pin},
    {'title': 'Điểm danh', 'icon': Icons.library_add_check_outlined},
    {'title': 'Xem điểm', 'icon': Icons.poll_outlined},
    {'title': 'Bản đồ 2D', 'icon': Icons.location_on},
    {'title': 'Xem thời khoá biểu', 'icon': Icons.money},
    {'title': 'Trợ giúp', 'icon': Icons.help_outline_outlined},
    {'title': 'Đánh giá ứng dụng', 'icon': Icons.star},
    {'title': 'Cài đặt', 'icon': Icons.settings},
    {'title': 'Đăng xuất', 'icon': Icons.exit_to_app},
  ];

  List screen = [
    ProfileInfo(),
    AttendanceScreen(),
    PointTableScreen(),
    Map2dScreen(),
    ScheduleTable(),
    HelpScreen(),
    ProfileInfo(), //chia sẻ link
    SettingScreen(),
    ProfileInfo(), //Đăng xuất
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
              height: size.height,
              child: Column(
                children: [
                  Flexible(
                    flex: 3,
                    child: Container(),
                  ),
                  Flexible(
                    flex: 8,
                    child: Padding(
                      padding: EdgeInsets.only(top: size.height * 0.05),
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: buttonList.length,
                            primary: true,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            width: index == 3 ? 12.0 : 0,
                                            color: index == 3
                                                ? ColorApp.lightGrey
                                                : Colors.transparent),
                                      ),
                                    ),
                                    child: Container(
                                      child: ListTile(
                                        onTap: index != buttonList.length - 1
                                            ? () {
                                                index == 0
                                                    ? Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    ProfileInfo(
                                                                      student:
                                                                          widget
                                                                              .student,
                                                                    )))
                                                    : Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                index == 1
                                                                    ? AttendanceScreen(
                                                                        student:
                                                                            widget.student,
                                                                      )
                                                                    : screen[
                                                                        index]));
                                              }
                                            : () async {
                                                ScaffoldMessenger.of(context)
                                                  ..removeCurrentSnackBar()
                                                  ..showSnackBar(
                                                    SnackBar(
                                                      content: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Text(
                                                            'Đã đăng xuất',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                      backgroundColor:
                                                          Color(0xFFFF7434),
                                                    ),
                                                  );
                                                final SharedPreferences prefs =
                                                    await SharedPreferences
                                                            .getInstance()
                                                        .then((value) {
                                                  ScaffoldMessenger.of(context)
                                                      .removeCurrentSnackBar();
                                                  return value;
                                                });
                                                prefs.remove('userEmail');
                                                _googleSignIn.signOut();
                                                Get.offAll(() => LoginScreen());
                                              },
                                        leading: Icon(
                                          buttonList[index]['icon'],
                                          color: ColorApp.black,
                                        ),
                                        title: Text(
                                          buttonList[index]['title'],
                                          style: TextStyle(
                                              color: ColorApp.black,
                                              fontSize: 16),
                                        ),
                                        trailing: index == buttonList.length - 1
                                            ? null
                                            : Icon(
                                                Icons.arrow_forward_ios,
                                                size: size.width * 0.04,
                                              ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: size.width * 0.15),
                                    child: index == buttonList.length - 1
                                        ? null
                                        : Divider(
                                            height: 1,
                                            thickness: 0.2,
                                            color: index == 3
                                                ? Colors.transparent
                                                : Colors.black54,
                                          ),
                                  ),
                                ],
                              );
                            }),
                      ),
                    ),
                  ),
                ],
              )),
          Stack(
            children: [
              Container(
                color: Colors.transparent,
                margin: EdgeInsets.only(top: 10),
                height: size.height * 0.32,
                width: size.width,
                child: CustomPaint(
                  painter: CurvePainter1(),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: size.height * 0.32,
                width: size.width,
                child: CustomPaint(
                  painter: CurvePainter(),
                ),
              ),
            ],
          ),
          SafeArea(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    _show(size);
                  },
                  child: Container(
                      child: Center(
                          child: _avatar(_image, size, widget.student.avatar))),
                ),
                SizedBox(
                  height: 15,
                ),
                _name(widget.student.name, size),
                _email(widget.student.email, size),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.9);
    path.quadraticBezierTo(
        size.width / 2, size.height * 0.98, size.width, size.height * 0.9);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CurvePainter1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = ColorApp.lightGrey;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.86);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height * 0.86);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

Widget _email(String email, Size size) {
  return Text(email,
      style: TextStyle(
          color: ColorApp.lightOrange,
          fontSize: size.width * 0.05,
          fontWeight: FontWeight.normal));
}

Widget _name(String name, Size size) {
  return Text(name,
      style: TextStyle(
          color: ColorApp.black,
          fontSize: size.width * 0.05,
          fontWeight: FontWeight.w600));
}

Widget _avatar(File path, Size size, String imageLink) {
  return Stack(
    alignment: Alignment.center,
    children: [
      Container(
        width: size.width * 0.26,
        height: size.width * 0.26,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                width: 1, color: Colors.green, style: BorderStyle.solid),
          ),
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
          image: (imageLink != null)
              ? DecorationImage(
                  image: NetworkImage(
                    imageLink,
                  ),
                  fit: BoxFit.cover,
                )
              : (path == null)
                  ? DecorationImage(
                      image: AssetImage('assets/images/gv.jpg'),
                      fit: BoxFit.cover)
                  : DecorationImage(
                      image: Image.file(path).image, fit: BoxFit.cover),
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: GestureDetector(
          onTap: () {},
          child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(
                Icons.add_a_photo,
                color: Colors.grey,
                size: 16,
              )),
        ),
      )
    ],
  );
}
