import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utc2_student/service/geo_service.dart';
import 'package:utc2_student/utils/utils.dart';

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
    // print('Get student ' + list[0].email);
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

  static Future<dynamic> joinClass(
      String idClass, Map<String, String> dataClass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userEmail = prefs.getString('userEmail');

    Student student = await StudentDatabase.getStudentData(userEmail);
    var list = await StudentDatabase.getListClassStudent(student.id);
    var dataStu = {'id': student.id};
    if (!list.contains(idClass)) {
      await FirebaseFirestore.instance
          .collection('Student')
          .doc(student.id)
          .collection('Class')
          .doc(idClass)
          .set(dataClass);
      await FirebaseFirestore.instance
          .collection('Class')
          .doc(idClass)
          .collection('Student')
          .doc(student.id)
          .set(dataStu);

      await FirebaseMessaging.instance.subscribeToTopic(idClass);
      return true;
    } else
      return false;
  }

  static Future<void> leaveClass(String idClass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userEmail = prefs.getString('userEmail');

    Student student = await StudentDatabase.getStudentData(userEmail);
    await FirebaseFirestore.instance
        .collection('Student')
        .doc(student.id)
        .collection('Class')
        .doc(idClass)
        .delete();
    await FirebaseFirestore.instance
        .collection('Class')
        .doc(idClass)
        .collection('Student')
        .doc(student.id)
        .delete();
    await FirebaseMessaging.instance.unsubscribeFromTopic(idClass);
  }

  static Future<List<String>> getListClassStudent(String idStu) async {
    List<String> list = [];
    var data = await FirebaseFirestore.instance
        .collection('Student')
        .doc(idStu)
        .collection('Class')
        .get();
    list = data.docs.map((e) => e['id'].toString()).toList();
    return list;
  }

  static Future attend(String idClass, String idAttend, String idPost,
      String idStudent, String address, String location, String status) async {
    var attendData = {
      'idPost': idPost,
      'idAttend': idAttend,
      'idStudent': idStudent,
      'time': DateTime.now().toString(),
      'address': address,
      'location': location,
      'status': status,
    };
    FirebaseFirestore.instance
        .collection('Class')
        .doc(idClass)
        .collection('Post')
        .doc(idPost)
        .collection('Student')
        .doc(idStudent)
        .set(attendData);
  }

  static Future submitTest(String idClass, String idPost, String idStudent,
      String totalAnswer, String score, String idQuiz) async {
    GeoService geoService = GeoService();
    Position location = await getLocation(geoService);

    var submitQuizData = {
      'idPost': idPost,
      'idStudent': idStudent,
      'idQuiz': idQuiz,
      'time': DateTime.now().toString(),
      'totalAnswer': totalAnswer,
      'score': score,
      'location':
          location.latitude.toString() + ',' + location.longitude.toString(),
    };
    FirebaseFirestore.instance
        .collection('Class')
        .doc(idClass)
        .collection('Post')
        .doc(idPost)
        .collection('Quiz')
        .doc(idStudent)
        .set(submitQuizData);
  }
}

class Student {
  String id,
      name,
      token,
      email,
      avatar,
      birthDate,
      birthPlace,
      heDaoTao,
      lop,
      khoa;

  Student(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.token = json['token'];
    this.email = json['email'];
    this.avatar = json['avatar'];
    this.birthDate = json['birthDate'];
    this.birthPlace = json['birthPlace'];
    this.heDaoTao = json['heDaoTao'];
    this.lop = json['lop'];
    this.khoa = json['khoa'];
  }
}
