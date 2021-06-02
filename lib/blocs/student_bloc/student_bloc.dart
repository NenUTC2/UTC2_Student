import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utc2_student/service/firestore/student_database.dart';

part 'student_event.dart';
part 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  StudentBloc() : super(StudentInitial());

  @override
  Stream<StudentState> mapEventToState(
    StudentEvent event,
  ) async* {
    switch (event.runtimeType) {
      case GetStudent:
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userEmail = prefs.getString('userEmail');
        Student student = await StudentDatabase.getStudentsData(userEmail);

        if (student != null) {
          yield StudentLoaded(student);
        } else {
          yield StudentError();
        }
        break;
      default:
    }
  }
}
