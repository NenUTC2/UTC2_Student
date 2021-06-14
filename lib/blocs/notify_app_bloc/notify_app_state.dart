import 'package:equatable/equatable.dart';
import 'package:utc2_student/service/firestore/notify_app_database.dart';

abstract class NotifyAppState extends Equatable {
  const NotifyAppState();

  @override
  List<Object> get props => [];
}

class NotifyAppInitial extends NotifyAppState {}

class LoadingNotifyApp extends NotifyAppState {}

class LoadedNotifyApp extends NotifyAppState {
  final List<NotifyApp> list;
  LoadedNotifyApp(this.list);
}

class LoadErrorNotifyApp extends NotifyAppState {
  final String error;
  LoadErrorNotifyApp(this.error);
}
