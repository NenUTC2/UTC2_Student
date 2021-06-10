import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utc2_student/service/firestore/class_database.dart';
import 'package:utc2_student/service/firestore/student_database.dart';

part 'class_event.dart';
part 'class_state.dart';

class ClassBloc extends Bloc<ClassEvent, ClassState> {
  ClassBloc() : super(ClassInitial());

  ClassDatabase classDatabase = ClassDatabase();
  @override
  Stream<ClassState> mapEventToState(
    ClassEvent event,
  ) async* {
    switch (event.runtimeType) {
      case GetClassEvent:
        yield LoadingClass();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userEmail = prefs.getString('userEmail');

        List<Class> listClass = await classDatabase.getClassData();
        List<Class> listClassOfStudent = [];

        Student student = await StudentDatabase.getStudentData(userEmail);
        List<String> listClassStu =
            await StudentDatabase.getListClassStudent(student.id);

        if (listClass.isNotEmpty) {
          //class student
          for (var cla in listClass) {
            if (listClassStu.contains(cla.id)) {
              listClassOfStudent.add(cla);
            }
          }
          //sort
          yield LoadedClass(sapXepGiamDan(listClassOfStudent));
        } else
          yield LoadErrorClass('Bạn chưa có lớp học nào');
        break;
      default:
    }
  }

  List<Class> sapXepGiamDan(List<Class> list) {
    list.sort((a, b) => a.date.compareTo(b.date));
    return list.reversed.toList();
  }
}
