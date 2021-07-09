import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:utc2_student/blocs/test_bloc/test_event.dart';
import 'package:utc2_student/blocs/test_bloc/test_state.dart';
import 'package:utc2_student/service/firestore/post_database.dart';
import 'package:utc2_student/service/firestore/test_student_database.dart';

class TestBloc extends Bloc<TestEvent, TestState> {
  TestBloc() : super(TestInitial());
  List<StudentTest> list = [];
  List<Post> listPost = [];
  @override
  Stream<TestState> mapEventToState(
    TestEvent event,
  ) async* {
    switch (event.runtimeType) {
      case GetTestEvent:
        yield LoadingTest();
        listPost = event.props[1];
        for (int i = 0; i < listPost.length; i++) {
          var item = await StudentTestDatabase.getStudentsTest(
              event.props[0], listPost[i].id,event.props[2]);
          list = list + item;
        }
         yield LoadedTest(list);
        if (list.isNotEmpty) {
          yield LoadedTest(list);
        }
         else
          yield LoadErrorTest('Chưa có bài');
        break;
      default:
    }
  }
}
