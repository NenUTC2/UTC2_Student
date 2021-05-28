part of 'class_bloc.dart';

abstract class ClassState extends Equatable {
  const ClassState();

  @override
  List<Object> get props => [];
}

class ClassInitial extends ClassState {}

class LoadingClass extends ClassState {}

class LoadedClass extends ClassState {
  final List<Class> list;

  LoadedClass(this.list);
}

class LoadErrorClass extends ClassState {
  final String error;

  LoadErrorClass(this.error);
}
