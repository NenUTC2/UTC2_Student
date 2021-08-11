import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utc2_student/blocs/class_bloc/class_bloc.dart';
import 'package:utc2_student/blocs/comment_bloc/comment_bloc.dart';
import 'package:utc2_student/blocs/file_bloc/file_bloc.dart';
import 'package:utc2_student/blocs/login_bloc/login_bloc.dart';
import 'package:utc2_student/blocs/notify_app_bloc/notify_app_bloc.dart';
import 'package:utc2_student/blocs/post_bloc/post_bloc.dart';
import 'package:utc2_student/blocs/question_bloc/question_bloc.dart';
import 'package:utc2_student/blocs/quiz_bloc/quiz_bloc.dart';
import 'package:utc2_student/blocs/student_bloc/student_bloc.dart';
import 'package:utc2_student/blocs/test_bloc/test_bloc.dart';
import 'package:utc2_student/models/floorplan_model.dart';
import 'package:utc2_student/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utc2_student/screens/login/login_screen.dart';
import 'package:utc2_student/service/firestore/notify_app_database.dart';
import 'package:utc2_student/service/firestore/student_database.dart';
import 'package:utc2_student/service/local_notification.dart';
import 'package:utc2_student/utils/utils.dart';

import 'blocs/schedule_bloc/schedule_bloc.dart';
import 'blocs/task_of_schedule_bloc/task_of_schedule_bloc.dart';
import 'blocs/today_task_bloc/today_task_bloc.dart';

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
  NotifyAppDatabase notifyAppDatabase = new NotifyAppDatabase();

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

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        print('MESSAGE>>>>' + message.toString());
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('>>>>>>>>>>A new onMessage event');
      createLocalNotify(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('>>>>>>>>>>A new onMessageOpenedApp event');
      Get.to(HomeScreen());
    });
    FirebaseMessaging.instance.subscribeToTopic('fcm_test');
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
        BlocProvider<QuestionBloc>(create: (context) => QuestionBloc()),
        BlocProvider<QuizBloc>(create: (context) => QuizBloc()),
        BlocProvider<NotifyAppBloc>(create: (context) => NotifyAppBloc()),
        BlocProvider<FileBloc>(create: (context) => FileBloc()),
        BlocProvider<ScheduleBloc>(create: (context) => ScheduleBloc()),
        BlocProvider<TodayTaskBloc>(create: (context) => TodayTaskBloc()),
        BlocProvider<TaskOfScheduleBloc>(
            create: (context) => TaskOfScheduleBloc()),
        BlocProvider<TestBloc>(create: (context) => TestBloc()),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<FloorPlanModel>(
              create: (context) => FloorPlanModel()),
        ],
        child: GetMaterialApp(
          title: 'UTC2 Student',
          theme: ThemeData(
              fontFamily: 'Nunito',
              primaryColor: Colors.orange,
              appBarTheme: Theme.of(context)
                  .appBarTheme
                  .copyWith(brightness: Brightness.light)),
          debugShowCheckedModeBanner: false,
          home: body,
        ),
      ),
    );
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

  void createLocalNotify(RemoteMessage message) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String email = preferences.getString('userEmail');
    var teacher = await StudentDatabase.getStudentData(email);
    String id = generateRandomString(5);

    var token = preferences.getString('token');
    if (message.data['token'] != token) {
      ////Noti 1 normal
      if (message.data['idNoti'] == 'newNoti' &&
          message.data['isAtten'] == 'false') {
        print('======> Noti 1');
        MyLocalNotification.showNotification(
          notifications,
          message.data['idChannel'],
          message.data['className'],
          message.data['classDescription'],
          message.notification.title,
          message.notification.body,
        );
        Map<String, String> dataNotifyApp = {
          'id': id ?? '',
          'idUser': teacher.id ?? '', //user đăng nhập
          'content': message.data['content'] ?? '',
          'name': message.data['name'] ?? '' ?? '', //người đăng
          'avatar': message.data['avatar'] ?? '', //người đăng
          'date': DateTime.now().toString(), //time nhận được
        };
        notifyAppDatabase.createNotifyApp(dataNotifyApp, teacher.id, id);
      }

      ///////Noti 2 Attend
      else if (message.data['idNoti'] == 'newNoti' &&
          message.data['isAtten'] == 'true') {
        print('=====> Noti 2 Attend');
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
        Map<String, String> dataNotifyApp = {
          'id': id ?? '',
          'idUser': teacher.id ?? '', //user đăng nhập
          'content': message.data['content'] ?? '',
          'name': message.data['name'] ?? '' ?? '', //người đăng
          'avatar': message.data['avatar'] ?? '', //người đăng
          'date': DateTime.now().toString(), //time nhận được
        };
        notifyAppDatabase.createNotifyApp(dataNotifyApp, teacher.id, id);
      }

      ////Noti 3 new class
      else if ((message.data['idNoti'] == 'newClass')) {
        print('======> Noti 3 New class');
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
        Map<String, String> dataNotifyApp = {
          'id': id ?? '',
          'idUser': teacher.id ?? '', //user đăng nhập
          'content': message.data['content'] ?? '',
          'name': message.data['name'] ?? '' ?? '', //người đăng
          'avatar': message.data['avatar'] ?? '', //người đăng
          'date': DateTime.now().toString(), //time nhận được
        };
        notifyAppDatabase.createNotifyApp(dataNotifyApp, teacher.id, id);
      }
    } else {
      print('=======> User noti no need to show');
    }
  }
}
