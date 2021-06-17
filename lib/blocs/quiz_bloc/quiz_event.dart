import 'package:equatable/equatable.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object> get props => [];
}

class GetQuizEvent extends QuizEvent {
  final String idTeacher;

  GetQuizEvent(this.idTeacher);
  @override
  List<Object> get props => [idTeacher];
}

class Get1QuizEvent extends QuizEvent {
  final String idTeacher;
  final String idQuiz;

  Get1QuizEvent(this.idTeacher,this.idQuiz);
  @override
  List<Object> get props => [idTeacher,idQuiz];
}
