// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'package:utc2_student/service/firestore/schedule_teacher.dart';
// import 'package:utc2_student/service/local_notification.dart';
// import 'package:utc2_student/utils/color_random.dart';
// import 'package:utc2_student/utils/utils.dart';
// import 'package:utc2_student/widgets/schedule_option.dart';

// class OpitonScheduleDay extends StatefulWidget {
//   final List<Schedule> listMon;
//   final List<TaskOfSchedule> listLich;

//   const OpitonScheduleDay({Key key, this.listMon, this.listLich})
//       : super(key: key);
//   @override
//   _OpitonScheduleState createState() => _OpitonScheduleState();
// }

// class _OpitonScheduleState extends State<OpitonScheduleDay>
//     with AutomaticKeepAliveClientMixin {
//   final notifications = FlutterLocalNotificationsPlugin();
//   @override
//   void initState() {
//     super.initState();
//     // MyLocalNotification.configureLocalTimeZone();
//     final settingsAndroid = AndroidInitializationSettings('app_icon');

//     final settingsIOS = IOSInitializationSettings(
//         onDidReceiveLocalNotification: (id, title, body, payload) =>
//             onSelectNotification(payload));

//     notifications.initialize(
//         InitializationSettings(android: settingsAndroid, iOS: settingsIOS),
//         onSelectNotification: onSelectNotification);
//     notifications.cancelAll();
//     _getDataSource();
//   }

//   Future onSelectNotification(String payload) async {
//     print(payload);
//     // Get.to(DetailClassScreen());
//   }

//   List<Meeting> meetings;
//   List<Meeting> _getDataSource() {
//     meetings = <Meeting>[];
//     // List widget.listMon = [
//     //   {
//     //     "id": "1",
//     //     "userId": "userId 1",
//     //     "TenMon": "Lập trình di động",
//     //     "StartDate": "2021-05-01",
//     //     "EndDate": "2021-06-22"
//     //   },
//     //   {
//     //     "id": "2",
//     //     "userId": "userId 1",
//     //     "TenMon": "Trí tuệ nhân tạo",
//     //     "StartDate": "2021-05-01",
//     //     "EndDate": "2021-05-30"
//     //   },
//     // ];
//     // List widget.listLich = [
//     //   {
//     //     "id": "1",
//     //     "MonHocId": "1",
//     //     "StartTime": "07:30",
//     //     "EndTime": "11:00",
//     //     "WeekDay": 3,
//     //     "Room": "101C2"
//     //   },
//     //   {
//     //     "id": "2",
//     //     "MonHocId": "1",
//     //     "StartTime": "13:30",
//     //     "EndTime": "17:00",
//     //     "WeekDay": 1,
//     //     "Room": "201C2"
//     //   },
//     //   {
//     //     "id": "3",
//     //     "MonHocId": "2",
//     //     "StartTime": "13:30",
//     //     "EndTime": "17:00",
//     //     "WeekDay": 5,
//     //     "Room": "Room 1"
//     //   },
//     //   {
//     //     "id": "4",
//     //     "MonHocId": "1",
//     //     "StartTime": "08:30",
//     //     "EndTime": "12:00",
//     //     "WeekDay": 6,
//     //     "Room": "201C2"
//     //   },
//     // ];

//     int wd, sh, sm, eh, em;
//     int maMon, maLich;
//     String room, tenMon;

//     scheduleNoti() {
//       MyLocalNotification.scheduleWeeklyMondayTenAMNotification(
//           notifications, wd, sh, sm, eh, em, tenMon, room, maMon, maLich);
//     }

//     final DateTime today = DateTime.now();

//     for (int i = 0; i < widget.listMon.length; i++) {
//       DateTime endDate = DateTime.parse(widget.listMon[i].timeEnd);
//       DateTime startDate = DateTime.parse(widget.listMon[i].timeStart);

//       //Neu mon hoc chua ket thuc
//       if (endDate.difference(today).inDays >= 0) {
//         ///Chay for widget.listLich
//         for (int j = 0; j < widget.listLich.length; j++) {
//           DateTime date = startDate;

//           ///Bien tam cua StartDate

