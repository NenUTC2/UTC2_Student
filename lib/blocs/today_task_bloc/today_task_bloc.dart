import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:utc2_student/service/firestore/schedule_student.dart';

part 'today_task_event.dart';
part 'today_task_state.dart';

class TodayTaskBloc extends Bloc<TodayTaskEvent, TodayTaskState> {
  TodayTaskBloc() : super(TodayTaskInitial());

  @override
  Stream<TodayTaskState> mapEventToState(
    TodayTaskEvent event,
  ) async* {
    switch (event.runtimeType) {
      case GetTodayTaskEvent:
        yield TodayTaskLoading();
        List<Schedule> todayList = [];
        List<Schedule> list = await ScheduleDatabase.getScheduleData(
          event.props[0],
        );
        for (var mon in list) {
          DateTime timeStart =
              DateFormat("yyyy-MM-dd HH:mm:ss").parse(mon.timeStart);
          DateTime timeEnd =
              DateFormat("yyyy-MM-dd HH:mm:ss").parse(mon.timeEnd);
          DateTime now = DateTime.now();
          if (now.difference(timeStart).inDays >= 0 &&
              timeEnd.difference(now).inDays >= 0) {
            bool isToday = false;

            List<TaskOfSchedule> listTask =
                await ScheduleDatabase.getTaskOfScheduleData(
              event.props[0],
              mon.idSchedule,
            );
            for (var task in listTask) {
              if (task.note - 1 == now.weekday) {
                isToday = true;
                break;
              }
            }

            if (isToday) todayList.add(mon);
          }
        }
        // print(todayList.length);
        if (todayList.length > 0) {
          print(todayList.length);
          yield LoadedTodayTask(todayList);
        } else
          yield TodayTaskError('Chưa có lịch học');
        break;
    }
  }
}
