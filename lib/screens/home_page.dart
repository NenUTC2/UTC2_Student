import 'dart:math';

import 'package:utc2_student/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:circular_check_box/circular_check_box.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController =
      PageController(initialPage: 0, viewportFraction: 0.85);
  final ValueNotifier<int> _pageNotifier = new ValueNotifier<int>(0);
  List subTask = [
    {'title': 'Báo Cáo', 'isComplete': true},
    {'title': 'Khảo sát ý kiến', 'isComplete': false},
    {'title': 'Tổng kết', 'isComplete': true},
    {'title': 'Trình bày', 'isComplete': false}
  ];
  List user = [
    'https://images.pexels.com/photos/1987042/pexels-photo-1987042.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    'https://scontent.fsgn2-5.fna.fbcdn.net/v/t1.6435-9/132520813_846603219451783_6386312700226999104_n.jpg?_nc_cat=106&ccb=1-3&_nc_sid=09cbfe&_nc_ohc=o4rFjC9w9mAAX8uytLC&_nc_ht=scontent.fsgn2-5.fna&oh=4c8653b5d4079ba4db437c5a09f2f239&oe=6091F89D'
  ];
  final _scrollController = ScrollController();
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
            ColorApp.lightBlue,
            ColorApp.mediumBlue,
            ColorApp.lightBlue,
            ColorApp.lightBlue,
            ColorApp.mediumBlue,
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
                style: TextStyle(color: ColorApp.blue),
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
                      'Tham gia họp báo',
                      style: TextStyle(
                          color: ColorApp.mediumBlue,
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
                              color: ColorApp.blue,
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: ColorApp.lightBlue.withOpacity(.1)),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.place,
                                  color: ColorApp.lightBlue,
                                  size: 16,
                                ),
                                Text(
                                  'C1',
                                  style: TextStyle(
                                    color: ColorApp.blue,
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: ColorApp.lightBlue.withOpacity(.1)),
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
                              leading: CircularCheckBox(
                                value: subTask[i]['isComplete'],
                                activeColor: ColorApp.mediumBlue,
                                checkColor: ColorApp.lightGrey,
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
                    FlatButton.icon(
                      height: 10,
                      onPressed: () {},
                      icon: Icon(
                        Icons.add,
                        color: ColorApp.blue,
                      ),
                      label: Text(
                        "Thêm mô tả",
                        style: TextStyle(color: ColorApp.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget taskToday(Size size, PageController pageController,
      ValueNotifier<int> _pageNotifier) {
    return Container(
      // color: ColorApp.mediumBlue,
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
                child: PageView(
                  physics: BouncingScrollPhysics(),
                  controller: pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _pageNotifier.value = index;
                    });
                  },
                  children: List.generate(3, (index) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            padding: EdgeInsets.only(left: 5),
                            color: Colors.primaries[
                                Random().nextInt(Colors.primaries.length)],
                            child: Container(
                              padding: EdgeInsets.all(size.width * 0.03),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 3,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 5), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Trí Tuệ Nhân Tạo',
                                    style: TextStyle(
                                        color: ColorApp.mediumBlue,
                                        fontSize: size.width * 0.045,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          '07:00 -11:30',
                                          style: TextStyle(
                                            color: Colors.orange,
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.orangeAccent
                                                .withOpacity(.1)),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.place,
                                              color: ColorApp.lightBlue,
                                              size: 16,
                                            ),
                                            Text(
                                              '6E10',
                                              style: TextStyle(
                                                color: ColorApp.blue,
                                              ),
                                            ),
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: ColorApp.lightBlue
                                                .withOpacity(.1)),
                                      ),
                                    ],
                                  ),
                                  // Spacer(),
                                  Expanded(
                                    child: Container(
                                      width: size.width,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: List.generate(user.length,
                                                (index) {
                                              return Align(
                                                widthFactor: 0.4,
                                                alignment: Alignment.bottomLeft,
                                                child: Container(
                                                  width: 35,
                                                  decoration: BoxDecoration(
                                                      color: ColorApp.lightGrey,
                                                      shape: BoxShape.circle),
                                                  padding: EdgeInsets.all(2),
                                                  child: CircleAvatar(
                                                    radius: 20.0,
                                                    backgroundImage:
                                                        NetworkImage(
                                                            user[index]),
                                                    child:
                                                        index == user.length - 1
                                                            ? Text('12')
                                                            : Container(),
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),
                                          ElevatedButton(
                                              child: Text("Vào lớp",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      letterSpacing: 1,
                                                      wordSpacing: 1,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              style: ButtonStyle(
                                                  foregroundColor:
                                                      MaterialStateProperty.all<Color>(
                                                          Colors.white),
                                                  backgroundColor:
                                                      MaterialStateProperty.all<Color>(
                                                          ColorApp.mediumBlue),
                                                  shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                          side: BorderSide(color: Colors.red)))),
                                              onPressed: () => null)
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    );
                  }),
                ),
              )
            ],
          ),
          Center(
            child: DotsIndicator(
              dotsCount: 3,
              mainAxisAlignment: MainAxisAlignment.center,
              position: _pageNotifier.value.toDouble(),
              decorator: DotsDecorator(
                color: Colors.white, // Inactive color
                activeColor: ColorApp.lightBlue,
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
