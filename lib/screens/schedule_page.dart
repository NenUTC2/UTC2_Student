import 'package:utc2_student/utils/utils.dart';
import 'package:utc2_student/widgets/schedule_option.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  width: size.width * 0.8,
                  height: size.height * 0.06,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: ColorApp.lightGrey),
                  child: TabBar(
                    physics: BouncingScrollPhysics(),
                    labelColor: Colors.white,
                    unselectedLabelColor: ColorApp.black,
                    indicatorColor: Colors.transparent,
                    indicator: new BubbleTabIndicator(
                      indicatorHeight: size.height * 0.05,
                      indicatorColor: ColorApp.mediumBlue,
                      tabBarIndicatorSize: TabBarIndicatorSize.tab,
                    ),
                    tabs: [
                      Tab(
                        icon: Container(
                          child: Text(
                            'Ngày',
                          ),
                        ),
                      ),
                      Tab(
                        icon: Container(
                          child: Text('Tuần'),
                        ),
                      ),
                      Tab(
                        icon: Container(
                          child: Text('Tháng'),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
          body: TabBarView(
            physics: BouncingScrollPhysics(),
            children: [
              OpitonSchedule(
                view: 0,
              ),
              OpitonSchedule(
                view: 1,
              ),
              OpitonSchedule(
                view: 2,
              ),
            ],
          )),
    );
  }
}
