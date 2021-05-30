import 'package:utc2_student/blocs/register_bloc/register_event.dart';
import 'package:utc2_student/blocs/register_bloc/register_state.dart';
import 'package:utc2_student/repositories/user_repository.dart';
import 'package:utc2_student/utils/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {

  RegisterBloc()
      : 
        super(RegisterState.initial());

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterEmailChanged) {
      yield* _mapRegisterEmailChangeToState(event.email);
    } else if (event is RegisterPasswordChanged) {
      yield* _mapRegisterPasswordChangeToState(event.password);
    } else if (event is RegisterSubmitted) {
      yield* _mapRegisterSubmittedToState(
          email: event.email, password: event.password);
    }
  }

  Stream<RegisterState> _mapRegisterEmailChangeToState(String email) async* {
    yield state.update(isEmailValid: Validators.isValidEmail(email));
  }

  Stream<RegisterState> _mapRegisterPasswordChangeToState(
      String password) async* {
    yield state.update(isPasswordValid: true);
  }

  Stream<RegisterState> _mapRegisterSubmittedToState(
      {String email, String password}) async* {
    yield RegisterState.loading();
    try {
      await UserRepository.signUp(email, password);
      yield RegisterState.success();
    } catch (error) {
      print(error);
      yield RegisterState.failure();
    }
  }
}
