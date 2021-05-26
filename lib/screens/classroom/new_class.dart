import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:utc2_student/service/pdf/pdf_api.dart';
import 'package:utc2_student/service/pdf/pdf_class_detail.dart';
import 'package:utc2_student/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
// import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;

class NewClass extends StatefulWidget {
  @override
  _NewClassState createState() => _NewClassState();
}

class _NewClassState extends State<NewClass> {
  List user = [
    {
      'avatar':
          'https://images.pexels.com/photos/1987042/pexels-photo-1987042.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
      'title': '5851071033@st.utc2.edu.vn',
      'isComplete': false
    },
    {
      'avatar':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/4/40/A-small_glyphs.svg/227px-A-small_glyphs.svg.png',
      'title': '5851071033@st.utc2.edu.vn',
      'isComplete': false
    },
    {
      'avatar':
          'https://images.pexels.com/photos/1987042/pexels-photo-1987042.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
      'title': '5851071033@st.utc2.edu.vn',
      'isComplete': true
    },
    {
      'avatar':
          'https://images.pexels.com/photos/1987042/pexels-photo-1987042.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
      'title': '5851071033@st.utc2.edu.vn',
      'isComplete': false
    },
    {
      'avatar':
          'https://images.pexels.com/photos/1987042/pexels-photo-1987042.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
      'title': '5851071033@st.utc2.edu.vn',
      'isComplete': false
    },
    {
      'avatar':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/4/40/A-small_glyphs.svg/227px-A-small_glyphs.svg.png',
      'title': '5851071033@st.utc2.edu.vn',
      'isComplete': false
    },
  ];
  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  GlobalKey globalKey = new GlobalKey();
  // String _dataString = "AziTask.com";

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage();
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      ImageGallerySaver.saveImage(pngBytes,
          name: DateTime.now().toString(), quality: 100);
      Fluttertoast.showToast(
          msg: "Đã lưu vào thư viện",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: ColorApp.mediumBlue,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _shareImage() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage();
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      // await Share.file('Chia sẻ mã QR', 'qr.png', pngBytes, 'image/png',
      //     text: 'QR của tôi.');
    } catch (e) {
      print('error: $e');
    }
  }

  String idClass;
  bool isNewClass = false;
  bool isAll = false;
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
          'Lớp học mới',
          style: TextStyle(color: ColorApp.black),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        child: Container(
          margin:
              EdgeInsets.symmetric(horizontal: size.width * 0.2, vertical: 10),
          child: Text("Tạo mới",
              style: TextStyle(
                  fontSize: size.width * 0.045,
                  letterSpacing: 1,
                  wordSpacing: 1,
                  fontWeight: FontWeight.normal)),
        ),
        style: ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.padded,
            shadowColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: Colors.red)))),
        onPressed: () async {
          // final pdfFile = await PdfParagraphApi.generate();
          // PdfApi.openFile(pdfFile);
          final response =
              await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Authorization':
                        'key=AAAAYogee34:APA91bFuj23NLRj88uqP9J-aRCehCgVSo8QgUOIPZy8CzBE-Xbubx58trUepsb2SABoIGsPYbONqa2jjS03l1fW5r2aQywmKkYN6L3RXHIML6795xTHyamls_ZwLSt-_n3AJ8av82CiW',
                  },
                  body: jsonEncode({
                    "to": "/topics/fcm_test",
                    "data": {"msg": "Hello"},
                    "notification": {"title": "fcm", "body": "body"}
                  }));
          if (response.statusCode == 200)
            print('success');
          else
            print('faile');
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: size.width * 0.03, horizontal: size.width * 0.03),
              // child:
              child: Column(
                children: [
                  Container(
                    width: size.width,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: ColorApp.blue.withOpacity(0.05),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.03,
                        vertical: size.width * 0.03),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 35,
                              child: CircleAvatar(
                                backgroundColor: Colors.blue.withOpacity(.1),
                                child: Icon(
                                  Icons.desktop_mac_rounded,
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
                                  child: Text(
                                    'Thông tin lớp học',
                                    style: TextStyle(
                                        color: ColorApp.black, fontSize: 18),
                                  )),
                            ),
                          ],
                        ),
                        TextField(
                          onChanged: (value) {
                            if (value.length > 0) {
                              setState(() {
                                idClass = generateRandomString(5);
                                isNewClass = true;
                              });
                            } else {
                              setState(() {
                                idClass = value;
                                isNewClass = false;
                              });
                            }
                          },
                          style: TextStyle(
                              fontSize: 20, color: ColorApp.mediumBlue),
                          decoration: InputDecoration(
                              // border: InputBorder.none,
                              labelText: 'Tên lớp..',
                              labelStyle: TextStyle(
                                  fontSize: 18, color: ColorApp.black)),
                        ),
                        Container(
                          child: isNewClass
                              ? Container(
                                  width: size.width,
                                  margin: EdgeInsets.only(top: 15),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text('Mã lớp :'),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            idClass,
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 20,
                                                letterSpacing: 1,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Clipboard.setData(
                                                  ClipboardData(text: idClass));
                                              Fluttertoast.showToast(
                                                  msg: "Đã sao chép " + idClass,
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor:
                                                      ColorApp.mediumBlue,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            },
                                            child: Icon(
                                              Icons.copy_rounded,
                                              size: 15,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Mã QR :'),
                                          RepaintBoundary(
                                            key: globalKey,
                                            child: Container(
                                              color: Colors.white,
                                              child: QrImage(
                                                data: idClass,
                                                embeddedImage: AssetImage(
                                                    'assets/images/logoUTC.png'),
                                                version: QrVersions.auto,
                                                size: 120,
                                                gapless: false,
                                                embeddedImageStyle:
                                                    QrEmbeddedImageStyle(
                                                  size: Size(15, 15),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 16.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                _captureAndSharePng();
                                              },
                                              child: Text(
                                                'Lưu vào thư viện',
                                                style: TextStyle(
                                                    color: ColorApp.blue),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _shareImage();
                                            },
                                            child: Text(
                                              'Chia sẻ',
                                              style: TextStyle(
                                                  color: ColorApp.blue),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.width * 0.03,
                  ),
                  Container(
                    width: size.width,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: ColorApp.blue.withOpacity(0.05),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.03,
                        vertical: size.width * 0.03),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                          child: TextField(
                            style: TextStyle(
                                fontSize: 20, color: ColorApp.mediumBlue),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Mô tả..',
                                labelStyle: TextStyle(
                                    fontSize: 18, color: ColorApp.black)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.width * 0.03,
                  ),
                  Container(
                    width: size.width,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: ColorApp.blue.withOpacity(0.05),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.03,
                        vertical: size.width * 0.03),
                    child: Column(
                      children: [
                        Container(
                          width: size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(bottom: BorderSide(width: .5))),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 35,
                                child: CircleAvatar(
                                  backgroundColor: Colors.blue.withOpacity(.1),
                                  child: Icon(
                                    Icons.group_add,
                                    color: Colors.blue,
                                    size: 16,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text('Thêm',
                                  style: TextStyle(
                                      fontSize: 18, color: ColorApp.black)),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text('Tất cả (' +
                                          user.length.toString() +
                                          ")"),
                                      // Transform.scale(
                                      //   scale: 0.8,
                                      //   child: CircularCheckBox(
                                      //     value: isAll,
                                      //     activeColor: ColorApp.mediumBlue,
                                      //     checkColor: ColorApp.lightGrey,
                                      //     onChanged: (value) {
                                      //       setState(() {
                                      //         for (int i = 0;
                                      //             i < user.length;
                                      //             i++) {
                                      //           user[i]['isComplete'] = value;
                                      //         }
                                      //         isAll = value;
                                      //       });
                                      //     },
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: size.height * 0.4,
                          decoration: BoxDecoration(color: Colors.white),
                          child: ListView.builder(
                            itemCount: user.length,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(),
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 35,
                                          decoration: BoxDecoration(
                                              color: ColorApp.lightGrey,
                                              shape: BoxShape.circle),
                                          padding: EdgeInsets.all(2),
                                          child: CircleAvatar(
                                            radius: 20.0,
                                            backgroundImage: NetworkImage(
                                                user[index]['avatar']),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          user[index]['title'],
                                          style: TextStyle(
                                              color: ColorApp.black
                                                  .withOpacity(.8),
                                              fontSize: 16,
                                              wordSpacing: 1.2,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.2),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Transform.scale(
                                        //   scale: 0.7,
                                        //   child: CircularCheckBox(
                                        //     value: user[index]['isComplete'],
                                        //     activeColor: ColorApp.mediumBlue,
                                        //     checkColor: ColorApp.lightGrey,
                                        //     onChanged: (value) {
                                        //       setState(() {
                                        //         setState(() {
                                        //           user[index]['isComplete'] =
                                        //               value;
                                        //         });
                                        //       });
                                        //     },
                                        //   ),
                                        // ),
                                        Text(
                                          (index + 1).toString(),
                                          style: TextStyle(
                                              fontSize: 9,
                                              color: user[index]['isComplete']
                                                  ? Colors.transparent
                                                  : ColorApp.blue),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
