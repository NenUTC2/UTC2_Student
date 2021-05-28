import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:utc2_student/service/firestore/post_database.dart';
import 'package:utc2_student/service/pdf/pdf_api.dart';
import 'package:utc2_student/service/pdf/pdf_class_detail.dart';
import 'package:utc2_student/utils/utils.dart';

class NewNotify extends StatefulWidget {
  final String idClass;

  const NewNotify({Key key, this.idClass}) : super(key: key);
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
    return Scaffold(
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
                'date': DateTime.now().toString(),
              };
              postDatabase.createPost(dataPost, widget.idClass, idPost);
            },
            child: Text("Đăng    ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                    vertical: size.width * 0.03, horizontal: size.width * 0.03),
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
                        backgroundColor: Colors.blue.withOpacity(.1),
                        child: Icon(
                          Icons.edit,
                          color: Colors.blue,
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
                              fontSize: 20, color: ColorApp.mediumBlue),
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
                    vertical: size.width * 0.03, horizontal: size.width * 0.03),
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
                        backgroundColor: Colors.blue.withOpacity(.1),
                        child: Icon(
                          Icons.note_add,
                          color: Colors.blue,
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
                              fontSize: 20, color: ColorApp.mediumBlue),
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
                    vertical: size.width * 0.03, horizontal: size.width * 0.03),
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
                        backgroundColor: Colors.blue.withOpacity(.1),
                        child: Icon(
                          Icons.attachment,
                          color: Colors.blue,
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
              SizedBox(
                height: size.width * 0.02,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: size.width * 0.03, horizontal: size.width * 0.03),
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
                        backgroundColor: Colors.blue.withOpacity(.1),
                        child: Icon(
                          Icons.dns_rounded,
                          color: Colors.blue,
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
                          child: Text('Bài tập trắc nghiệm')),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            expaned ? expaned = false : expaned = true;
                          });
                        },
                        icon: Icon(
                          expaned
                              ? Icons.remove_circle
                              : Icons.add_circle_rounded,
                          color: ColorApp.mediumBlue,
                        ))
                  ],
                ),
              ),
              AnimatedCrossFade(
                firstChild: Container(
                  height: 500,
                  padding: EdgeInsets.symmetric(
                      vertical: size.width * 0.03,
                      horizontal: size.width * 0.03),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextFormField(
                          validator: (val) =>
                              val.isEmpty ? 'Nhập câu hỏi' : null,
                          onChanged: (value) {},
                          style: TextStyle(
                              fontSize: 20, color: ColorApp.mediumBlue),
                          decoration: InputDecoration(
                              // border: InputBorder.none,
                              isCollapsed: true,
                              hintText: 'Câu hỏi 1',
                              hintStyle: TextStyle(
                                  fontSize: 16, color: ColorApp.black)),
                        ),
                        TextFormField(
                          validator: (val) =>
                              val.isEmpty ? 'Nhập câu trả lời đúng' : null,
                          onChanged: (value) {},
                          style: TextStyle(
                              fontSize: 20, color: ColorApp.mediumBlue),
                          decoration: InputDecoration(
                              // border: InputBorder.none,
                              isCollapsed: true,
                              hintText: 'A --> Đán áp đúng',
                              hintStyle: TextStyle(
                                  fontSize: 16, color: ColorApp.black)),
                        ),
                        TextFormField(
                          validator: (val) => val.isEmpty
                              ? 'Nhập ít nhất 1 câu trả lời sai'
                              : null,
                          onChanged: (value) {},
                          style: TextStyle(
                              fontSize: 20, color: ColorApp.mediumBlue),
                          decoration: InputDecoration(
                              // border: InputBorder.none,
                              isCollapsed: true,
                              hintText: 'B',
                              hintStyle: TextStyle(
                                  fontSize: 16, color: ColorApp.black)),
                        ),
                        TextFormField(
                          onChanged: (value) {},
                          style: TextStyle(
                              fontSize: 20, color: ColorApp.mediumBlue),
                          decoration: InputDecoration(
                              // border: InputBorder.none,
                              isCollapsed: true,
                              hintText: 'C',
                              hintStyle: TextStyle(
                                  fontSize: 16, color: ColorApp.black)),
                        ),
                        TextFormField(
                          onChanged: (value) {},
                          style: TextStyle(
                              fontSize: 20, color: ColorApp.mediumBlue),
                          decoration: InputDecoration(
                              // border: InputBorder.none,
                              isCollapsed: true,
                              hintText: 'D',
                              hintStyle: TextStyle(
                                  fontSize: 16, color: ColorApp.black)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  child: Text("Hoàn thành",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal)),
                                ),
                                style: ButtonStyle(
                                    tapTargetSize: MaterialTapTargetSize.padded,
                                    shadowColor: MaterialStateProperty.all<Color>(
                                        Colors.lightBlue),
                                    foregroundColor: MaterialStateProperty.all<Color>(
                                        Colors.white),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            ColorApp.mediumBlue),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: BorderSide(
                                                color: Colors.transparent)))),
                                onPressed: () async {
                                  final pdfFile =
                                      await PdfParagraphApi.generate();
                                  PdfApi.openFile(pdfFile);
                                }),
                            ElevatedButton(
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  child: Text("Tiếp tục",
                                      style: TextStyle(
                                          fontSize: 18,
                                          // letterSpacing: 1,
                                          // wordSpacing: 1,
                                          fontWeight: FontWeight.normal)),
                                ),
                                style: ButtonStyle(
                                    tapTargetSize: MaterialTapTargetSize.padded,
                                    shadowColor: MaterialStateProperty.all<Color>(
                                        Colors.lightBlue),
                                    foregroundColor: MaterialStateProperty.all<Color>(
                                        Colors.white),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            ColorApp.mediumBlue),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: BorderSide(
                                                color: Colors.transparent)))),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    print('validated');
                                  }
                                }),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                secondChild: Container(),
                crossFadeState: expaned
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: Duration(milliseconds: 300),
              )
            ],
          ),
        ),
      ),
    );
  }
}
