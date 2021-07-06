import 'package:equatable/equatable.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object> get props => [];
}


class GetSchedulePageEvent extends ScheduleEvent {
  final String idStudent;

  GetSchedulePageEvent(this.idStudent);
  @override
  List<Object> get props => [idStudent];
}