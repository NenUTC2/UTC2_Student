part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class GetPostEvent extends PostEvent {
  final String idClass;

  GetPostEvent(this.idClass);
  @override
  List<Object> get props => [idClass];
}
