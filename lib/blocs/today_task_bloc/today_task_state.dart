part of 'today_task_bloc.dart';

abstract class TodayTaskState extends Equatable {
  const TodayTaskState();

  @override
  List<Object> get props => [];
}

class TodayTaskInitial extends TodayTaskState {}

class TodayTaskLoading extends TodayTaskState {}

class TodayTaskError extends TodayTaskState {
  final String error;

  TodayTaskError(this.error);
}
class LoadedTodayTask extends TodayTaskState {
  final List<Schedule> list;
  LoadedTodayTask(this.list);
}
