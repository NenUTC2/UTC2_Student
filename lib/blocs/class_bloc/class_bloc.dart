import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:utc2_student/service/firestore/class_database.dart';

part 'class_event.dart';
part 'class_state.dart';

class ClassBloc extends Bloc<ClassEvent, ClassState> {
  ClassBloc() : super(ClassInitial());

  ClassDatabase classDatabase = ClassDatabase();
  List<Class> listClass = [];
  @override
  Stream<ClassState> mapEventToState(
    ClassEvent event,
  ) async* {
    switch (event.runtimeType) {
      case GetClassEvent:
        yield LoadingClass();
        listClass = await classDatabase.getClassData();
        if (listClass.isNotEmpty)
          //sort

          yield LoadedClass(sapXepGiamDan(listClass));
        else
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
