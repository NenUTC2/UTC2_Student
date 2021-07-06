import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:utc2_student/blocs/schedule_bloc/schedule_event.dart';
import 'package:utc2_student/blocs/schedule_bloc/schedule_state.dart';
import 'package:utc2_student/service/firestore/schedule_student.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc() : super(ScheduleInitial());
  @override
  Stream<ScheduleState> mapEventToState(
    ScheduleEvent event,
  ) async* {
    switch (event.runtimeType) {
      
      case GetSchedulePageEvent:
        yield* _mapGetSchedulePage(event);
        break;
      default:
    }
  }

  Stream<ScheduleState> _mapGetSchedulePage(ScheduleEvent event) async* {
    List<TaskOfSchedule> listAllLich = [];
    yield LoadingSchedule();
    List<Schedule> listMon = await ScheduleDatabase.getScheduleData(
      event.props[0],
    );
    if (listMon != null) {
      for (var mon in listMon) {
        List<TaskOfSchedule> listLich =
            await ScheduleDatabase.getTaskOfScheduleData(
          event.props[0],
          mon.idSchedule,
        );
        for (var task in listLich) {
          listAllLich.add(task);
        }
      }
      print(listAllLich.length);
      yield LoadedSchedulePage(listMon, listAllLich);
    } else
      yield LoadErrorSchedule('Chưa có lịch học nào');
  }
}
