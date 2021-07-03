import 'package:equatable/equatable.dart';
import 'package:utc2_student/service/firestore/post_database.dart';

abstract class FileEvent extends Equatable {
  const FileEvent();

  @override
  List<Object> get props => [];
}

class GetFileEvent extends FileEvent {
  final String idClass;
  final List<Post> listPost;

  GetFileEvent(this.idClass, this.listPost);
  @override
  List<Object> get props => [idClass,listPost];
}
