import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:utc2_student/blocs/file_bloc/file_event.dart';
import 'package:utc2_student/blocs/file_bloc/file_state.dart';
import 'package:utc2_student/service/firestore/file_database.dart';
import 'package:utc2_student/service/firestore/post_database.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  FileBloc() : super(FileInitial());
  List<File> list = [];
  @override
  Stream<FileState> mapEventToState(
    FileEvent event,
  ) async* {
    switch (event.runtimeType) {
      case GetFileEvent:
        yield LoadingFile();
        list.clear();
        
        List<Post> listPost = event.props[1];
        for (int i = 0; i < listPost.length; i++) {
          var item =
              await FileDatabase.getFileData(event.props[0], listPost[i].id);
          list = list + item;
        }
        if (list.isNotEmpty) {
          yield LoadedFile(list);
        } else
          yield LoadErrorFile('Chưa có tệp đính kèm');
        break;
      default:
    }
  }
}
