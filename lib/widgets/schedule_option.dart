import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:utc2_student/utils/utils.dart';

// ignore: must_be_immutable
class OpitonSchedule extends StatefulWidget {
  int view;
  OpitonSchedule({
    this.view,
  });
  @override
  _OpitonScheduleState createState() => _OpitonScheduleState();
}

class _OpitonScheduleState extends State<OpitonSchedule> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Meeting> meetings;
    List<Meeting> _getDataSource() {
      meetings = <Meeting>[];
      final DateTime today = DateTime.now();
      final DateTime startTime =
          DateTime(today.year, today.month, today.day + 1, 7, 0, 0);
      final DateTime startTime1 =
          DateTime(today.year, today.month, today.day + 3, 7, 30, 0);
      final DateTime startTime2 =
          DateTime(today.year, today.month, today.day + 5, 7, 30, 0);
      final DateTime endTime = startTime.add(const Duration(hours: 4));
      final DateTime endTime1 = startTime1.add(const Duration(hours: 4));
      final DateTime endTime2 = startTime2.add(const Duration(hours: 4));
      meetings.add(Meeting('Lập trình di động\n 204E7', startTime, endTime,
          ColorApp.lightBlue, false));
      meetings.add(Meeting('Trí tuệ nhân tạo\n 204E7', startTime1, endTime1,
          ColorApp.lightBlue, false));
      meetings.add(Meeting(
          'PTTKHT\n 204E7', startTime2, endTime2, ColorApp.lightBlue, false));
      return meetings;
    }

    return Container(
      child: SfCalendar(
        view: widget.view == 0
            ? CalendarView.day
            : widget.view == 1
                ? CalendarView.week
                : CalendarView.month,
        dataSource: MeetingDataSource(_getDataSource()),
        allowedViews: <CalendarView>[
          CalendarView.day,
          CalendarView.week,
          CalendarView.month,
          CalendarView.workWeek,
          CalendarView.timelineDay,
          CalendarView.timelineWeek,
          CalendarView.timelineWorkWeek,
          CalendarView.timelineMonth
        ],
        resourceViewSettings: ResourceViewSettings(
            displayNameTextStyle: TextStyle(
                fontSize: 11,
                color: Colors.redAccent,
                fontStyle: FontStyle.italic)),

        allowViewNavigation: true,
        showDatePickerButton: true,
        showNavigationArrow: true,
        headerHeight: 50,
        todayHighlightColor: ColorApp.blue,
        appointmentTextStyle: TextStyle(fontSize: 15),

        // scheduleViewMonthHeaderBuilder: (BuildContext buildercontext,ScheduleView),
        monthViewSettings: MonthViewSettings(
            dayFormat: 'EEE',
            showTrailingAndLeadingDates: true,
            showAgenda: true,
            agendaStyle: AgendaStyle(
              appointmentTextStyle:
                  TextStyle(fontSize: 15, color: Colors.white),
            ),
            monthCellStyle: MonthCellStyle(
                leadingDatesTextStyle: TextStyle(color: ColorApp.red)),
            agendaItemHeight: 100,
            appointmentDisplayMode: MonthAppointmentDisplayMode.indicator),
        selectionDecoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: ColorApp.red, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          shape: BoxShape.rectangle,
        ),
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
