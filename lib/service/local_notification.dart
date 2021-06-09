import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MyLocalNotification {
  static Future<void> scheduleWeeklyMondayTenAMNotification(
      FlutterLocalNotificationsPlugin notifications,
      int wd,
      int sh,
      int sm,
      int eh,
      int em,
      String tenMon,
      String room,
      int maMon,
      int maLich) async {
    String sem = em == 0 ? '00' : '$em';
    await notifications.zonedSchedule(
        int.parse('$maMon$maLich'),
        'Đến giờ học môn $tenMon - $room',
        '$sh:$sm - $eh:$sem',
        nextInstanceOfWeekDayTime(sh, sm, wd),
        NotificationDetails(
          android: AndroidNotificationDetails(
              '$tenMon-$maLich', '$tenMon-$maLich', '$tenMon-$maLich'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  static Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
    print(timeZoneName);
  }

  static tz.TZDateTime nextInstanceOfTime(int h, int m) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, h, m);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    print(scheduledDate);
    return scheduledDate;
  }

  static tz.TZDateTime nextInstanceOfWeekDayTime(int h, int m, int wd) {
    tz.TZDateTime scheduledDate = nextInstanceOfTime(h, m);
    while (scheduledDate.weekday != wd) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  static Future<void> showNotification(
      FlutterLocalNotificationsPlugin notifications,
      String idChannel, //id lớp học
      String chanelName, //tên lớp học
      String chanelDescription, //miêu tả của lớp
      String title, //Tiêu đề thông báo
      String body //Nội dung
      ) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        body,
        htmlFormatBigText: true,
        htmlFormatContentTitle: true,
        htmlFormatSummaryText: true,
        htmlFormatContent: true,
        summaryText: chanelName);
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      idChannel,
      chanelName,
      chanelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      enableLights: true,
      styleInformation: bigTextStyleInformation,
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notifications.show(0, title, body, platformChannelSpecifics,
        payload: 'item x');
  }

  static Future<void> showNotificationEvent(
      FlutterLocalNotificationsPlugin notifications,
      String idChannel, //id lớp học
      String chanelName, //tên lớp học
      String chanelDescription, //miêu tả của lớp
      String title, //Tiêu đề thông báo
      String body //Nội dung

      ) async {
    int insistentFlag = 4;
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(idChannel, chanelName, chanelDescription,
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            enableLights: true,
            styleInformation: BigTextStyleInformation(body),
            additionalFlags: Int32List.fromList(<int>[insistentFlag]));
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notifications.show(0, chanelName, title, platformChannelSpecifics,
        payload: 'item x');
  }

  static Future<void> cancelNotification(
      FlutterLocalNotificationsPlugin notifications) async {
    await notifications.cancel(0);
  }

  static Future<void> showNotificationAttenden(
      FlutterLocalNotificationsPlugin notifications,
      String idQR, //mã điểm danh
      String idChannel, //id lớp học
      String chanelName, //tên lớp học
      String chanelDescription, //miêu tả của lớp
      String title, //Tiêu đề thông báo
      String body, //Nội dung
      String timeAtten //Thời gian kết thúc điểm danh
      ) async {
    final String largeIconPath = await _downloadAndSaveFile(
        'https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=$idQR',
        idQR + 'small');
    final String bigPicturePath = await _downloadAndSaveFile(
        'https://chart.googleapis.com/chart?chs=85x85&cht=qr&chl=$idQR',
        idQR + 'big');
    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
            hideExpandedLargeIcon: true,
            contentTitle: 'Mã điểm danh : ' +
                '<b>$idQR</b> ' +
                ' - Hạn : ' +
                '<b>$timeAtten</b>',
            htmlFormatContentTitle: true,
            summaryText: body,
            htmlFormatContent: true);
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(idChannel, chanelName, chanelDescription,
            largeIcon: FilePathAndroidBitmap(largeIconPath),
            styleInformation: bigPictureStyleInformation);
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notifications.show(
        0,
        chanelName,
        title + '  -   Mã điểm danh: ' + idQR + '  -   Hạn: ' + timeAtten,
        platformChannelSpecifics);
  }

  static Future<void> showNotificationNewClass(
    FlutterLocalNotificationsPlugin notifications,
    String nameTeacher,
    String idQR, //mã lớp
    String idChannel, //id lớp học
    String chanelName, //tên lớp học
    String chanelDescription, //miêu tả của lớp
    String title, //Tiêu đề thông báo
    String body, //Nội dung
  ) async {
    final String largeIconPath = await _downloadAndSaveFile(
        'https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=$idQR',
        idQR + 'small');
    final String bigPicturePath = await _downloadAndSaveFile(
        'https://chart.googleapis.com/chart?chs=85x85&cht=qr&chl=$idQR',
        idQR + 'big');
    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
            hideExpandedLargeIcon: true,
            contentTitle: 'Mã lớp : ' + '<b>$idQR</b> ',
            htmlFormatContentTitle: true,
            summaryText: 'Miêu tả : ' + chanelDescription,
            htmlFormatContent: true);
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(idChannel, chanelName, chanelDescription,
            largeIcon: FilePathAndroidBitmap(largeIconPath),
            styleInformation: bigPictureStyleInformation);
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await notifications.show(0, nameTeacher + ' - ' + chanelName,
        title + '  -   Mã lớp: ' + idQR, platformChannelSpecifics);
  }

  static Future<String> _downloadAndSaveFile(
      String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}
