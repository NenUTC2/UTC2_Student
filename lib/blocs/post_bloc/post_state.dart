part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class LoadingPost extends PostState {}

class LoadedPost extends PostState {
  final List<Post> list;

  LoadedPost(this.list);
}

class LoadErrorPost extends PostState {
  final String error;

  LoadErrorPost(this.error);
}
