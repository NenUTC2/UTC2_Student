import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utc2_student/repositories/google_signin_repo.dart';
import 'package:utc2_student/service/firestore/student_database.dart';
import 'package:utc2_student/utils/utils.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());
  GoogleSignInRepository _googleSignIn = GoogleSignInRepository();
  final studentDB = StudentDatabase();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    switch (event.runtimeType) {
      case SignInEvent:
        yield SigningState();
        var login = await _googleSignIn.signIn();
        bool isRegister = await StudentDatabase.isRegister(login.email);

        if (login != null) {
          if (!isRegister) {
            String idStudent = generateRandomString(5);
            Map<String, String> dataStudent = {
              'id': idStudent,
              'name': login.displayName,
              'studentId': '',
              'date': DateTime.now().toString(),
              'email': login.email,
              'avatar':login.photoUrl,
            };
            studentDB.createStudent(dataStudent, idStudent);
          }

          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('userEmail', login.email);
          yield SignedInState();
        } else
          yield SignInErrorState();

        break;
      default:
    }
  }
}
