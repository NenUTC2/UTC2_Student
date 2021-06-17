import 'package:equatable/equatable.dart';

abstract class QuestionEvent extends Equatable {
  const QuestionEvent();

  @override
  List<Object> get props => [];
}

class GetQuestionEvent extends QuestionEvent {
  final String idTeacher;
  final String idQuiz;

  GetQuestionEvent(this.idTeacher, this.idQuiz);
  @override
  List<Object> get props => [idTeacher, idQuiz];
}
