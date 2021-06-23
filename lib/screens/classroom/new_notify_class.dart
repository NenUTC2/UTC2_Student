import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utc2_student/service/firestore/class_database.dart';
import 'package:utc2_student/service/firestore/post_database.dart';
import 'package:utc2_student/service/firestore/push_noti_firebase.dart';
import 'package:utc2_student/service/firestore/student_database.dart';
import 'package:utc2_student/service/firestore/teaacher_database.dart';
import 'package:utc2_student/utils/utils.dart';

class NewNotify extends StatefulWidget {
  final Student student;
  final Class classUtc;

  const NewNotify({Key key, this.student, this.classUtc}) : super(key: key);
  @override
  _NewNotifyState createState() => _NewNotifyState();
}

class _NewNotifyState extends State<NewNotify> {
  bool expaned = false;
  PostDatabase postDatabase = PostDatabase();
  String title, content;
  TextEditingController _controller = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        unfocus(context);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            color: ColorApp.lightGrey,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close_rounded,
              color: ColorApp.black,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Thông báo mới',
            style: TextStyle(color: ColorApp.black),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  final prefs = await SharedPreferences.getInstance();
                  String token = prefs.getString('token');
                  print(token);
                  var response = await PushNotiFireBaseAPI.pushNotiTopic(
                      title,
                      content,
                      {
                        'idNoti': 'newNoti',
                        "isAtten": false,
                        "msg": 'student post',
                        "idChannel": widget.classUtc.id,
                        "className": widget.classUtc.name,
                        "classDescription": widget.classUtc.note,
                        "timeAtten": null,
                        "idQuiz": null,
                        "token": token,
                        'name': widget.student.name,
                        'avatar': widget.student.avatar,
                        "content": "Đã đăng trong lớp: " +
                            widget.classUtc.name +
                            '\n' +
                            _controller.text.trim(),
                      },
                      widget.classUtc.id);
                  if (response.statusCode == 200) {
                    print('success');
                  } else
                    print('fail');
                  var idPost = generateRandomString(5);

                  Map<String, String> dataPost = {
                    'id': idPost,
                    'idClass': widget.classUtc.id,
                    'title': title,
                    'content': content,
                    'name': widget.student.name,
                    'avatar': widget.student.avatar,
                    'date': DateTime.now().toString(),
                    'idAtten': null,
                    'timeAtten': null,
                    "idQuiz": null,
                    "quizContent": null,
                  };
                  postDatabase.createPost(dataPost, widget.classUtc.id, idPost);

                  Navigator.pop(context);
                }
              },
              child: Text("Đăng    ",
                  style: TextStyle(
                      color: ColorApp.lightOrange,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: size.width * 0.03, horizontal: size.width * 0.03),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: size.width * 0.03,
                      horizontal: size.width * 0.03),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 35,
                        child: CircleAvatar(
                          backgroundColor: ColorApp.lightOrange.withOpacity(.1),
                          child: Icon(
                            Icons.edit,
                            color: ColorApp.lightOrange,
                            size: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 35,
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Vui lòng nhập tiêu đề';
                                }
                                return null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  title = val;
                                });
                              },
                              style: TextStyle(
                                  fontSize: 20, color: ColorApp.mediumOrange),
                              decoration: InputDecoration(
                                  // border: InputBorder.none,
                                  isCollapsed: true,
                                  hintText: 'Tiêu đề',
                                  hintStyle: TextStyle(
                                      fontSize: 16, color: ColorApp.black)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: size.width * 0.03,
                      horizontal: size.width * 0.03),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 35,
                        child: CircleAvatar(
                          backgroundColor: ColorApp.lightOrange.withOpacity(.1),
                          child: Icon(
                            Icons.note_add,
                            color: ColorApp.lightOrange,
                            size: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 35,
                          child: TextField(
                            controller: _controller,
                            onChanged: (val) {
                              setState(() {
                                content = val;
                              });
                            },
                            style: TextStyle(
                                fontSize: 20, color: ColorApp.mediumOrange),
                            decoration: InputDecoration(
                                // border: InputBorder.none,
                                isCollapsed: true,
                                hintText: 'Chia sẻ với lớp học của bạn',
                                hintStyle: TextStyle(
                                    fontSize: 16, color: ColorApp.black)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.width * 0.02,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: size.width * 0.03,
                      horizontal: size.width * 0.03),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 35,
                        child: CircleAvatar(
                          backgroundColor: ColorApp.lightOrange.withOpacity(.1),
                          child: Icon(
                            Icons.attachment,
                            color: ColorApp.lightOrange,
                            size: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Container(
                            alignment: Alignment.centerLeft,
                            height: 35,
                            child: Text('Tệp đính kèm')),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
