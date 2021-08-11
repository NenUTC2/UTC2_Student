import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:utc2_student/blocs/task_of_schedule_bloc/task_of_schedule_event.dart';
import 'package:utc2_student/blocs/task_of_schedule_bloc/task_of_schedule_state.dart';
import 'package:utc2_student/service/firestore/schedule_student.dart';

class TaskOfScheduleBloc
    extends Bloc<TaskOfScheduleEvent, TaskOfScheduleState> {
  TaskOfScheduleBloc() : super(TaskOfScheduleInitial());
  @override
  Stream<TaskOfScheduleState> mapEventToState(
    TaskOfScheduleEvent event,
  ) async* {
    switch (event.runtimeType) {
      case GetTaskOfScheduleEvent:
        yield LoadingTaskOfSchedule();

        List<TaskOfSchedule> todayList = [];
        List<TaskOfSchedule> nowList = [];
        List<TaskOfSchedule> list =
            await ScheduleDatabase.getTaskOfScheduleData(
          event.props[0],
          event.props[1],
        );
        for (var task in list) {

          DateTime now = DateTime.now();

          if (task.note - 1 == now.weekday) {
            todayList.add(task);
            if (now.hour >= DateTime.parse(task.timeStart).hour &&
                now.hour <= DateTime.parse(task.timeEnd).hour) {
              nowList.add(task);
            }
          }
        }
        if (todayList.isNotEmpty) {
          yield LoadedTaskOfSchedule(todayList,nowList);
        } else
          yield LoadErrorTaskOfSchedule('Chưa có lịch học cụ thể');
        break;
      default:
    }
  }
}
