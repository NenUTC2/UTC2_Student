import 'package:cloud_firestore/cloud_firestore.dart';

class StudentDatabase {
  Future<void> createStudent(Map<String, String> dataStudent, String id) async {
    print('create student');
    await FirebaseFirestore.instance
        .collection('Student')
        .doc(id)
        .set(dataStudent);
  }

  Future<void> deleteStudent(String id) async {
    await FirebaseFirestore.instance.collection('Student').doc(id).delete();
  }

  static Future<bool> isRegister(String email) async {
    var data = await FirebaseFirestore.instance
        .collection('Student')
        .where('email', isEqualTo: email)
        .get();
    var list = data.docs.map((e) => Student(e)).toList();
    if (list.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  static Future<Student> getStudentsData(String email) async {
    List<Student> list = [];
    var data = await FirebaseFirestore.instance
        .collection('Student')
        .where('email', isEqualTo: email)
        .get();
    list = data.docs.map((e) => Student(e)).toList();
    return list[0];
  }

  getListStudentsData() async {
    List<Student> list = [];
    var data = await FirebaseFirestore.instance.collection('Student').get();
    list = data.docs.map((e) => Student(e)).toList();
    return list;
  }
}

class Student {
  String id, name, date, studentId, email, avatar;

  Student(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.date = json['date'];
    this.studentId = json['studentId'];
    this.email = json['email'];
    this.avatar = json['avatar'];
  }
}
