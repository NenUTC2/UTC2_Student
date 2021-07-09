import 'package:equatable/equatable.dart';
import 'package:utc2_student/service/firestore/post_database.dart';

abstract class TestEvent extends Equatable {
  const TestEvent();

  @override
  List<Object> get props => [];
}

class GetTestEvent extends TestEvent {
  final String idClass;
  final List<Post> listPost;
  final String idStudent;

  GetTestEvent(this.idClass, this.listPost, this.idStudent);
  @override
  List<Object> get props => [idClass, listPost,idStudent];
}
