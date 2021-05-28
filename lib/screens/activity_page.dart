import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:utc2_student/blocs/class_bloc/class_bloc.dart';
import 'package:utc2_student/screens/classroom/class_detail_screen.dart';
import 'package:utc2_student/screens/classroom/new_class.dart';
import 'package:utc2_student/service/firestore/class_database.dart';
import 'package:utc2_student/utils/color_random.dart';
import 'package:utc2_student/utils/utils.dart';
import 'package:flutter/material.dart';

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  ClassDatabase classDatabase = ClassDatabase();
  List activity = [
    {
      'title': 'Đồ án tốt nghiệp',
      'name': 'Phạm Thị Miên',
      'subAct': ['Báo Cáo tiến độ']
    },
    {
      'title': 'AI.GTVT.2.20-21',
      'name': 'Nguyễn Đình Hiển',
      'subAct': [
        'BT1 (Nhóm) : Tìm hiểu về AI',
        'BT2 (Nhóm) : Thuật Giải Heuristic',
        'BT3 (Nhóm) : Phương pháp tìm kiếm'
      ]
    },
    {
      'title': 'Phân tích thiết kế hướng đối tượng (k58-utc2)',
      'name': 'Nguyễn Quang Phúc',
      'subAct': []
    },
    {'title': 'data minning 20-21', 'name': 'Trần Phong Nhã', 'subAct': []},
  ];

  showAlertDialog(BuildContext context, String name, String id) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Thoát"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Kết thúc"),
      onPressed: () {
        Navigator.pop(context);
        classDatabase.deleteClass(id);
        classBloc.add(GetClassEvent());
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(name),
      content: Text("Bạn có muốn rời khỏi lớp học này ?"),
      actions: [
        continueButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  var classBloc;
  @override
  void initState() {
    super.initState();
    classBloc = BlocProvider.of<ClassBloc>(context);
    classBloc.add(GetClassEvent());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        BlocBuilder<ClassBloc, ClassState>(
          builder: (context, state) {
            if (state is LoadingClass)
              return SpinKitChasingDots(
                color: ColorApp.blue,
              );
            else if (state is LoadedClass) {
              print('loaded');

              return Container(
                child: RefreshIndicator(
                  displacement: 20,
                  onRefresh: () async {
                    classBloc.add(GetClassEvent());
                  },
                  child: Scrollbar(
                    child: ListView.builder(
                      itemCount: state.list.length + 1,
                      physics: BouncingScrollPhysics(),
                      // itemCount: snapshot.data.length,
                      itemBuilder: ((context, index) {
                        return index == state.list.length
                            ? Container(
                                height: 200,
                              )
                            : customList(
                                size,
                                context,
                                state.list[index].name,
                                state.list[index].teacherId,
                                activity[1]['subAct'],
                                state.list[index].id,
                                state.list);
                      }),
                    ),
                  ),
                ),
              );
            } else if (state is LoadErrorClass) {
              return Center(
                child: Text(
                  state.error,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              );
            } else {
              return SpinKitChasingDots(
                color: ColorApp.blue,
              );
            }
          },
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            splashColor: ColorApp.blue.withOpacity(.4),
            hoverColor: ColorApp.lightGrey,
            foregroundColor: ColorApp.blue,
            onPressed: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NewClass()))
                  .then((value) => classBloc.add(GetClassEvent()));
            },
            child: Icon(Icons.add),
          ),
        )
      ],
    );
  }

  Widget customList(Size size, BuildContext context, String className,
      String teacherName, List sub, String id, List listClass) {
    return Container(
      margin: EdgeInsets.all(size.width * 0.03),
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          border: Border.all(color: ColorApp.lightGrey, width: 1.5)),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailClassScreen(
                            className: className,
                            listClass: listClass,
                            idClass: id,
                          )));
            },
            child: Container(
              height: 150,
              width: size.width,
              padding: EdgeInsets.all(size.width * 0.03),
              decoration: BoxDecoration(
                gradient: new LinearGradient(
                    colors: ColorRandom
                        .colors[Random().nextInt(ColorRandom.colors.length)],
                    stops: [0.0, 1.0],
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomRight,
                    tileMode: TileMode.repeated),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          className.toUpperCase(),
                          softWrap: true,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            showAlertDialog(
                                context, className.toUpperCase(), id);
                          },
                          icon: Icon(
                            Icons.more_horiz_rounded,
                            color: Colors.white,
                          )),
                    ],
                  ),
                  Text(
                    teacherName,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          sub.isNotEmpty
              ? Container(
                  width: size.width,
                  padding: EdgeInsets.all(size.width * 0.03),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.05),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      border: Border.all(color: ColorApp.lightGrey, width: 1)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(sub.length, (index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(sub[index].toString()),
                          index == sub.length - 1
                              ? Container()
                              : Divider(
                                  color: ColorApp.black,
                                )
                        ],
                      );
                    }),
                  ))
              : Container(),
        ],
      ),
    );
  }
}

