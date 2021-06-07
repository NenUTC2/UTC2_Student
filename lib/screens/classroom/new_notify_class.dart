import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utc2_student/service/firestore/post_database.dart';
import 'package:utc2_student/service/firestore/student_database.dart';
import 'package:utc2_student/utils/utils.dart';

class NewNotify extends StatefulWidget {
  final String idClass;
  final Student student;

  const NewNotify({Key key, this.idClass, this.student}) : super(key: key);
  @override
  _NewNotifyState createState() => _NewNotifyState();
}

class _NewNotifyState extends State<NewNotify> {
  bool expaned = false;
  PostDatabase postDatabase = PostDatabase();
  String title, content;
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
                final response = await http.post(
                    Uri.parse('https://fcm.googleapis.com/fcm/send'),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                      'Authorization':
                          'key=AAAAYogee34:APA91bFuj23NLRj88uqP9J-aRCehCgVSo8QgUOIPZy8CzBE-Xbubx58trUepsb2SABoIGsPYbONqa2jjS03l1fW5r2aQywmKkYN6L3RXHIML6795xTHyamls_ZwLSt-_n3AJ8av82CiW',
                    },
                    body: jsonEncode({
                      "to": "/topics/fcm_test",
                      "data": {"msg": "Hello"},
                      "notification": {
                        "title": title,
                        "body": content,
                      }
                    }));
                if (response.statusCode == 200) {
                  print('success');
                  Navigator.pop(context);
                } else
                  print('faile');
                var idPost = generateRandomString(5);

                Map<String, String> dataPost = {
                  'id': idPost,
                  'idClass': widget.idClass,
                  'title': title,
                  'content': content,
                  'date':
                     DateTime.now().toString(),
                  'name': widget.student.name,
                  'avatar': widget.student.avatar,
                };
                postDatabase.createPost(dataPost, widget.idClass, idPost);
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
                          child: TextField(
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
