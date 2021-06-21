import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utc2_student/blocs/class_bloc/class_bloc.dart';
import 'package:utc2_student/screens/classroom/class_detail_screen.dart';
import 'package:utc2_student/service/firestore/class_database.dart';
import 'package:utc2_student/service/firestore/student_database.dart';
import 'package:utc2_student/utils/color_random.dart';
import 'package:utc2_student/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:utc2_student/widgets/loading_widget.dart';

class ActivityPage extends StatefulWidget {
  final Student student;

  const ActivityPage({Key key, this.student}) : super(key: key);
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  ClassDatabase classDatabase = ClassDatabase();
  bool isErro = false;
  TextEditingController _controller = TextEditingController();
  List activity = [
    // {
    //   'title': 'Đồ án tốt nghiệp',
    //   'name': 'Phạm Thị Miên',
    //   'subAct': ['Báo Cáo tiến độ']
    // },
    // {
    //   'title': 'AI.GTVT.2.20-21',
    //   'name': 'Nguyễn Đình Hiển',
    //   'subAct': [
    //     'BT1 (Nhóm) : Tìm hiểu về AI',
    //     'BT2 (Nhóm) : Thuật Giải Heuristic',
    //     'BT3 (Nhóm) : Phương pháp tìm kiếm'
    //   ]
    // },
    // {
    //   'title': 'Phân tích thiết kế hướng đối tượng (k58-utc2)',
    //   'name': 'Nguyễn Quang Phúc',
    //   'subAct': []
    // },
    // {'title': 'data minning 20-21', 'name': 'Trần Phong Nhã', 'subAct': []},
  ];
  Future _scan() async {
    await Permission.camera.request();
    String barcode = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Hủy", false, ScanMode.DEFAULT);
    if (barcode == null) {
      print('Không tìm thấy mã code');
    } else {
      Get.back();

      var dataClass = {'id': barcode.trim()};
      await StudentDatabase.joinClass(barcode.trim(), dataClass);
      classBloc.add(GetClassEvent());
    }
  }

  showNewClass(BuildContext context, String id) {
    Size size = MediaQuery.of(context).size;
    AlertDialog alert = AlertDialog(
      title: Center(child: Text('Tham gia lớp học mới'.toUpperCase())),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 50,
            width: size.width,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                autofocus: true,
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Mã lớp',
                  // errorText: isErro ? 'Vui lòng nhập mã' : null,
                ),
                autocorrect: true,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: size.width * 0.1, vertical: 10),
                child: Text(
                  "Tham gia",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              style: ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.padded,
                  shadowColor:
                      MaterialStateProperty.all<Color>(ColorApp.lightOrange),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(ColorApp.lightOrange),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(color: Colors.white)))),
              // color: ColorApp.lightOrange,
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(20)),
              onPressed: () async {
                if (_controller.text.length < 1) {
                  Get.snackbar('Thông báo', 'Nhập mã lớp',
                      snackPosition: SnackPosition.BOTTOM);
                } else {
                  Get.back();

                  var dataClass = {'id': _controller.text.trim()};
                  var result = await StudentDatabase.joinClass(
                      _controller.text.trim(), dataClass);
                  if (!result) {
                    Get.snackbar('Thông báo', 'Bạn đã tham gia lớp này',
                        snackPosition: SnackPosition.BOTTOM);
                  } else
                    classBloc.add(GetClassEvent());
                  _controller.clear();
                }
              },
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Hoặc quét mã Code',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 20,
          ),
          MaterialButton(
            onPressed: () {
              _scan();
            },
            color: ColorApp.lightOrange,
            textColor: Colors.white,
            child: Icon(
              Icons.qr_code_scanner_outlined,
              size: 24,
            ),
            padding: EdgeInsets.all(16),
            shape: CircleBorder(),
          )
        ],
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialog(BuildContext context, String name, String idClass) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Thoát"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Rời Khỏi"),
      onPressed: () {
        Navigator.pop(context);
        StudentDatabase.leaveClass(idClass);
        classBloc.add(GetClassEvent());
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(name),
      content: Text("Bạn có muốn rời khỏi lớp học này?"),
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
              return loadingWidget();
            else if (state is LoadedClass) {
              return Container(
                child: RefreshIndicator(
                  displacement: 20,
                  onRefresh: () async {
                    classBloc.add(GetClassEvent());
                  },
                  child: state.list.isEmpty
                      ? Center(
                          child: Text(
                            'Chưa có lớp học nào.',
                            style: TextStyle(color: Colors.black, fontSize: 17),
                          ),
                        )
                      : Scrollbar(
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
                                      [],
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
              return loadingWidget();
            }
          },
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            splashColor: ColorApp.orange.withOpacity(.4),
            hoverColor: ColorApp.lightGrey,
            foregroundColor: ColorApp.orange,
            onPressed: () {
              showNewClass(context, '3');
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
          // borderRadius: BorderRadius.only(
          //   topLeft: Radius.circular(10.0),
          //   topRight: Radius.circular(10.0),
          // ),
          borderRadius: BorderRadius.circular(10),
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
                          student: widget.student)));
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
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(10.0),
                //   topRight: Radius.circular(10.0),
                // ),
                borderRadius: BorderRadius.circular(6),
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
