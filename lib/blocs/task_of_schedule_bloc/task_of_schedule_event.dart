import 'package:equatable/equatable.dart';

abstract class TaskOfScheduleEvent extends Equatable {
  const TaskOfScheduleEvent();

  @override
  List<Object> get props => [];
}

class GetTaskOfScheduleEvent extends TaskOfScheduleEvent {
  final String idTeacher,idSchedule;

  GetTaskOfScheduleEvent(this.idTeacher,this.idSchedule);
  @override
  List<Object> get props => [idTeacher,idSchedule];
}
