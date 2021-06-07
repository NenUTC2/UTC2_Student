import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:utc2_student/blocs/post_bloc/post_bloc.dart';
import 'package:utc2_student/blocs/student_bloc/student_bloc.dart';
import 'package:utc2_student/screens/classroom/new_notify_class.dart';
import 'package:utc2_student/screens/home_screen.dart';
import 'package:utc2_student/service/firestore/class_database.dart';
import 'package:utc2_student/service/firestore/teaacher_database.dart';
import 'package:utc2_student/service/local_notification.dart';
import 'package:utc2_student/utils/custom_glow.dart';
import 'package:utc2_student/utils/utils.dart';
import 'package:utc2_student/widgets/class_drawer.dart';
import 'package:flutter/material.dart';

import 'package:utc2_student/utils/color_random.dart';

class DetailClassScreen extends StatefulWidget {
  final String className, idClass;
  final List listClass;
  DetailClassScreen({this.className, this.listClass, this.idClass});
  @override
  _DetailClassScreenState createState() => _DetailClassScreenState();
}

class _DetailClassScreenState extends State<DetailClassScreen> {
  final notifications = FlutterLocalNotificationsPlugin();
  PostBloc postBloc;
  StudentBloc studentBloc;
  Class _class;
  Teacher teacher;
  @override
  void initState() {
    super.initState();
    sendNoti();
    _class = widget.listClass
        .where((element) => element.id.contains(widget.idClass))
        .toList()
        .first;
    if (_class != null) getTeacher();

    final settingsAndroid = AndroidInitializationSettings('app_icon');

    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(android: settingsAndroid, iOS: settingsIOS),
        onSelectNotification: onSelectNotification);
    postBloc = BlocProvider.of<PostBloc>(context);
    studentBloc = BlocProvider.of<StudentBloc>(context);
    postBloc.add(GetPostEvent(widget.idClass));
    studentBloc.add(GetStudent());
  }

  getTeacher() async {
    teacher = await TeacherDatabase.getTeacherData(_class.teacherId);
  }

  void sendNoti() async {
    MyLocalNotification.configureLocalTimeZone();
    // await MyLocalNotification.scheduleWeeklyMondayTenAMNotification(
    //   notifications, 14, 46);
    // await MyLocalNotification.scheduleWeeklyMondayTenAMNotification(
    //     notifications, 11, 48);
  }

  Future onSelectNotification(String payload) async =>
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => // Ensure Scaffold is in context
              IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: ColorApp.black,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer()),
        ),
        actions: [
          Builder(
            builder: (context) => Container(
              margin: EdgeInsets.only(right: size.width * 0.03),
              width: 40,
              child: IconButton(
                  onPressed: () => _showBottomSheet(context, size,
                      _class.name.toUpperCase(), _class.note, teacher),
                  icon: Icon(
                    Icons.info,
                    color: Colors.grey,
                  )),
            ),
          )
        ],
      ),
      drawer: ClassDrawer(
        active: widget.listClass,
        change: (id) {
          postBloc.add(GetPostEvent(id));
          setState(() {
            _class = widget.listClass
                .where((element) => element.id.contains(id))
                .toList()
                .first;
            getTeacher();
          });
        },
      ),
      body: Container(
        width: size.width,
        height: size.height,
        color: Colors.white,
        padding: EdgeInsets.all(size.width * 0.03),
        child: Column(
          children: [
            Flexible(flex: 3, child: title(size, _class.name.toUpperCase())),
            SizedBox(
              height: 7,
            ),
            Flexible(
                flex: 2,
                child: comment(
                  size,
                )),
            Flexible(
              flex: 15,
              child: BlocBuilder<PostBloc, PostState>(
                builder: (context, state) {
                  if (state is LoadedPost) {
                    return Container(
                      // padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: ColorApp.orange.withOpacity(0.02),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset:
                                  Offset(1, 1), // changes position of shadow
                            ),
                          ],
                          // color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: ColorApp.lightGrey)),
                      margin: EdgeInsets.only(top: 10),
                      child: RefreshIndicator(
                        onRefresh: () async {
                          postBloc.add(GetPostEvent(widget.idClass));
                        },
                        child: Scrollbar(
                          child: ListView.builder(
                              itemCount: state.list.length,
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.03),
                              itemBuilder: (context, index) {
                                var e = state.list[index];
                                DateTime parseDate =
                                    new DateFormat("yyyy-MM-dd HH:mm:ss")
                                        .parse(e.date);
                                return ItemNoti(
                                  avatar: e.avatar,
                                  userName: e.name,
                                  title: e.title,
                                  time: DateFormat('HH:mm - dd-MM-yyyy')
                                      .format(parseDate),
                                  content: e.content != null ? e.content : '',
                                  numberFile: index,
                                  idAttendend: e.idAtten,
                                  timeAttendend: e.timeAtten != null
                                      ? DateFormat('HH:mm').format(
                                          DateFormat("yyyy-MM-dd HH:mm:ss")
                                              .parse(e.timeAtten))
                                      : null,
                                );
                              }),
                        ),
                      ),
                    );
                  } else if (state is LoadingPost) {
                    return SpinKitChasingDots(
                      color: ColorApp.orange,
                    );
                  } else if (state is LoadErrorPost) {
                    return Center(
                      child: Text(
                        state.error,
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  } else {
                    return SpinKitChasingDots(
                      color: ColorApp.orange,
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, Size size, String title,
      String description, Teacher teacher) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.001),
            child: DraggableScrollableSheet(
              initialChildSize: 0.4,
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
                            'Thông tin lớp',
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
                            return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                // child:
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(4),
                                          child: CircleAvatar(
                                            backgroundColor: ColorApp.lightGrey,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    // widget.teacher.avatar,
                                                    teacher.avatar != null
                                                        ? teacher.avatar
                                                        : ''),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Giảng viên phụ trách : ' +
                                                teacher.name),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text('Email giảng viên : ' +
                                                teacher.email),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _class.name != null
                                                  ? 'Tên lớp : ' + _class.name
                                                  : '',
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              _class.id != null
                                                  ? 'Mã lớp : ' + _class.id
                                                  : '',
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              _class.note != null
                                                  ? 'Mô tả : ' + _class.note
                                                  : '',
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              _class.date != null
                                                  ? 'Ngày tạo : ' +
                                                      DateFormat(
                                                              'HH:mm - dd-MM-yyyy')
                                                          .format(DateFormat(
                                                                  "yyyy-MM-dd HH:mm:ss")
                                                              .parse(
                                                                  _class.date))
                                                  : '',
                                            ),
                                          ],
                                        ),
                                        //qr
                                        Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: ColorApp.lightOrange
                                                    .withOpacity(0.09),
                                                spreadRadius: 3,
                                                blurRadius: 5,
                                                offset: Offset(2,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            // border:
                                            //     Border.all(color: ColorApp.lightGrey)
                                          ),
                                          child: QrImage(
                                            data: _class.id,
                                            embeddedImage: AssetImage(
                                                'assets/images/logoUTC.png'),
                                            version: QrVersions.auto,
                                            size: 100,
                                            gapless: false,
                                            embeddedImageStyle:
                                                QrEmbeddedImageStyle(
                                              size: Size(15, 15),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ));
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget comment(
    Size size,
  ) {
    return Container(
        width: size.width,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: ColorApp.orange.withOpacity(0.05),
                spreadRadius: 3,
                blurRadius: 3,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ColorApp.lightGrey)),
        child:
            BlocBuilder<StudentBloc, StudentState>(builder: (context, state) {
          if (state is StudentLoaded) {
            return TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewNotify(
                              idClass: widget.idClass,
                              student: state.student,
                            ))).then(
                    (value) => postBloc.add(GetPostEvent(widget.idClass)));
              },
              child: Row(
                children: [
                  CustomAvatarGlow(
                    glowColor: ColorApp.orange,
                    endRadius: 20.0,
                    duration: Duration(milliseconds: 1000),
                    repeat: true,
                    showTwoGlows: true,
                    repeatPauseDuration: Duration(milliseconds: 100),
                    child: Container(
                      padding: EdgeInsets.all(4),
                      child: CircleAvatar(
                        backgroundColor: ColorApp.lightGrey,
                        backgroundImage:
                            CachedNetworkImageProvider(state.student.avatar),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Thông báo gì đó cho lớp học của bạn...',
                    style: TextStyle(color: ColorApp.lightOrange),
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        }));
  }

  Widget title(Size size, String name) {
    return Container(
      // height: 100,
      width: size.width,
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
          gradient: new LinearGradient(
              colors: ColorRandom
                  .colors[Random().nextInt(ColorRandom.colors.length)],
              stops: [0.0, 1.0],
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomRight,
              tileMode: TileMode.repeated),
          borderRadius: BorderRadius.circular(10)),
      child: Text(
        name,
        softWrap: true,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}

class ItemNoti extends StatelessWidget {
  final String avatar;
  final String userName;
  final String time;
  final String title;
  final String content;
  final int numberFile;
  final String idAttendend;
  final String timeAttendend;
  ItemNoti(
      {this.avatar,
      this.userName,
      this.time,
      this.title,
      this.content,
      this.numberFile,
      this.idAttendend,
      this.timeAttendend});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.width * 0.03),
      child: Column(
        children: [
          Container(
            width: size.width,
            padding: EdgeInsets.all(size.width * 0.03),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                border: Border.all(color: ColorApp.lightGrey, width: 1)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      child: CircleAvatar(
                        backgroundColor: ColorApp.lightGrey,
                        radius: 15,
                        backgroundImage: CachedNetworkImageProvider(avatar),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName.toUpperCase(),
                          softWrap: true,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: ColorApp.black, fontSize: 17),
                        ),
                        Text(
                          "Đã đăng  " + time,
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  title,
                  softWrap: true,
                  style: TextStyle(color: ColorApp.black, fontSize: 16),
                ),
                SizedBox(
                  height: 5,
                ),
                content != null
                    ? Text(
                        content,
                        softWrap: true,
                        style: TextStyle(
                            color: ColorApp.black.withOpacity(.6),
                            fontSize: 16),
                      )
                    : Container(),
                SizedBox(
                  height: 10,
                ),
                idAttendend != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'Mã điểm danh: ',
                                  style: TextStyle(
                                      color: ColorApp.black,
                                      fontWeight: FontWeight.normal),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: idAttendend,
                                        style: TextStyle(
                                          color: ColorApp.red,
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'Hạn: ',
                                  style: TextStyle(
                                      color: ColorApp.black,
                                      fontWeight: FontWeight.normal),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: timeAttendend,
                                        style: TextStyle(
                                          color: ColorApp.red,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: ColorApp.lightOrange.withOpacity(0.09),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: Offset(
                                      2, 3), // changes position of shadow
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              // border:
                              //     Border.all(color: ColorApp.lightGrey)
                            ),
                            child: QrImage(
                              data: idAttendend,
                              embeddedImage:
                                  AssetImage('assets/images/logoUTC.png'),
                              version: QrVersions.auto,
                              size: 80,
                              gapless: false,
                              embeddedImageStyle: QrEmbeddedImageStyle(
                                size: Size(15, 15),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.attachment,
                      color: Colors.grey,
                      size: 15,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      numberFile.toString() + ' Tệp đính kèm',
                      softWrap: true,
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
              width: size.width,
              padding: EdgeInsets.all(size.width * 0.03),
              decoration: BoxDecoration(
                  color: Colors.white,
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
              child: Text(
                'Thêm nhận xét lớp học',
                style: TextStyle(color: Colors.grey),
              ))
        ],
      ),
    );
  }
}
