import 'package:equatable/equatable.dart';
import 'package:utc2_student/service/firestore/schedule_student.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class LoadingSchedule extends ScheduleState {}

class LoadingSchedulePage extends ScheduleState {}



class LoadedSchedulePage extends ScheduleState {
  final List<Schedule> listMon;
  final List<TaskOfSchedule> listLich;

  LoadedSchedulePage(this.listMon, this.listLich);
}

class LoadErrorSchedule extends ScheduleState {
  final String error;
  LoadErrorSchedule(this.error);
}
