import 'package:cloud_firestore/cloud_firestore.dart';

class StudentTestDatabase {
  static getStudentsTest(String idClass, String idPost,String idStudent) async {
    List<StudentTest> list = [];
    var data = await FirebaseFirestore.instance
        .collection('Class')
        .doc(idClass)
        .collection('Post')
        .doc(idPost)
        .collection('Quiz')
        .where('idStudent',isEqualTo:idStudent )
        .get();
    list = data.docs.map((e) => StudentTest(e)).toList();
    return list;
  }
}
class StudentOffClass {
  String id;
  StudentOffClass(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    this.id = json['id'];
  }
}
class StudentTest {
  String idStudent;
  String idQuiz;
  String score;
  String timeTest;
  String totalAnswer;
  String idPost;
  StudentTest(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    this.idStudent = json['idStudent'];
    this.idQuiz = json['idQuiz'];
    this.score = json['score'];
    this.timeTest = json['time'];
    this.totalAnswer = json['totalAnswer'];
    this.idPost=json['idPost'];
  }
}
