import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:utc2_student/utils/color_random.dart';

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
      List monHoc = [
        {
          "id": "1",
          "userId": "userId 1",
          "TenMon": "Lập trình di động",
          "StartDate": "2021-05-01",
          "EndDate": "2021-06-06"
        },
        {
          "id": "2",
          "userId": "userId 1",
          "TenMon": "Trí tuệ nhân tạo",
          "StartDate": "2021-05-01",
          "EndDate": "2021-05-30"
        },
      ];
      List lichHoc = [
        {
          "id": "1",
          "MonHocId": "1",
          "StartTime": "07:30",
          "EndTime": "11:00",
          "WeekDay": 3,
          "Room": "101C2"
        },
        {
          "id": "1",
          "MonHocId": "1",
          "StartTime": "13:30",
          "EndTime": "17:00",
          "WeekDay": 1,
          "Room": "201C2"
        },
        {
          "id": "2",
          "MonHocId": "2",
          "StartTime": "13:30",
          "EndTime": "17:00",
          "WeekDay": 5,
          "Room": "Room 1"
        },
      ];

      final DateTime today = DateTime.now();

      for (int i = 0; i < monHoc.length; i++) {
        DateTime endDate = DateTime.parse(monHoc[i]['EndDate'] + ' 23:59:00');
        DateTime startDate =
            DateTime.parse(monHoc[i]['StartDate'] + ' 00:00:00');

        //Neu mon hoc chua ket thuc
        if (endDate.difference(today).inDays >= 0) {
          ///Chay for lichHoc
          for (int j = 0; j < lichHoc.length; j++) {
            DateTime date = startDate;

            ///Bien tam cua StartDate

            ///startDate to EndDate
            for (int d = 0; d < endDate.difference(startDate).inDays; d++) {
              date = date.add(Duration(days: 1));

              //Kiem tra Week day va id Mon hoc
              if (date.weekday == lichHoc[j]['WeekDay'] &&
                  lichHoc[j]['MonHocId'] == monHoc[i]['id']) {
                final _random = new Random();

                DateTime startTime = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    int.parse(
                        lichHoc[j]['StartTime'].toString().substring(0, 2)),
                    int.parse(lichHoc[j]['StartTime'].toString().substring(3)));

                DateTime endTime = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    int.parse(lichHoc[j]['EndTime'].toString().substring(0, 2)),
                    int.parse(lichHoc[j]['EndTime'].toString().substring(3)));

                meetings.add(Meeting(
                    monHoc[i]['TenMon'] + '\n\n' + lichHoc[j]['Room'],
                    startTime,
                    endTime,
                    ColorRandom
                        .colors[_random.nextInt(ColorRandom.colors.length)][0],
                    false));
              }
            }
          }
        }
      }

      // final DateTime startTime =
      //     DateTime(today.year, today.month, today.day + 1, 7, 0, 0);

      // final DateTime endTime = startTime.add(const Duration(hours: 4));

      // meetings.add(Meeting('Lập trình di động\n 204E7', startTime, endTime,
      //     ColorApp.lightBlue, false));

      ///Return
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
                fontSize: 10,
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
