import 'package:equatable/equatable.dart';
import 'package:utc2_student/service/firestore/file_database.dart';

abstract class FileState extends Equatable {
  const FileState();

  @override
  List<Object> get props => [];
}

class FileInitial extends FileState {}

class LoadingFile extends FileState {}

class LoadedFile extends FileState {
  final List<File> list;
  LoadedFile(this.list);
}

class LoadErrorFile extends FileState {
  final String error;
  LoadErrorFile(this.error);
}
