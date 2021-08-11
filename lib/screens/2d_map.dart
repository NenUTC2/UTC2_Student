import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:utc2_student/screens/2d_controller.dart';
import 'package:utc2_student/widgets/positioned_widget.dart';
import 'package:utc2_student/widgets/raw_gesture_detector_widget.dart';

class Map2dScreen extends StatefulWidget {
  @override
  _Map2dScreenState createState() => _Map2dScreenState();
}

class _Map2dScreenState extends State<Map2dScreen>
    with SingleTickerProviderStateMixin {
  var controller = Get.put(Map2dController());

  double x = 40, y = 200;
  double xdef = 40, ydef = 200;
  double step = 10, size = 20;
  String huong = '';

  @override
  void initState() {
    controller.init(Get.arguments);
    controller.animateController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 5000));
    controller.animation =
        Tween(begin: 0.0, end: 1.0).animate(controller.animateController)
          ..addListener(() {
            controller.animateValue.value = controller.animation.value;
          });

    controller.animateController.repeat();
    controller.path = controller.drawPath();
    super.initState();
  }

  @override
  void dispose() {
    controller.animateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light));
    Size scsize = MediaQuery.of(context).size;
    // final model = Provider.of<FloorPlanModel>(context);
    return WillPopScope(
      onWillPop: () async {
        Get.delete<Map2dController>();
        PositionedWidgetState.diem.clear();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(150.0),
          child: appBarWidget(scsize),
        ),
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            height: scsize.height * 0.85,
            color: Colors.white,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  top: 30,
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

                          Obx(
                            () => Stack(
                              children: [
                                Container(
                                  //color: Colors.black.withOpacity(0.7),
                                  child: CustomPaint(
                                    size: Size(411.4, 411.4),
                                    painter: Painter(path: controller.path),
                                  ),
                                ),
                                Positioned(
                                  top: (controller.diemDau.value != 0 &&
                                          controller.diemCuoi.value != 0)
                                      ? controller
                                              .calculate(
                                                  controller.animateValue.value)
                                              .dy -
                                          15
                                      : 0,
                                  left: (controller.diemDau.value != 0 &&
                                          controller.diemCuoi.value != 0)
                                      ? controller
                                              .calculate(
                                                  controller.animateValue.value)
                                              .dx -
                                          15
                                      : 0,
                                  child: Opacity(
                                    opacity: (controller.diemDau.value != 0 &&
                                            controller.diemCuoi.value != 0)
                                        ? 1
                                        : 0,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.yellow,
                                        shape: BoxShape.circle,
                                      ),
                                      child:
                                          Icon(Icons.directions_walk_rounded),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // GridViewWidget(),
                          Container(
                            width: 411.4,
                            height: 411.4,
                            child: PositionedWidget(
                              findPath: (diem) {
                                controller.onTapPositioned(diem, context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Obx(() => AnimatedOpacity(
                    opacity: controller.isShowSearch.value ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: listWidget(scsize))),
              ],
            ),
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.screen_rotation),
        //   onPressed: () {

        //     Get.delete<Map2dController>();
        //   },
        // ),
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
            children: List.generate(controller.listSearch.length, (index) {
              return controller.listSearch[index].name == ''
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        controller.onTapItem(
                            controller.listSearch[index].id, context);
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
                                controller.listSearch[index].image,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.listSearch[index].name,
                                  style: TextStyle(color: Colors.black),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                            onTap: () {
                              controller.onTapTextField(true);
                              print('tap true');
                            },
                            controller: controller.diemDauController,
                            onChanged: (val) {
                              controller.onSearch(val.trim());
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
                              controller.clearFindPath();
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
                    onTap: () {
                      controller.onTapTextField(false);

                      print('tap false');
                    },
                    controller: controller.diemCuoiController,
                    onChanged: (val) {
                      controller.onSearch(val.trim());
                    },
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
