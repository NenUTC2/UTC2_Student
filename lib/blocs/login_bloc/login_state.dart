part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class SigningState extends LoginState {}

class SignedInState extends LoginState {}

class SignInErrorState extends LoginState {}
