import 'package:equatable/equatable.dart';

abstract class NotifyAppEvent extends Equatable {
  const NotifyAppEvent();

  @override
  List<Object> get props => [];
}

class GetNotifyAppEvent extends NotifyAppEvent {
  final String idUser;
 

  GetNotifyAppEvent(this.idUser);
  @override
  List<Object> get props => [idUser, ];
}
