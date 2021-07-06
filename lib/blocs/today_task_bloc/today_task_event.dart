part of 'today_task_bloc.dart';

abstract class TodayTaskEvent extends Equatable {
  const TodayTaskEvent();

  @override
  List<Object> get props => [];
}
class GetTodayTaskEvent extends TodayTaskEvent {
  final String idTeacher;

  GetTodayTaskEvent(this.idTeacher);
  @override
  List<Object> get props => [idTeacher];
}
