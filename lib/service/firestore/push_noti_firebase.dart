import 'dart:convert';

import 'package:http/http.dart' as http;

class PushNotiFireBaseAPI {
  static Future<http.Response> pushNotiTopic(String title, String body,
      Map<String, dynamic> data, String topic) async {
    final response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization':
                  'key=AAAAYogee34:APA91bFuj23NLRj88uqP9J-aRCehCgVSo8QgUOIPZy8CzBE-Xbubx58trUepsb2SABoIGsPYbONqa2jjS03l1fW5r2aQywmKkYN6L3RXHIML6795xTHyamls_ZwLSt-_n3AJ8av82CiW',
            },
            body: jsonEncode({
              "to": "/topics/$topic",
              "data": data,
              "notification": {
                "title": title,
                "body": body != null ? body : '',
              }
            }));
    return response;
  }

  static Future<http.Response> pushNotiToken(String title, String body,
      Map<String, dynamic> data, String token) async {
    final response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization':
                  'key=AAAAYogee34:APA91bFuj23NLRj88uqP9J-aRCehCgVSo8QgUOIPZy8CzBE-Xbubx58trUepsb2SABoIGsPYbONqa2jjS03l1fW5r2aQywmKkYN6L3RXHIML6795xTHyamls_ZwLSt-_n3AJ8av82CiW',
            },
            body: jsonEncode({
              "to": token,
              "data": data,
              "notification": {
                "title": title,
                "body": body != null ? body : '',
              }
            }));
    return response;
  }
}
