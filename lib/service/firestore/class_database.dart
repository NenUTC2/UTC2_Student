import 'package:cloud_firestore/cloud_firestore.dart';

class ClassDatabase {
  Future<void> createClass(Map<String, String> dataClass, String id) async {
    await FirebaseFirestore.instance.collection('Class').doc(id).set(dataClass);
  }

  Future<void> deleteClass(String id) async {
    await FirebaseFirestore.instance
        .collection('Class')
        .doc(id)
        .delete();
  }

  getClassData() async {
    List<Class> list = [];
    var data = await FirebaseFirestore.instance.collection('Class').get();
    list = data.docs.map((e) => Class(e)).toList();
    return list;
  }
}

class Class {
  String id, name, teacherId, date, note;

  Class(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.teacherId = json['teacherId'];
    this.date = json['date'];
    this.note = json['note'];
  }
}
