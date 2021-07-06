import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleDatabase {
  Future<void> createSchedule(Map<String, String> dataSchedule,
      String idStudent, String idSchedule) async {
    await FirebaseFirestore.instance
        .collection('Student')
        .doc(idStudent)
        .collection('Schedule')
        .doc(idSchedule)
        .set(dataSchedule);
  }

  Future<void> createTaskOfSchedule(Map<String, String> dataTaskOfSchedule,
      String idStudent, String idSchedule, String idTaskOfSchedule) async {
    await FirebaseFirestore.instance
        .collection('Student')
        .doc(idStudent)
        .collection('Schedule')
        .doc(idSchedule)
        .collection('TaskOfSchedule')
        .doc(idTaskOfSchedule)
        .set(dataTaskOfSchedule);
  }

  static Future<void> deleteSchedule(
      String idStudent, String idSchedule) async {
    await FirebaseFirestore.instance
        .collection('Student')
        .doc(idStudent)
        .collection('Schedule')
        .doc(idSchedule)
        .delete();
  }

  static Future<void> updateSchedule(
      String idStudent, String idSchedule, Map<String, String> data) async {
    FirebaseFirestore.instance
        .collection('Student')
        .doc(idStudent)
        .collection('Schedule')
        .doc(idSchedule)
        .update(data);
  }

  Future<void> deleteTaskOfSchedule(
      String idStudent, String idSchedule, String idTaskOfSchedule) async {
    await FirebaseFirestore.instance
        .collection('Student')
        .doc(idStudent)
        .collection('Schedule')
        .doc(idSchedule)
        .collection('TaskOfSchedule')
        .doc(idTaskOfSchedule)
        .delete();
  }

  static getScheduleData(String idStudent) async {
    List<Schedule> list = [];
    var data = await FirebaseFirestore.instance
        .collection('Student')
        .doc(idStudent)
        .collection('Schedule')
        .get();
    list = data.docs.map((e) => Schedule(e)).toList();

    return list;
  }

  static Future<List<TaskOfSchedule>> getTaskOfScheduleData(
      String idStudent, String idSchedule) async {
    List<TaskOfSchedule> list = [];
    var data = await FirebaseFirestore.instance
        .collection('Student')
        .doc(idStudent)
        .collection('Schedule')
        .doc(idSchedule)
        .collection('TaskOfSchedule')
        .get();
    list = data.docs.map((e) => TaskOfSchedule(e)).toList();

    return list;
  }
}

class Schedule {
  String idSchedule, idStudent, titleSchedule, timeStart, timeEnd, note;
  Schedule(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    this.idSchedule = json['idSchedule'];
    this.idStudent = json['idStudent'];
    this.titleSchedule = json['titleSchedule'];
    this.timeStart = json['timeStart'];
    this.timeEnd = json['timeEnd'];
    this.note = json['note'];
  }
}

class TaskOfSchedule {
  String idSchedule,
      idTask,
      titleSchedule,
      titleTask,
      timeStart,
      timeEnd,
      idRoom,
      statusAttend;
  int note;
  TaskOfSchedule(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    this.idSchedule = json['idSchedule'];
    this.idTask = json['idTask'];
    this.titleTask = json['titleTask'];
    this.timeStart = json['timeStart'];
    this.timeEnd = json['timeEnd'];
    this.note = int.parse(json['note']);
    this.idRoom = json['idRoom'];
    this.statusAttend = json['statusAttend'];
  }
}
