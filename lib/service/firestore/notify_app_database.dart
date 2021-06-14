import 'package:cloud_firestore/cloud_firestore.dart';

class NotifyAppDatabase {
  Future<void> createNotifyApp(
      Map<String, String> dataNotifyApp, String idUser, String idNotify) async {
    await FirebaseFirestore.instance
        .collection('Student')
        .doc(idUser)
        .collection('NotifyApp')
        .doc(idNotify)
        .set(dataNotifyApp);
  }

  Future<void> deleteNotifyApp(
      String idUser, String idPost, String idNotifyApp) async {
    await FirebaseFirestore.instance
        .collection('Student')
        .doc(idUser)
        .collection('NotifyApp')
        .doc(idNotifyApp)
        .delete();
  }

  static getNotifyAppData(String idUser) async {
    List<NotifyApp> list = [];
    var data = await FirebaseFirestore.instance
        .collection('Student')
        .doc(idUser)
        .collection('NotifyApp')
        .get();
    list = data.docs.map((e) => NotifyApp(e)).toList();
    return list;
  }
}

class NotifyApp {
  String idNotifyApp, idUser, content, date, name, avatar;
  NotifyApp(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    this.idNotifyApp = json['id'];
    this.idUser = json['idUser'];
    this.content = json['content'];
    this.date = json['date'];
    this.name = json['name'];
    this.avatar = json['avatar'];
  }
}
