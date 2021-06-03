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

  static Future<Student> getStudentData(String email) async {
    List<Student> list = [];
    var data = await FirebaseFirestore.instance
        .collection('Student')
        .where('email', isEqualTo: email)
        .get();
    list = data.docs.map((e) => Student(e)).toList();
    print('Get student ' + list[0].email);
    return list[0];
  }

  static Future<void> updateStudentData(
      String msv, Map<String, String> data) async {
    print(msv);
    FirebaseFirestore.instance.collection('Student').doc(msv).update(data);
  }

  getListStudentsData() async {
    List<Student> list = [];
    var data = await FirebaseFirestore.instance.collection('Student').get();
    list = data.docs.map((e) => Student(e)).toList();
    return list;
  }
}

class Student {
  String id, name, token, email, avatar;

  Student(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.token = json['token'];
    this.email = json['email'];
    this.avatar = json['avatar'];
  }
}
