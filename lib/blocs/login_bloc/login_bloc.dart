import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:utc2_student/repositories/google_signin_repo.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());
  GoogleSignInRepository _googleSignIn = GoogleSignInRepository();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    switch (event.runtimeType) {
      case SignInEvent:
        yield SigningState();
        var login = await _googleSignIn.signIn();
        if (login != null) {
          yield SignedInState();
        } else
          yield SignInErrorState();

        break;
      default:
    }
  }
}
