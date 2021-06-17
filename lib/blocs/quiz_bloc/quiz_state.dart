import 'package:equatable/equatable.dart';
import 'package:utc2_student/service/firestore/quiz_database.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object> get props => [];
}

class QuizInitial extends QuizState {}

class LoadingQuiz extends QuizState {}

class LoadedQuiz extends QuizState {
  final List<Quiz> list;
  LoadedQuiz(this.list);
}

class LoadErrorQuiz extends QuizState {
  final String error;
  LoadErrorQuiz(this.error);
}
