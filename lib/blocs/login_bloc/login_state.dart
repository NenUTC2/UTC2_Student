part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class SigningState extends LoginState {}

class SignedInState extends LoginState {
  final GoogleSignInAccount ggLogin;
  final bool isRegister;

  SignedInState(this.ggLogin, this.isRegister);
}

class SignInErrorState extends LoginState {}

class UpdatingSIDState extends LoginState {}

class EnteredSIDState extends LoginState {}
