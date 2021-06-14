import 'package:equatable/equatable.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object> get props => [];
}

class GetCommentEvent extends CommentEvent {
  final String idClass;
  final String idPost;

  GetCommentEvent(this.idClass, this.idPost);
  @override
  List<Object> get props => [idClass,idPost];
}
