import 'package:equatable/equatable.dart';
import 'package:utc2_student/service/firestore/quiz_database.dart';

abstract class QuestionState extends Equatable {
  const QuestionState();

  @override
  List<Object> get props => [];
}

class QuestionInitial extends QuestionState {}

class LoadingQuestion extends QuestionState {}

class LoadedQuestion extends QuestionState {
  final List<Question> list;
  LoadedQuestion(this.list);
}

class LoadErrorQuestion extends QuestionState {
  final String error;
  LoadErrorQuestion(this.error);
}
