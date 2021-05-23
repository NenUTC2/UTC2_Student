import 'dart:ui';
import 'package:utc2_student/screens/activity_page.dart';
import 'package:utc2_student/screens/notify_page.dart';
import 'package:utc2_student/screens/schedule_page.dart';
import 'package:utc2_student/screens/web_view.dart';
import 'package:utc2_student/utils/custom_glow.dart';
import 'package:utc2_student/screens/home_page.dart';
import 'package:utc2_student/screens/profile_page.dart';
import 'package:utc2_student/utils/utils.dart';
import 'package:utc2_student/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget utc2 = HomePage();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: _selectedIndex == 0 || _selectedIndex == 3
            ? AppBar(
                centerTitle: true,
                elevation: 10,
                backgroundColor: Colors.white,
                title: Text(
                  'Phan Thành Nên',
                  style: TextStyle(color: ColorApp.black),
                ),
                leading: Builder(
                  builder: (context) => // Ensure Scaffold is in context
                      IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: ColorApp.black,
                          ),
                          onPressed: () => Scaffold.of(context).openDrawer()),
                ),
                actions: [
                  Builder(
                    builder: (context) => Container(
                      margin: EdgeInsets.only(right: size.width * 0.03),
                      width: 40,
                      child: GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                        child: CustomAvatarGlow(
                          glowColor: Colors.blue,
                          endRadius: 20.0,
                          duration: Duration(milliseconds: 1000),
                          repeat: true,
                          showTwoGlows: true,
                          repeatPauseDuration: Duration(milliseconds: 100),
                          child: Container(
                            padding: EdgeInsets.all(4),
                            child: CircleAvatar(
                              backgroundColor: ColorApp.lightGrey,
                              backgroundImage: NetworkImage(
                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/4/40/A-small_glyphs.svg/227px-A-small_glyphs.svg.png"),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            : null,
        drawer: CustomDrawer(linkWeb: (link) {
          setState(() {
            utc2 = Container(
              height: size.height,
              width: size.width,
              color: Colors.white,
            );
          });
          Future.delayed(Duration(milliseconds: 300), () {
            setState(() {
              utc2 = new WebUTC2(link: link);
            });
          });
        }),
        endDrawer: Drawer(child: ProFilePage()),
        body: SizedBox.expand(
          child: IndexedStack(
            index: _selectedIndex,
            children: <Widget>[
              utc2,
              NotifyPage(),
              SchedulePage(),
              ActivityPage(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _selectedIndex,
          showElevation: true, // use this to remove appBar's elevation
          onItemSelected: (index) => setState(() {
            _selectedIndex = index;
            utc2 = Container();
            utc2 = HomePage();

            // duration: Duration(milliseconds: 300), curve: Curves.ease);
          }),
          items: [
            BottomNavyBarItem(
                icon: Icon(Icons.home_rounded),
                title: Text('Trang chủ'),
                activeColor: Colors.orange[700],
                inactiveColor: ColorApp.black),
            BottomNavyBarItem(
                icon: Icon(
                  Icons.notifications,
                ),
                title: Text('Thông báo'),
                activeColor: Colors.orange[700],
                inactiveColor: ColorApp.black),
            BottomNavyBarItem(
                icon: Icon(Icons.date_range),
                title: Text('Lịch trình'),
                activeColor: Colors.orange[700],
                inactiveColor: ColorApp.black),
            BottomNavyBarItem(
                icon: Icon(Icons.stacked_line_chart_rounded),
                title: Text('Hoạt động'),
                activeColor: Colors.orange[700],
                inactiveColor: ColorApp.black),
          ],
        ));
  }
}
