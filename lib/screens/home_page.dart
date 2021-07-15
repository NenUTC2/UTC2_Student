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
    return SingleChildScrollView(
      child: Container(
        height: size.height,
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
      ),
    );
  }

  Widget taskThisTime(Size size) {
    return Container(
      width: size.width,
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
        color: Colors.grey[100],
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
              Text('Công việc hiện tại'),
              Text(
                'All(1)',
                style: TextStyle(color: ColorApp.orange),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              width: size.width,
              padding: EdgeInsets.only(left: size.width * 0.01),
              decoration: BoxDecoration(
                  color: Colors
                      .primaries[Random().nextInt(Colors.primaries.length)],
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                width: size.width,
                padding: EdgeInsets.all(size.width * 0.03),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lập trình di động',
                      style: TextStyle(
                          color: ColorApp.mediumOrange,
                          fontSize: size.width * 0.05,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            'Now, 07:00 -11:30',
                            style: TextStyle(
                              color: ColorApp.orange,
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: ColorApp.lightOrange.withOpacity(.1)),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.place,
                                  color: ColorApp.lightOrange,
                                  size: 16,
                                ),
                                Text(
                                  '202C1',
                                  style: TextStyle(
                                    color: ColorApp.orange,
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: ColorApp.lightOrange.withOpacity(.1)),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: ColorApp.grey,
                    ),
                    Expanded(
                      child: Scrollbar(
                        isAlwaysShown: true,
                        controller: _scrollController,
                        radius: Radius.circular(10),
                        thickness: 2,
                        child: ListView.builder(
                          controller: _scrollController,
                          physics: BouncingScrollPhysics(),
                          itemCount: subTask.length,
                          itemBuilder: (context, i) {
                            return ListTile(
                              leading: Checkbox(
                                value: subTask[i]['isComplete'],
                                activeColor: ColorApp.mediumOrange,
                                checkColor: Colors.white,
                                shape: CircleBorder(),
                                onChanged: (value) {
                                  setState(() {
                                    subTask[i]['isComplete'] = value;
                                  });
                                },
                              ),
                              title: Text(subTask[i]['title'].toString()),
                            );
                          },
                        ),
                      ),
                    ),
                    // FlatButton.icon(
                    //   height: 10,
                    //   onPressed: () {},
                    //   icon: Icon(
                    //     Icons.add,
                    //     color: ColorApp.blue,
                    //   ),
                    //   label: Text(
                    //     "Thêm mô tả",
                    //     style: TextStyle(color: ColorApp.blue),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  String formatTime(String time) {
    DateTime parseDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(time);
    return DateFormat("HH:mm").format(parseDate);
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
              'Công việc hôm nay',
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
                    if (state is LoadedTodayTask) {
                      lenght = state.list.length;
                      taskBloc.add(GetTaskOfScheduleEvent(
                          student.id, state.list[0].idSchedule));
                    }
                  },
                  builder: (context, state) {
                    if (state is LoadingSchedule)
                      return Container(
                        child: Center(
                            child: SpinKitThreeBounce(
                          color: Colors.orange,
                          size: 30,
                        )),
                      );
                    else if (state is LoadedTodayTask) {
                      lenght = state.list.length;

                      return lenght == 0
                          ? Container()
                          : PageView(
                              physics: BouncingScrollPhysics(),
                              controller: pageController,
                              onPageChanged: (index) {
                                setState(() {
                                  _pageNotifier.value = index;
                                });
                                taskBloc.add(GetTaskOfScheduleEvent(
                                    student.id, state.list[index].idSchedule));
                              },
                              children: List.generate(
                                state.list.length,
                                (index) {
                                  return Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Container(
                                          padding: EdgeInsets.only(left: 5),
                                          color: Colors.primaries[Random()
                                              .nextInt(
                                                  Colors.primaries.length)],
                                          child: Container(
                                            padding: EdgeInsets.all(
                                                size.width * 0.03),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  spreadRadius: 3,
                                                  blurRadius: 7,
                                                  offset: Offset(0,
                                                      5), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  state.list[index]
                                                      .titleSchedule,
                                                  style: TextStyle(
                                                      color:
                                                          ColorApp.mediumOrange,
                                                      fontSize:
                                                          size.width * 0.045,
                                                      letterSpacing: 1,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                BlocBuilder<TaskOfScheduleBloc,
                                                    TaskOfScheduleState>(
                                                  builder:
                                                      (context, stateTask) {
                                                    if (state
                                                        is LoadingTaskOfSchedule)
                                                      return Container(
                                                          // child: Center(
                                                          //     child:
                                                          //         SpinKitThreeBounce(
                                                          //   color: Colors
                                                          //       .lightOrange,
                                                          //   size: size.width *
                                                          //       0.06,
                                                          // )),
                                                          );
                                                    else if (stateTask
                                                        is LoadedTaskOfSchedule) {
                                                      return Column(
                                                        children: List.generate(
                                                          stateTask.list.length,
                                                          (index1) => Column(
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            5),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text('Thứ ' +
                                                                        (stateTask.list[index1].note)
                                                                            .toString()),
                                                                    Text(stateTask
                                                                        .list[
                                                                            index1]
                                                                        .titleTask),
                                                                  ],
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(5),
                                                                    child: Text(
                                                                      formatTime(stateTask
                                                                              .list[
                                                                                  index1]
                                                                              .timeStart) +
                                                                          ' - ' +
                                                                          formatTime(stateTask
                                                                              .list[index1]
                                                                              .timeEnd),
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .orange,
                                                                      ),
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                5),
                                                                        color: Colors
                                                                            .orangeAccent
                                                                            .withOpacity(.1)),
                                                                  ),
                                                                  Container(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(5),
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .place,
                                                                          color:
                                                                              ColorApp.lightOrange,
                                                                          size:
                                                                              16,
                                                                        ),
                                                                        Text(
                                                                          stateTask
                                                                              .list[index1]
                                                                              .idRoom,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                ColorApp.orange,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                5),
                                                                        color: ColorApp
                                                                            .lightOrange
                                                                            .withOpacity(.1)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    } else if (stateTask
                                                        is LoadErrorTaskOfSchedule) {
                                                      return Center(
                                                        child: Text(
                                                          stateTask.error,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20),
                                                        ),
                                                      );
                                                    } else {
                                                      return Container(
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          5),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text('Thứ '),
                                                                  // Text(
                                                                  //     '          '),
                                                                ],
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              5),
                                                                  child: Text(
                                                                    '                      ',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .orange,
                                                                    ),
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      color: Colors
                                                                          .orangeAccent
                                                                          .withOpacity(
                                                                              .1)),
                                                                ),
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              5),
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .place,
                                                                        color: ColorApp
                                                                            .lightOrange,
                                                                        size:
                                                                            16,
                                                                      ),
                                                                      Text(
                                                                        '          ',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              ColorApp.orange,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      color: ColorApp
                                                                          .lightOrange
                                                                          .withOpacity(
                                                                              .1)),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                  );
                                },
                              ));
                    } else if (state is TodayTaskError) {
                      return Center(
                        child: Text(
                          state.error,
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
                ),
              )
            ],
          ),
          Center(
            child: DotsIndicator(
              dotsCount: lenght ?? 1,
              mainAxisAlignment: MainAxisAlignment.center,
              position: _pageNotifier.value.toDouble(),
              decorator: DotsDecorator(
                color: Colors.white, // Inactive color
                activeColor: ColorApp.lightOrange,
                size: const Size.square(9.0),
                activeSize: const Size(18.0, 9.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
