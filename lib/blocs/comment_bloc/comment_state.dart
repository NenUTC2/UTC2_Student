import 'package:equatable/equatable.dart';
import 'package:utc2_student/service/firestore/comment_database.dart';

abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object> get props => [];
}

class CommentInitial extends CommentState {}

class LoadingComment extends CommentState {}

class LoadedComment extends CommentState {
  final List<Comment> list;
  LoadedComment(this.list);
}

class LoadErrorComment extends CommentState {
  final String error;
  LoadErrorComment(this.error);
}
