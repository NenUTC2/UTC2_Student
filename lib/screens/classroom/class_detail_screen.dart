import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:utc2_student/screens/home_screen.dart';
import 'package:utc2_student/service/local_notification.dart';
import 'package:utc2_student/utils/custom_glow.dart';
import 'package:utc2_student/utils/utils.dart';
import 'package:utc2_student/widgets/class_drawer.dart';
import 'package:flutter/material.dart';

import 'package:utc2_student/utils/color_random.dart';

class DetailClassScreen extends StatefulWidget {
  final String className;
  final List listClass;
  DetailClassScreen({this.className, this.listClass});
  @override
  _DetailClassScreenState createState() => _DetailClassScreenState();
}

class _DetailClassScreenState extends State<DetailClassScreen> {
  final notifications = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    sendNoti();
    final settingsAndroid = AndroidInitializationSettings('app_icon');

    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(android: settingsAndroid, iOS: settingsIOS),
        onSelectNotification: onSelectNotification);
  }

  void sendNoti() async {
    MyLocalNotification.configureLocalTimeZone();
    // await MyLocalNotification.scheduleWeeklyMondayTenAMNotification(
    //     notifications, 14, 20);
    // await MyLocalNotification.scheduleWeeklyMondayTenAMNotification(
    //     notifications, 14, 19);
  }

  Future onSelectNotification(String payload) async => await Navigator.push(
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
                      widget.className.toUpperCase(), 'Thông tin lớp'),
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
      ),
      body: Container(
        width: size.width,
        height: size.height,
        color: Colors.white,
        padding: EdgeInsets.all(size.width * 0.03),
        child: Column(
          children: [
            title(size, widget.className.toUpperCase()),
            SizedBox(
              height: 7,
            ),
            comment(size, MyLocalNotification.showNotification, notifications)
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(
      BuildContext context, Size size, String title, String description) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.001),
            child: GestureDetector(
              onTap: () {},
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
                              return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  // child:
                                  child: Text(
                                    description,
                                  ));
                            },
                          ),
                        ),
                        // FlatButton(
                        //   minWidth: size.width,
                        //   height: size.height * 0.08,
                        //   color: Color(0xff1976D3),
                        //   onPressed: () {
                        //     Navigator.pop(context);
                        //   },
                        //   child: Text(
                        //     'ĐÓNG',
                        //     style: TextStyle(
                        //         color: Colors.white,
                        //         fontSize: size.width * 0.05),
                        //   ),
                        // )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget comment(
      Size size,
      Future<void> comment(
          FlutterLocalNotificationsPlugin noti, String t, String b, Map<String, dynamic>data),
      FlutterLocalNotificationsPlugin noti) {
    return Container(
      width: size.width,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: ColorApp.blue.withOpacity(0.05),
              spreadRadius: 3,
              blurRadius: 3,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorApp.lightGrey)),
      child: TextButton(
        onPressed: () async {
          await comment(noti, 'title', 'body',null);
          print('dsd');
        },
        child: Row(
          children: [
            CustomAvatarGlow(
              glowColor: ColorApp.blue,
              endRadius: 20.0,
              duration: Duration(milliseconds: 1000),
              repeat: true,
              showTwoGlows: true,
              repeatPauseDuration: Duration(milliseconds: 100),
              child: Container(
                padding: EdgeInsets.all(4),
                child: CircleAvatar(
                  backgroundColor: ColorApp.lightGrey,
                  backgroundImage: AssetImage('assets/images/logoUTC.png'),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text('Thông báo gì đó cho lớp học của bạn...'),
          ],
        ),
      ),
    );
  }

  Widget title(Size size, String name) {
    return Container(
      height: 100,
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
