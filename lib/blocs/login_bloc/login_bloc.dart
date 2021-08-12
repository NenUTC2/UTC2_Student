import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utc2_student/repositories/google_signin_repo.dart';
import 'package:utc2_student/scraper/student_info_scraper.dart';
import 'package:utc2_student/service/firestore/student_database.dart';
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

        SharedPreferences prefs = await SharedPreferences.getInstance();
        var login = await _googleSignIn.signIn();

        if (login != null) {
          bool isRegister = await StudentDatabase.isRegister(login.email);
          if (isRegister) {
            prefs.setString('userEmail', login.email);
            // print('update');
            var student = await StudentDatabase.getStudentData(login.email);
            var studentInfo = await getThongTin(student.id);
            Map<String, String> data = {
              'id': student.id,
              'name': studentInfo.hoten,
              'email': login.email,
              'avatar': login.photoUrl,
              'token': prefs.getString('token'),
              'birthDate': studentInfo.ngaysinh,
              'birthPlace': studentInfo.noisinh,
              'heDaoTao': studentInfo.hedaotao,
              'lop': studentInfo.lop,
              'khoa': studentInfo.khoa,
            };
            StudentDatabase.updateStudentData(student.id, data);
            yield SignedInState(login, true);
          } else {
            String emailLen = 'st.utc2.edu.vn';
            int len = login.email.length - emailLen.length;

            if (login.email.substring(len) == emailLen) {
              SinhVien studentInfo =
                  await getThongTin(login.email.substring(0, len - 1));
              // print(login.email.substring(len) == emailLen);

              Map<String, String> dataStudent = {
                'id': login.email.substring(0, len - 1),
                'name': studentInfo.hoten,
                'email': login.email,
                'avatar': login.photoUrl,
                'token': prefs.getString('token'),
                'birthDate': studentInfo.ngaysinh,
                'birthPlace': studentInfo.noisinh,
                'heDaoTao': studentInfo.hedaotao,
                'lop': studentInfo.lop,
                'khoa': studentInfo.khoa,
              };
              try {
                await studentDB.createStudent(
                    dataStudent, login.email.substring(0, len - 1));
              } catch (e) {
                print('Lỗi =====>' + e.toString());
              }

              yield SignedInState(login, true);
            } else
              yield SignedInState(login, false);
          }
        } else
          yield SignInErrorState();

        break;
      case EnterSIDEvent:
        yield UpdatingSIDState();
        try {
          SinhVien studentInfo = await getThongTin(event.props[0]);
          yield EnteredSIDState(studentInfo);
        } catch (e) {
          yield WrongSIDState();
        }
        break;
      case SubmitSIDEvent:
        yield SubmittingSIDState();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        GoogleSignInAccount ggLogin = event.props[0];
        try {
          SinhVien studentInfo = await getThongTin(event.props[1]);
          Map<String, String> dataStudent = {
            'id': event.props[1],
            'name': studentInfo.hoten,
            'email': ggLogin.email,
            'avatar': ggLogin.photoUrl,
            'token': prefs.getString('token'),
            'birthDate': studentInfo.ngaysinh,
            'birthPlace': studentInfo.noisinh,
            'heDaoTao': studentInfo.hedaotao,
            'lop': studentInfo.lop,
            'khoa': studentInfo.khoa,
          };
          await studentDB.createStudent(dataStudent, event.props[1]);

          prefs.setString('userEmail', ggLogin.email);
          yield SubmittedSIDState();
        } catch (e) {
          yield WrongSIDState();
        }
        break;
      default:
    }
  }
}
