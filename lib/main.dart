import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:utc2_student/blocs/class_bloc/class_bloc.dart';
import 'package:utc2_student/blocs/post_bloc/post_bloc.dart';
import 'package:utc2_student/screens/classroom/class_detail_screen.dart';
import 'package:utc2_student/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      print('>>>>>>>>>>A new onMessage event' + message.notification.body);
      MyLocalNotification.showNotification(notifications,
          message.notification.title, message.notification.body, message.data);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('>>>>>>>>>>A new onMessageOpenedApp event');
      Get.to(HomeScreen());
    });
    FirebaseMessaging.instance.subscribeToTopic('fcm_test');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getTokenFCM();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ClassBloc>(create: (context) => ClassBloc()),
        BlocProvider<PostBloc>(create: (context) => PostBloc())
      ],
      child: GetMaterialApp(
        theme: ThemeData(
            fontFamily: 'Nunito',
            primaryColor: Colors.orange,
            appBarTheme: Theme.of(context)
                .appBarTheme
                .copyWith(brightness: Brightness.light)),
        debugShowCheckedModeBanner: false,
        // home: HomeScreen(),
        home: HomeScreen(),
      ),
    );
  }

  getTokenFCM() {
    try {
      FirebaseMessaging.instance.getToken().then((token) => {
            // LoginEmailBloc.getInstance().setFCMToken = token,
            print('token : ' + token)
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
