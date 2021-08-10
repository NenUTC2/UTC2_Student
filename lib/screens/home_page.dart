import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utc2_student/blocs/schedule_bloc/schedule_state.dart';
import 'package:utc2_student/blocs/task_of_schedule_bloc/task_of_schedule_bloc.dart';
import 'package:utc2_student/blocs/task_of_schedule_bloc/task_of_schedule_event.dart';
import 'package:utc2_student/blocs/task_of_schedule_bloc/task_of_schedule_state.dart';
import 'package:utc2_student/blocs/today_task_bloc/today_task_bloc.dart';
import 'package:utc2_student/service/firestore/student_database.dart';
import 'package:utc2_student/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:utc2_student/widgets/now_task_item.dart';
import 'package:utc2_student/widgets/today_task_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController =
      PageController(initialPage: 0, viewportFraction: 0.85);
  final ValueNotifier<int> _pageNotifier = new ValueNotifier<int>(0);
  List subTask = [
    {'title': 'Khảo sát ý kiến', 'isComplete': true},
    {'title': 'Họp nhóm', 'isComplete': true},
    {'title': 'Trình bày', 'isComplete': false}
  ];

  final _scrollController = ScrollController();
  TodayTaskBloc scheduleBloc;
  TaskOfScheduleBloc taskBloc;
  Student student;
  int lenght;
  getSchedule() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userEmail = prefs.getString('userEmail');
    student = await StudentDatabase.getStudentData(userEmail);
    scheduleBloc.add(GetTodayTaskEvent(student.id));
  }

  @override
  void initState() {
    getSchedule();
    scheduleBloc = BlocProvider.of<TodayTaskBloc>(context);
    taskBloc = BlocProvider.of<TaskOfScheduleBloc>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      // height: size.height,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomCenter,
        stops: [
          0.02,
          0.1,
          0.3,
          0.5,
          0.8,
          0.9,
        ],
        colors: [
          ColorApp.lightGrey,
          ColorApp.lightOrange,
          ColorApp.mediumOrange,
          ColorApp.lightOrange,
          ColorApp.lightOrange,
          ColorApp.mediumOrange,
        ],
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          taskToday(size, pageController, _pageNotifier),
          Expanded(
            child: taskThisTime(size),
          )
        ],
      ),
    );
  }

  Widget taskThisTime(Size size) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '   Lịch học hôm nay',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          BlocConsumer<TodayTaskBloc, TodayTaskState>(
              listener: (context, state) {
            if (state is LoadedTodayTask) {
              taskBloc.add(
                  GetTaskOfScheduleEvent(student.id, state.list[0].idSchedule));
            }
          }, builder: (context, state) {
            if (state is LoadingSchedule)
              return Center(
                  child: SpinKitThreeBounce(
                color: Colors.orange,
                size: 30,
              ));
            else if (state is LoadedTodayTask) {
              return Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ...List.generate(
                          state.list.length,
                          (index) => TodayTaskItem(
                                schedule: state.list[index],
                              )),
                      ////End time & room
                      ///
                    ],
                  ),
                ),
              );
            } else
              return Container();
          }),
        ],
      ),
    );
  }

  Widget taskToday(Size size, PageController pageController,
      ValueNotifier<int> _pageNotifier) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(size.width * 0.03),
            child: Text(
              'Lịch học hiện tại',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10),
                width: size.width,
                height: size.width / 2.2,
                child: BlocConsumer<TodayTaskBloc, TodayTaskState>(
                    listener: (context, state) {
                  // if (state is LoadedTodayTask) {
                  //   taskBloc.add(GetTaskOfScheduleEvent(
                  //       student.id, state.list[0].idSchedule));
                  // }
                }, builder: (context, state) {
                  if (state is LoadingSchedule)
                    return Center(
                        child: SpinKitThreeBounce(
                      color: Colors.orange,
                      size: 30,
                    ));
                  else if (state is LoadedTodayTask) {
                    return BlocConsumer<TaskOfScheduleBloc,
                        TaskOfScheduleState>(
                      listener: (context, stateTask) {
                        if (stateTask is LoadedTaskOfSchedule) {
                          lenght = stateTask.list.length;
                        }
                      },
                      builder: (context, stateTask) {
                        if (stateTask is LoadingTaskOfSchedule)
                          return Container(
                            child: Center(
                                child: SpinKitThreeBounce(
                              color: Colors.orange,
                              size: 30,
                            )),
                          );
                        else if (stateTask is LoadedTaskOfSchedule) {
                          lenght = stateTask.list.length;

                          return lenght == 0
                              ? Container()
                              : PageView(
                                  physics: BouncingScrollPhysics(),
                                  controller: pageController,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _pageNotifier.value = index;
                                    });
                                  },
                                  children: List.generate(
                                    stateTask.list.length,
                                    (index) {
                                      return NowTaskItem(
                                        schedule: state.list[0],
                                        task: stateTask.list[index],
                                      );
                                    },
                                  ));
                        } else if (stateTask is LoadErrorTaskOfSchedule) {
                          return Center(
                            child: Text(
                              stateTask.error,
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 16,
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            child: Center(
                                child: SpinKitThreeBounce(
                              color: Colors.orange,
                              size: 30,
                            )),
                          );
                        }
                      },
                    );
                  } else
                    return Container();
                }),
              ),
            ],
          ),
          // Center(
          //   child: DotsIndicator(
          //     dotsCount: lenght ?? 1,
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     position: _pageNotifier.value.toDouble(),
          //     decorator: DotsDecorator(
          //       color: Colors.white, // Inactive color
          //       activeColor: ColorApp.lightOrange,
          //       size: const Size.square(9.0),
          //       activeSize: const Size(18.0, 9.0),
          //       activeShape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(5.0)),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
