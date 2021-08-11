import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:utc2_student/blocs/task_of_schedule_bloc/task_of_schedule_bloc.dart';
import 'package:utc2_student/blocs/task_of_schedule_bloc/task_of_schedule_state.dart';
import 'package:utc2_student/service/firestore/schedule_student.dart';
import 'package:utc2_student/utils/utils.dart';

class TodayTaskItem extends StatelessWidget {
  const TodayTaskItem({Key key, this.schedule}) : super(key: key);
  final Schedule schedule;

  @override
  Widget build(BuildContext context) {
    TaskOfScheduleBloc taskBloc;
    taskBloc = BlocProvider.of<TaskOfScheduleBloc>(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: BlocBuilder<TaskOfScheduleBloc, TaskOfScheduleState>(
        builder: (context, state) {
          if (state is LoadingTaskOfSchedule)
            return Center(
                child: SpinKitThreeBounce(
              color: Colors.orange,
              size: 30,
            ));
          if (state is LoadedTaskOfSchedule)
            return Container(
              child: Column(
                children: List.generate(
                  state.list.length,
                  (index) => Container(
                    margin: EdgeInsets.only(bottom: 15),
                    padding: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(color: Colors.black45, blurRadius: 2)
                        ],
                        color: Colors.primaries[
                            Random().nextInt(Colors.primaries.length)],
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ////Name
                          Text(
                            schedule.titleSchedule,
                            style: TextStyle(
                                color: ColorApp.mediumOrange,
                                fontSize: 20,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w600),
                          ),
                          ////End name
                          ///

                          SizedBox(
                            height: 15,
                          ),

                          ////Time & Room
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Thứ ' +
                                        (state.list[index].note).toString(),
                                    style: TextStyle(
                                      color: ColorApp.black,
                                    ),
                                  ),
                                  Text(
                                    state.list[index].titleTask,
                                    style: TextStyle(
                                      color: ColorApp.black,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      'Now, ' +
                                          formatTime(
                                              state.list[index].timeStart) +
                                          '-' +
                                          formatTime(state.list[index].timeEnd),
                                      style: TextStyle(
                                        color: ColorApp.orange,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: ColorApp.lightOrange
                                            .withOpacity(.1)),
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
                                            state.list[index].idRoom,
                                            style: TextStyle(
                                              color: ColorApp.orange,
                                            ),
                                          ),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: ColorApp.lightOrange
                                              .withOpacity(.1)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          else
            return Container();
        },
      ),
    );
  }
}
