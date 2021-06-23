import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:utc2_student/service/firestore/student_database.dart';
import 'package:utc2_student/utils/utils.dart';

class ProfileInfo extends StatefulWidget {
  final Student student;
  ProfileInfo({
    this.student,
  });
  @override
  _ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  File _image;
  String linkImage;
  @override
  void initState() {
    linkImage = widget.student.avatar;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
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
          'Thông tin cá nhân',
          style: TextStyle(color: ColorApp.black),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, ColorApp.lightGrey.withOpacity(.4)])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(top: 10),
                child: Center(child: _avatar(_image, size, linkImage))),
            SizedBox(
              height: 20,
            ),
            _name(widget.student.name, size),
            SizedBox(
              height: 7,
            ),
            info('Ngày sinh : ', widget.student.birthDate, size),
            SizedBox(
              height: 7,
            ),
            info('Nơi sinh : ', widget.student.birthPlace, size),
            SizedBox(
              height: 7,
            ),
            info('Mã sinh viên : ', widget.student.id, size),
            SizedBox(
              height: 7,
            ),
            info('Khóa : ', widget.student.khoa, size),
            SizedBox(
              height: 7,
            ),
            info('Lớp : ', widget.student.lop, size),
            SizedBox(
              height: 7,
            ),
            info('Hệ đào tạo : ', widget.student.heDaoTao, size),
            SizedBox(
              height: 7,
            ),
            _email(widget.student.email, size),
          ],
        ),
      ),
    );
  }
}

Widget info(String info, String day, Size size) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(info,
          style: TextStyle(
              color: ColorApp.black,
              fontSize: 15,
              fontWeight: FontWeight.normal)),
      Text(day,
          style: TextStyle(
              color: ColorApp.black,
              fontSize: 16,
              fontWeight: FontWeight.normal)),
    ],
  );
}

Widget _email(String email, Size size) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text('Email : '),
      Text(email,
          style: TextStyle(
              color: ColorApp.lightOrange,
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.normal)),
    ],
  );
}

Widget _name(String name, Size size) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text('Họ và tên : '),
      Text(name,
          style: TextStyle(
              color: ColorApp.black,
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.w600)),
    ],
  );
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