//           ///startDate to EndDate
//           for (int d = 0; d < endDate.difference(startDate).inDays; d++) {
//             date = date.add(Duration(days: 1));

//             wd = widget.listLich[j].note - 1;
//             //Kiem tra Week day va id Mon hoc
//             if (date.weekday == wd &&
//                 widget.listLich[j].idSchedule == widget.listMon[i].idSchedule) {
//               ///Timmmmmme
//               sh = DateTime.parse(widget.listLich[j].timeStart).hour;
//               sm = DateTime.parse(widget.listLich[j].timeStart).minute;
//               eh = DateTime.parse(widget.listLich[j].timeEnd).hour;
//               em = DateTime.parse(widget.listLich[j].timeEnd).minute;

//               //Mon
//               tenMon = widget.listMon[i].titleSchedule;
//               maMon =int.parse( widget.listMon[i].idSchedule);
//               maLich =int.parse(widget.listLich[j].idSchedule);
//               room = widget.listLich[j].idRoom;

//               DateTime startTime =
//                   DateTime(date.year, date.month, date.day, sh, sm);

//               DateTime endTime =
//                   DateTime(date.year, date.month, date.day, eh, em);

//               meetings.add(Meeting(tenMon + '\n\n' + room, startTime, endTime,
//                   ColorRandom.colors[maMon][0], false));
//               if (date.day == today.day &&
//                   date.month == today.month &&
//                   date.year == today.year) {
//                 if (sh > today.hour) {
//                   scheduleNoti();
//                 } else if (sh == today.hour) {
//                   if (sm > today.minute) {
//                     scheduleNoti();
//                   }
//                 }
//               } else {
//                 scheduleNoti();
//               }
//             }
//           }
//         }
//       }
//     }

//     // final DateTime startTime =
//     //     DateTime(today.year, today.month, today.day + 1, 7, 0, 0);

//     // final DateTime endTime = startTime.add(const Duration(hours: 4));

//     // meetings.add(Meeting('Lập trình di động\n 204E7', startTime, endTime,
//     //     ColorApp.lightBlue, false));

//     ///Return
//     return meetings;
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return Container(
//       child: SfCalendar(
//         view: CalendarView.day,
//         dataSource: MeetingDataSource(meetings),
//         allowedViews: <CalendarView>[
//           CalendarView.day,
//           CalendarView.week,
//           CalendarView.month,
//           CalendarView.workWeek,
//           CalendarView.timelineDay,
//           CalendarView.timelineWeek,
//           CalendarView.timelineWorkWeek,
//           CalendarView.timelineMonth
//         ],
//         resourceViewSettings: ResourceViewSettings(
//             displayNameTextStyle: TextStyle(
//                 fontSize: 10,
//                 color: Colors.redAccent,
//                 fontStyle: FontStyle.italic)),

//         allowViewNavigation: true,
//         showDatePickerButton: true,
//         showNavigationArrow: true,
//         headerHeight: 50,
//         todayHighlightColor: ColorApp.blue,
//         appointmentTextStyle: TextStyle(fontSize: 15),

//         // scheduleViewMonthHeaderBuilder: (BuildContext buildercontext,ScheduleView),
//         monthViewSettings: MonthViewSettings(
//             dayFormat: 'EEE',
//             showTrailingAndLeadingDates: true,
//             showAgenda: true,
//             agendaStyle: AgendaStyle(
//               appointmentTextStyle:
//                   TextStyle(fontSize: 15, color: Colors.white),
//             ),
//             monthCellStyle: MonthCellStyle(
//                 leadingDatesTextStyle: TextStyle(color: ColorApp.red)),
//             agendaItemHeight: 100,
//             appointmentDisplayMode: MonthAppointmentDisplayMode.indicator),
//         selectionDecoration: BoxDecoration(
//           color: Colors.transparent,
//           border: Border.all(color: ColorApp.red, width: 1),
//           borderRadius: const BorderRadius.all(Radius.circular(4)),
//           shape: BoxShape.rectangle,
//         ),
//       ),
//     );
//   }

//   @override
//   bool get wantKeepAlive => true;
// }
