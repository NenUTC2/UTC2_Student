import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utc2_student/repositories/google_signin_repo.dart';
import 'package:utc2_student/service/firestore/student_database.dart';
import 'package:utc2_student/utils/utils.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());

  final studentDB = StudentDatabase();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    switch (event.runtimeType) {
      case SignInEvent:
        GoogleSignInRepository _googleSignIn = GoogleSignInRepository();
        yield SigningState();
        var login = await _googleSignIn.signIn();

        if (login != null) {
          bool isRegister = await StudentDatabase.isRegister(login.email);
          yield SignedInState(login, isRegister);
        } else
          yield SignInErrorState();

        break;
      case EnterSIDEvent:
        yield UpdatingSIDState();
        GoogleSignInAccount ggLogin = event.props[0];
        Map<String, String> dataStudent = {
          'id': event.props[1],
          'name': ggLogin.displayName,
          'email': ggLogin.email,
          'avatar': ggLogin.photoUrl,
          'token': '',
        };
        try {
          await studentDB.createStudent(dataStudent, event.props[1]);
        } catch (e) {
          print('Lỗi =====>' + e.toString());
        }
        yield EnteredSIDState();
        break;
      default:
    }
  }
}
