import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utc2_student/blocs/schedule_bloc/schedule_bloc.dart';
import 'package:utc2_student/blocs/schedule_bloc/schedule_event.dart';
import 'package:utc2_student/blocs/schedule_bloc/schedule_state.dart';
import 'package:utc2_student/utils/utils.dart';
import 'package:utc2_student/widgets/loading_widget.dart';
import 'package:utc2_student/widgets/schedule_day.dart';
import 'package:utc2_student/widgets/schedule_option.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:utc2_student/widgets/schedule_week.dart';

class SchedulePage extends StatefulWidget {
   final String idStudent;

  const SchedulePage({Key key, this.idStudent}) : super(key: key);
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  ScheduleBloc scheduleBloc;
  @override
  void initState() {
    super.initState();
    scheduleBloc = BlocProvider.of<ScheduleBloc>(context);
    scheduleBloc.add(GetSchedulePageEvent(widget.idStudent));
  }
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
                preferredSize: Size(0, size.height * 0.12),
                child: Container(
                  margin: EdgeInsets.only(bottom: 10, top: 5),
                  width: size.width * 0.8,
                  height: size.height * 0.06,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: ColorApp.lightGrey),
                  child: TabBar(
                    physics: BouncingScrollPhysics(),
                    labelColor: Colors.white,
                    unselectedLabelColor: ColorApp.black,
                    indicatorColor: Colors.transparent,
                    indicator: new BubbleTabIndicator(
                      indicatorHeight: size.height * 0.05,
                      indicatorColor: ColorApp.mediumOrange,
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
          body: BlocBuilder<ScheduleBloc, ScheduleState>(
            builder: (context, state) {
              if (state is LoadedSchedulePage)
                return TabBarView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    OpitonScheduleDay(
                      listMon: state.listMon,
                      listLich: state.listLich,
                    ),
                    OpitonScheduleWeek(
                      listMon: state.listMon,
                      listLich: state.listLich,
                    ),
                    OpitonScheduleMonth(
                      listMon: state.listMon,
                      listLich: state.listLich,
                    ),
                  ],
                );
              else
                return loadingWidget();
            },
          )),
    );
  }
}
