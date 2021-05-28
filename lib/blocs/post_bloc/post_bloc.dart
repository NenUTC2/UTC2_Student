import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:utc2_student/service/firestore/post_database.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostInitial());
  List<Post> list = [];
  PostDatabase postDatabase = PostDatabase();
  @override
  Stream<PostState> mapEventToState(
    PostEvent event,
  ) async* {
    switch (event.runtimeType) {
      case GetPostEvent:
        yield LoadingPost();
        list = await postDatabase.getClassData(event.props[0]);
        if (list.isNotEmpty)
          //sort

          yield LoadedPost(sapXepGiamDan(list));
        else
          yield LoadErrorPost('Chưa có bài đăng nào');
        break;
      default:
    }
  }

  List<Post> sapXepGiamDan(List<Post> list) {
    list.sort((a, b) => a.date.compareTo(b.date));
    return list.reversed.toList();
  }
}
