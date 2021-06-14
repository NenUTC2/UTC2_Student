import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utc2_student/blocs/class_bloc/class_bloc.dart';
import 'package:utc2_student/blocs/comment_bloc/comment_bloc.dart';
import 'package:utc2_student/blocs/login_bloc/login_bloc.dart';
import 'package:utc2_student/blocs/post_bloc/post_bloc.dart';
import 'package:utc2_student/blocs/student_bloc/student_bloc.dart';
import 'package:utc2_student/scraper/student_info_scraper.dart';
import 'package:utc2_student/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utc2_student/screens/login/login_screen.dart';
import 'package:utc2_student/service/firestore/student_database.dart';
import 'package:utc2_student/service/local_notification.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return HomePage();
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseMessaging _fireBaseMessaging;
  final notifications = FlutterLocalNotificationsPlugin();
  Widget body = Scaffold();
  @override
  void initState() {
    super.initState();

    final settingsAndroid = AndroidInitializationSettings('app_icon');

    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(android: settingsAndroid, iOS: settingsIOS),
        onSelectNotification: onSelectNotification);
    if (Platform.isIOS) {
      _fireBaseMessaging.requestPermission(
          alert: true, badge: true, sound: true, provisional: true);
    }

    // LoginEmailBloc.getInstance().init();
    // ConnectionStatusSingleton.getInstance()
    //     .connectionChange
    //     .listen(_updateConnectivity);
    // _notificationPlugin = NotificationPlugin();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        print('MESSAGE>>>>' + message.toString());
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setUpNoti(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('>>>>>>>>>>A new onMessageOpenedApp event');
      Get.to(HomeScreen());
    });
    FirebaseMessaging.instance.subscribeToTopic('fcm_test');
    // login();

    getTokenFCM();
  }

  // Future login() async {}

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ClassBloc>(create: (context) => ClassBloc()),
        BlocProvider<PostBloc>(create: (context) => PostBloc()),
        BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
        BlocProvider<StudentBloc>(create: (context) => StudentBloc()),
         BlocProvider<CommentBloc>(create: (context) => CommentBloc()),
      ],
      child: GetMaterialApp(
        theme: ThemeData(
            fontFamily: 'Nunito',
            primaryColor: Colors.orange,
            appBarTheme: Theme.of(context)
                .appBarTheme
                .copyWith(brightness: Brightness.light)),
        debugShowCheckedModeBanner: false,
        home: body,
      ),
    );
  }

  void setUpNoti(RemoteMessage message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    if (message.data['idNoti'] == 'newNoti' &&
        message.data['isAtten'] == 'false') {
      print('Thông báo new Notity--------------------------------------');
      if (message.data['token'] != token)
        MyLocalNotification.showNotification(
          notifications,
          message.data['idChannel'],
          message.data['className'],
          message.data['classDescription'],
          message.notification.title,
          message.notification.body,
        );
    } else if (message.data['idNoti'] == 'newNoti' &&
        message.data['isAtten'] == 'true') {
      MyLocalNotification.showNotificationAttenden(
        notifications,
        message.data['msg'],
        message.data['idChannel'],
        message.data['className'],
        message.data['classDescription'],
        message.notification.title,
        message.notification.body,
        message.data['timeAtten'],
      );
    } else {
      print('Thông báo NEW CLASS-------------------------------------');
      MyLocalNotification.showNotificationNewClass(
        notifications,
        message.data['nameTeacher'],
        message.data['msg'], //id lớp học
        message.data['idChannel'], //id lớp học
        message.data['className'], //ten lop
        message.data['classDescription'], //mieu ta
        //day moi show len
        message.notification.title, //ten lop
        message.notification.body, //mieu ta
      );
    }
  }

  getTokenFCM() async {
    try {
      FirebaseMessaging.instance.getToken().then((token) async {
        print('token : ' + token);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.remove('userEmail');
        prefs.setString('token', token);
        if (prefs.getString('userEmail') != null) {
          setState(() {
            body = HomeScreen();
          });
          var student = await StudentDatabase.getStudentData(
              prefs.getString('userEmail'));

          Map<String, String> data = {
            'token': token,
          };
          StudentDatabase.updateStudentData(student.id, data);
        } else
          setState(() {
            body = LoginScreen();
          });
      });
    } catch (e) {
      print('get token exception : ' + e.toString());
    }
  }

  Future onSelectNotification(String payload) async {
    print(payload);
    // Get.to(DetailClassScreen());
  }
}
