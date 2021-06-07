part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class SignInEvent extends LoginEvent {}

class EnterSIDEvent extends LoginEvent {
  final String sID;

  EnterSIDEvent(this.sID);
  @override
  List<Object> get props => [this.sID];
}

class SubmitSIDEvent extends LoginEvent {
  final GoogleSignInAccount ggLogin;
  final String sID;

  SubmitSIDEvent(this.ggLogin, this.sID);
  @override
  List<Object> get props => [this.ggLogin, this.sID];
}

class SignOutEvent extends LoginEvent {}
