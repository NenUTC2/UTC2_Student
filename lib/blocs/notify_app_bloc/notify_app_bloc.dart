import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:utc2_student/blocs/notify_app_bloc/notify_app_event.dart';
import 'package:utc2_student/blocs/notify_app_bloc/notify_app_state.dart';
import 'package:utc2_student/service/firestore/notify_app_database.dart';

class NotifyAppBloc extends Bloc<NotifyAppEvent, NotifyAppState> {
  NotifyAppBloc() : super(NotifyAppInitial());
  List<NotifyApp> list = [];
  @override
  Stream<NotifyAppState> mapEventToState(
    NotifyAppEvent event,
  ) async* {
    switch (event.runtimeType) {
      case GetNotifyAppEvent:
        yield LoadingNotifyApp();
        list = await NotifyAppDatabase.getNotifyAppData(
            event.props[0],);
        if (list.isNotEmpty) {
          //sort
          // print('có chưa-có rồi');
          yield LoadedNotifyApp(sapXepGiamDan(list));
        } else
          yield LoadErrorNotifyApp('Chưa có bài nhận xét nào nào');
        break;
      default:
    }
  }

  List<NotifyApp> sapXepGiamDan(List<NotifyApp> list) {
    list.sort((a, b) => a.date.compareTo(b.date));
    return list.reversed.toList();
  }
}
