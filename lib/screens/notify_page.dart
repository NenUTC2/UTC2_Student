import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:utc2_student/utils/utils.dart';
import 'package:flutter/material.dart';

class NotifyPage extends StatefulWidget {
  @override
  _NotifyPageState createState() => _NotifyPageState();
}

class _NotifyPageState extends State<NotifyPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          //elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Thông báo',
            style: TextStyle(color: ColorApp.black),
          ),
          bottom: PreferredSize(
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
                  unselectedLabelColor: Colors.grey[600],
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
                          'Thông báo',
                        ),
                      ),
                    ),
                    Tab(
                      icon: Container(
                        child: Center(child: Text('Sự kiện')),
                      ),
                    ),
                    Tab(
                      icon: Container(
                        child: Center(child: Text('Lớp học')),
                      ),
                    ),
                  ],
                ),
              )),
        ),
        body: TabBarView(
          physics: BouncingScrollPhysics(),
          children: [
            Container(
              height: size.height,
              padding: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      stops: [0.2, 0.9],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white, ColorApp.lightGrey])),
              child: Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      color: ColorApp.orange,
                      displacement: 40,
                      onRefresh: () {
                        print('adad');
                      },
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Container(
                              width: size.width,
                              height: size.height * 0.1,
                              margin: EdgeInsets.only(bottom: 20),
                              child: FlatButton(
                                onPressed: () {
                                  _showBottomSheet(
                                      context,
                                      size,
                                      'Lễ tốt nghiệp',
                                      'Lễ trao bằng tốt nghiệp Đại học tháng 4 năm 2021Lễ trao bằng tốt nghiệp Đại học tháng 4 năm 2021');
                                },
                                splashColor: ColorApp.orange.withOpacity(.4),
                                highlightColor: ColorApp.lightGrey,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                        flex: 3,
                                        child: leading(size, '11-04-2021')),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      flex: 7,
                                      child: title(
                                          'Lễ trao bằng tốt nghiệp Đại học tháng 4 năm 2021Lễ trao bằng tốt nghiệp Đại học tháng 4 năm 2021'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ),
            // Container(),
            Container(
              child: Text('Sự kiện'),
            ),
            Container(
              child: Text('Lớp học'),
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(
      BuildContext context, Size size, String title, String description) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.001),
            child: GestureDetector(
              onTap: () {},
              child: DraggableScrollableSheet(
                initialChildSize: 0.4,
                minChildSize: 0.2,
                maxChildSize: 0.85,
                builder: (_, controller) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20.0),
                        topRight: const Radius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Center(
                            child: Container(
                          margin: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: ColorApp.grey,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(3),
                              topRight: const Radius.circular(3),
                            ),
                          ),
                          height: 3,
                          width: 50,
                        )),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Center(
                            child: Text(
                              title,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 0.5,
                          height: 5,
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: controller,
                            itemCount: 1,
                            itemBuilder: (_, index) {
                              return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  // child:
                                  child: Text(
                                    description,
                                  ));
                            },
                          ),
                        ),
                        // FlatButton(
                        //   minWidth: size.width,
                        //   height: size.height * 0.08,
                        //   color: Color(0xff1976D3),
                        //   onPressed: () {
                        //     Navigator.pop(context);
                        //   },
                        //   child: Text(
                        //     'ĐÓNG',
                        //     style: TextStyle(
                        //         color: Colors.white,
                        //         fontSize: size.width * 0.05),
                        //   ),
                        // )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget title(String title) {
  return Container(
    child: Text(
      title,
      maxLines: 3,
      style: TextStyle(fontSize: 19),
      softWrap: true,
      overflow: TextOverflow.ellipsis,
    ),
  );
}

Widget leading(Size size, String date) {
  return Container(
    alignment: Alignment.center,
    // width: size.width * 0.22,
    decoration: BoxDecoration(
        border: Border(
          left: BorderSide(width: 5.0, color: ColorApp.red),
        ),
        gradient: LinearGradient(
            stops: [0.2, 0.9],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [ColorApp.lightOrange, ColorApp.mediumOrange])),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          date.split('-')[0],
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          date.split('-')[1] + "/" + date.split('-')[2],
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ],
    ),
  );
}
