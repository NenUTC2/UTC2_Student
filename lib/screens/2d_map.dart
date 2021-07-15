import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utc2_student/models/end_point.dart';
import 'package:utc2_student/path_finder/dijsktra.dart';
import 'package:utc2_student/path_finder/repo_path.dart';
import 'package:utc2_student/utils/utils.dart';
import 'package:utc2_student/widgets/positioned_widget.dart';
import 'package:utc2_student/widgets/raw_gesture_detector_widget.dart';

class Map2dScreen extends StatefulWidget {
  @override
  _Map2dScreenState createState() => _Map2dScreenState();
}

class _Map2dScreenState extends State<Map2dScreen>
    with SingleTickerProviderStateMixin {
  double x = 40, y = 200;
  double xdef = 40, ydef = 200;
  double step = 10, size = 20;
  TextEditingController _diemDauController;
  TextEditingController _diemCuoiController;
  String huong = '';
  int diemDau = 0, diemCuoi = 0;
  AnimationController _controller;
  Animation _animation;
  Path _path;
  List<int> listDiem = [];
  List<EndPoint> listSearchBuilding = listBuilding;

  @override
  void initState() {
    _diemDauController = TextEditingController();
    _diemCuoiController = TextEditingController();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 5000));
    super.initState();
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.repeat();
    _path = drawPath();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void search(String input) {
    var data = listBuilding
        .where((item) =>
            item.name != '' &&
            item.name.toLowerCase().contains(input.toLowerCase()))
        .toList();
    setState(() {
      listSearchBuilding = data;
    });
    print(listSearchBuilding[0].name);
  }

  Path drawPath() {
    Path path = Path();

    if (diemDau != 0 && diemCuoi != 0) {
      List<int> diem = Dijsktra.findPath(diemDau, diemCuoi);
      double prevX = 0;
      double prevY = 0;
      for (int i = 0; i < diem.length; i++) {
        for (int j = 0; j < listBuilding.length; j++) {
          if ((listBuilding[j].id) == diem[i]) {
            if (prevX == 0 && prevY == 0) {
              path.moveTo(
                  listBuilding[j].location.dx, listBuilding[j].location.dy);
              prevX = listBuilding[j].location.dx;
              prevY = listBuilding[j].location.dy;
            } else {
              path.quadraticBezierTo(prevX, prevY, listBuilding[j].location.dx,
                  listBuilding[j].location.dy);
              prevX = listBuilding[j].location.dx;
              prevY = listBuilding[j].location.dy;
            }
          }
        }
      }
    } else if (diemDau == 0 || diemCuoi == 0) {
      path.moveTo(0, 0);
    }
    return path;
  }

  Offset calculate(value) {
    PathMetrics pathMetrics = _path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value);
    return pos.position;
  }

  void clearFindPath() {
    setState(() {
      _diemDauController.clear();
      _diemCuoiController.clear();

      diemDau = 0;
      diemCuoi = 0;

      _path = drawPath();

      _controller.reset();
      PositionedWidgetState.diem.clear();
    });
  }

  void findPath(List<int> diem) {
    if (diem.length == 2) {
      setState(() {
        // diemDau = diem[0];
        diemCuoi = diem[1];
        _diemCuoiController.text = listBuilding[diemCuoi - 1].name;

        _path = drawPath();

        _controller.reset();
        _controller.repeat();
      });
    } else if (diem.length == 1) {
      setState(() {
        diemDau = diem[0];
        _diemCuoiController.clear();
        _diemDauController.text = listBuilding[diemDau - 1].name;

        diemCuoi = 0;
        _path = drawPath();

        _controller.repeat();
      });
    } else {
      clearFindPath();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light));
    Size scsize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorApp.orange,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150.0),
        child: appBarWidget(scsize),
      ),
      body: Container(
        height: scsize.height * 0.85,
        color: Colors.white,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              bottom: 20,
              child: Container(
                color: Colors.red,
                child: RawGestureDetectorWidget(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 400,
                        height: 400,
                        // color: Colors.grey,
                        child: Hero(
                          tag: 'mapUtc2',
                          child: Image.asset(
                            'assets/images/1305.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      Stack(
                        children: [
                          Container(
                            //color: Colors.black.withOpacity(0.7),
                            child: CustomPaint(
                              size: Size(411.4, 411.4),
                              painter: Painter(path: _path),
                            ),
                          ),
                          Positioned(
                            top: (diemDau != 0 && diemCuoi != 0)
                                ? calculate(_animation.value).dy - 15
                                : 0,
                            left: (diemDau != 0 && diemCuoi != 0)
                                ? calculate(_animation.value).dx - 15
                                : 0,
                            child: Opacity(
                              opacity: (diemDau != 0 && diemCuoi != 0) ? 1 : 0,
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.directions_walk_rounded),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // GridViewWidget(),
                      Container(
                        width: 411.4,
                        height: 411.4,
                        child: PositionedWidget(
                          findPath: (diem) {
                            findPath(diem);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // listWidget(scsize),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.screen_rotation),
        onPressed: () {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => PanoScreen()));
        },
      ),
    );
  }

  Widget listWidget(Size scsize) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        color: Colors.transparent,
        height: scsize.height * 0.14,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(listBuilding.length, (index) {
              return listBuilding[index].name == ''
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        if (listDiem.length < 2) {
                          if (!listDiem.contains(listBuilding[index].id)) {
                            setState(() {
                              listDiem.add(listBuilding[index].id);
                            });
                          }
                        } else {
                          setState(() {
                            listDiem.clear();
                            listDiem.add(listBuilding[index].id);
                          });
                        }
                        findPath(listDiem);
                      },
                      child: Container(
                        // margin: EdgeInsets.symmetric(vertical: 10),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        padding: EdgeInsets.fromLTRB(4, 5, 20, 5),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/images/image.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  listBuilding[index].name,
                                  style: TextStyle(color: Colors.black),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Chỉ đường',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    Icon(
                                      Icons.directions,
                                      size: 18,
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '360',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    Icon(
                                      Icons.visibility_rounded,
                                      size: 18,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
            }),
          ),
        ),
      ),
    );
  }

  Widget appBarWidget(Size scsize) {
    return AppBar(
      elevation: 0.0,
      bottom: PreferredSize(
        preferredSize: Size(100, 350),
        child: Container(
          // color: Colors.white,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
          child: Container(
              width: scsize.width,
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: scsize.width,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _diemDauController,
                            onChanged: (val) {
                              // search(val.trim());
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: 'Điểm bắt đầu',
                              fillColor: Color(0xffF6F6FF),
                              filled: true,
                              contentPadding: EdgeInsets.all(10),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: IconButton(
                            onPressed: () {
                              clearFindPath();
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: _diemCuoiController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Điểm đến',
                      // suffixIcon: Container(
                      //   width: 10,
                      //   child: MaterialButton(
                      //     onPressed: () {},
                      //     height: 10,
                      //     padding: EdgeInsets.all(2),
                      //     child: Icon(
                      //       Icons.directions,
                      //       color: Color(0xff29166F),
                      //     ),
                      //   ),
                      // ),
                      fillColor: Color(0xffF6F6FF),
                      filled: true,
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none,
                    ),
                  ),
                ],
              )),
        ),
      ),
      backgroundColor: Colors.yellow[800],
    );
  }
}

class Painter extends CustomPainter {
  final Path path;

  Painter({this.path});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.redAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;
    canvas.drawPath(this.path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
