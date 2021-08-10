import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utc2_student/models/firebase_file.dart';

class PostDatabase {
  Future<void> createPost(
      Map<String, String> dataPost, String idClass, String idPost) async {
    await FirebaseFirestore.instance
        .collection('Class')
        .doc(idClass)
        .collection('Post')
        .doc(idPost)
        .set(dataPost);
  }

  Future<void> deletePost(String idClass, String idPost) async {
    await FirebaseFirestore.instance
        .collection('Class')
        .doc(idClass)
        .collection('Post')
        .doc(idPost)
        .delete();
  }
  Future<void> createFileInPost(Map<String, String> dataPost, String idClass,
      String idPost, FirebaseFile file) async {
    await FirebaseFirestore.instance
        .collection('Class')
        .doc(idClass)
        .collection('Post')
        .doc(idPost)
        .collection('File')
        .doc(file.name)
        .set({
      'url': file.url,
      'idPost': idPost,
      'name': file.name,
      'ref': file.ref.toString()
    });
  }

  getClassData(String idClass) async {
    List<Post> list = [];
    var data = await FirebaseFirestore.instance
        .collection('Class')
        .doc(idClass)
        .collection('Post')
        .get();
    list = data.docs.map((e) => Post(e)).toList();
    return list;
  }

  static Future<dynamic> getPost(String idClass, String idPost) async {
    var data = await FirebaseFirestore.instance
        .collection('Class')
        .doc(idClass)
        .collection('Post')
        .doc(idPost)
        .get();
    return data;
  }

  static Future<bool> checkTestStudent(
      String idClass, String idPost, String idStudent) async {
    bool check = false;
    List<String> listStudent = [];
    var data = await FirebaseFirestore.instance
        .collection('Class')
        .doc(idClass)
        .collection('Post')
        .doc(idPost)
        .collection('Quiz')
        .get();
    listStudent = data.docs.map((e) => e['idStudent'].toString()).toList();
    for (var stu in listStudent) {
      if (stu == idStudent) check = true;
    }
    return check;
  }
}

class Post {
  String id,
      idClass,
      title,
      content,
      date,
      name,
      avatar,
      idAtten,
      timeAtten,
      idQuiz,
      quizContent;
  List file;

  Post(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    this.id = json['id'];
    this.idClass = json['idClass'];
    this.title = json['title'];
    this.content = json['content'];
    this.date = json['date'];
    this.name = json['name'];
    this.avatar = json['avatar'];
    this.idAtten = json['idAtten'];
    this.timeAtten = json['timeAtten'];
    this.idQuiz = json['idQuiz'];
    this.quizContent = json['quizContent'];
  }
}
