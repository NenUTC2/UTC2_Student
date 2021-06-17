import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:utc2_student/blocs/question_bloc/question_event.dart';
import 'package:utc2_student/blocs/question_bloc/question_state.dart';
import 'package:utc2_student/service/firestore/quiz_database.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  QuestionBloc() : super(QuestionInitial());
  List<Question> list = [];
  @override
  Stream<QuestionState> mapEventToState(
    QuestionEvent event,
  ) async* {
    switch (event.runtimeType) {
      case GetQuestionEvent:
        yield LoadingQuestion();
        list =
            await QuizDatabase.getQuestionData(event.props[0], event.props[1]);
        if (list.isNotEmpty) {
          yield LoadedQuestion(list);
        } else
          yield LoadErrorQuestion('Chưa có câu hỏi nào');
        break;
      default:
    }
  }
  //Random
  // List<Question> sapXepGiamDan(List<Question> list) {
  //   list.sort((a, b) => a.dateCreate.compareTo(b.dateCreate));
  //   return list.reversed.toList();
  // }
}
