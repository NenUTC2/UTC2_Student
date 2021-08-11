import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utc2_student/path_finder/repo_path.dart';
import 'package:utc2_student/screens/2d_map.dart';
import 'package:utc2_student/service/firestore/schedule_student.dart';
import 'package:utc2_student/utils/utils.dart';

class NowTaskItem extends StatelessWidget {
  const NowTaskItem({Key key, this.schedule, this.task}) : super(key: key);
  final Schedule schedule;
  final TaskOfSchedule task;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: EdgeInsets.only(left: 5),
            color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 5), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    schedule.titleSchedule,
                    style: TextStyle(
                        color: ColorApp.black,
                        fontSize: 15,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    task.titleTask,
                    style: TextStyle(
                        color: ColorApp.mediumOrange,
                        fontSize: 20,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Thứ ' + (task.note).toString()),
                        Text(task.titleTask),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          formatTime(task.timeStart) +
                              ' - ' +
                              formatTime(task.timeEnd),
                          style: TextStyle(
                            color: Colors.orange,
                          ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.orangeAccent.withOpacity(.1)),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(()=>Map2dScreen(),arguments: int.parse(task.idRoom));
                        },
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
                                listBuilding[int.parse(task.idRoom) - 1].name,
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
                ],
              ),
            ),
          )),
    );
  }
}
