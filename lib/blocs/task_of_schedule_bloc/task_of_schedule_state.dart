import 'package:equatable/equatable.dart';
import 'package:utc2_student/service/firestore/schedule_student.dart';

abstract class TaskOfScheduleState extends Equatable {
  const TaskOfScheduleState();

  @override
  List<Object> get props => [];
}

class TaskOfScheduleInitial extends TaskOfScheduleState {}

class LoadingTaskOfSchedule extends TaskOfScheduleState {}

class LoadedTaskOfSchedule extends TaskOfScheduleState {
  final List<TaskOfSchedule> list, nowList;
  LoadedTaskOfSchedule(this.list,this.nowList);
}

class LoadErrorTaskOfSchedule extends TaskOfScheduleState {
  final String error;
  LoadErrorTaskOfSchedule(this.error);
}
