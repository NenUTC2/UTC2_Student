import 'package:cloud_firestore/cloud_firestore.dart';

class QuizDatabase {
  Future<void> createQuiz(
      Map<String, String> dataQuiz, String idTeacher, String idQuiz) async {
    await FirebaseFirestore.instance
        .collection('Teacher')
        .doc(idTeacher)
        .collection('Quiz')
        .doc(idQuiz)
        .set(dataQuiz);
  }

  Future<void> createQuestion(Map<String, String> dataQuestion,
      String idTeacher, String idQuiz, String idQuestion) async {
    await FirebaseFirestore.instance
        .collection('Teacher')
        .doc(idTeacher)
        .collection('Quiz')
        .doc(idQuiz)
        .collection('Question')
        .doc(idQuestion)
        .set(dataQuestion);
  }

  static Future<void> deleteQuiz(String idTeacher, String idQuiz) async {
    await FirebaseFirestore.instance
        .collection('Teacher')
        .doc(idTeacher)
        .collection('Quiz')
        .doc(idQuiz)
        .delete();
  }
   static getOneQuiz(String idTeacher,String idQuiz) async {
    List<Quiz> list = [];
    var data = await FirebaseFirestore.instance
        .collection('Teacher')
        .doc(idTeacher)
        .collection('Quiz')
        .where('idQuiz',isEqualTo: idQuiz)
        .get();
    list = data.docs.map((e) => Quiz(e)).toList();
    return list[0];
  }

  static Future<void> updateQuiz(
      String idTeacher, String idQuiz, Map<String, String> data) async {
    FirebaseFirestore.instance
        .collection('Teacher')
        .doc(idTeacher)
        .collection('Quiz')
        .doc(idQuiz)
        .update(data);
  }

  Future<void> deleteQuestion(
      String idTeacher, String idQuiz, String idQuestion) async {
    await FirebaseFirestore.instance
        .collection('Teacher')
        .doc(idTeacher)
        .collection('Quiz')
        .doc(idQuiz)
        .collection('Question')
        .doc(idQuestion)
        .delete();
  }

  static getListQuizData(String idTeacher) async {
    List<Quiz> list = [];
    var data = await FirebaseFirestore.instance
        .collection('Teacher')
        .doc(idTeacher)
        .collection('Quiz')
        .get();
    list = data.docs.map((e) => Quiz(e)).toList();
    return list;
  }

  static getQuizData(String idTeacher, String idQuiz) async {
    List<Quiz> list = [];
    var data = await FirebaseFirestore.instance
        .collection('Teacher')
        .doc(idTeacher)
        .collection('Quiz')
        .where('idQuiz', isEqualTo: idQuiz)
        .get();
    list = data.docs.map((e) => Quiz(e)).toList();
    return list;
  }

  static getQuestionData(String idTeacher, String idQuiz) async {
    List<Question> list = [];
    var data = await FirebaseFirestore.instance
        .collection('Teacher')
        .doc(idTeacher)
        .collection('Quiz')
        .doc(idQuiz)
        .collection('Question')
        .get();
    list = data.docs.map((e) => Question(e)).toList();
    return list;
  }
}

class Quiz {
  String idQuiz, idTeacher, titleQuiz, timePlay, dateCreate, totalQuestion;
  Quiz(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    this.idQuiz = json['idQuiz'];
    this.idTeacher = json['idTeacher'];
    this.titleQuiz = json['titleQuiz'];
    this.timePlay = json['timePlay'];
    this.dateCreate = json['dateCreate'];
    this.totalQuestion = json['totalQuestion'];
  }
}

class Question {
  String idQuiz, idQuestion, question, answerCorrect, answer2, answer3, answer4;
  Question(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    this.idQuiz = json['idQuiz'];
    this.idQuestion = json['idQuestion'];
    this.question = json['question'];
    this.answerCorrect = json['answerCorrect'];
    this.answer2 = json['answer2'];
    this.answer3 = json['answer3'];
    this.answer4 = json['answer4'];
  }
}
