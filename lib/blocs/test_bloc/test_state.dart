import 'package:equatable/equatable.dart';
import 'package:utc2_student/service/firestore/test_student_database.dart';

abstract class TestState extends Equatable {
  const TestState();

  @override
  List<Object> get props => [];
}

class TestInitial extends TestState {}

class LoadingTest extends TestState {}

class LoadedTest extends TestState {
  final List<StudentTest> list;
  LoadedTest(this.list);
}

class LoadErrorTest extends TestState {
  final String error;
  LoadErrorTest(this.error);
}
