import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:utc2_student/blocs/comment_bloc/comment_event.dart';
import 'package:utc2_student/blocs/comment_bloc/comment_state.dart';
import 'package:utc2_student/service/firestore/comment_database.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc() : super(CommentInitial());
  List<Comment> list = [];
  @override
  Stream<CommentState> mapEventToState(
    CommentEvent event,
  ) async* {
    switch (event.runtimeType) {
      case GetCommentEvent:
        yield LoadingComment();
        list = await CommentDatabase.getCommentData(
            event.props[0], event.props[1]);
        if (list.isNotEmpty) {
          //sort
          // print('có chưa-có rồi');
          yield LoadedComment(sapXepGiamDan(list));
        } else
          yield LoadErrorComment('Chưa có bài nhận xét nào nào');
        break;
      default:
    }
  }

  List<Comment> sapXepGiamDan(List<Comment> list) {
    list.sort((a, b) => a.date.compareTo(b.date));
    return list.reversed.toList();
  }
}
