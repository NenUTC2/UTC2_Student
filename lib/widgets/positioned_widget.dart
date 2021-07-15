
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utc2_student/models/end_point.dart';
import 'package:utc2_student/models/floorplan_model.dart';
import 'package:utc2_student/models/global.dart';
import 'package:utc2_student/models/models.dart';

import '../../path_finder/repo_path.dart';

class PositionedWidget extends StatefulWidget {
  final Function(List<int>) findPath;

  const PositionedWidget({Key key, this.findPath}) : super(key: key);
  @override
  PositionedWidgetState createState() => PositionedWidgetState();
}

class PositionedWidgetState extends State<PositionedWidget> {
  final List<EndPoint> dayNha = listBuilding;

  static List<int> diem = [];

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<FloorPlanModel>(context);
    final List<Room> phongHoc =
        Global.phongHoc.map((item) => Room.fromMap(item)).toList();
    return Stack(
      children:
          // model.isScaled
          //     ? List.generate(phongHoc.length, (index) {
          //         return Positioned(
          //             left: phongHoc[index].position[0],
          //             top: phongHoc[index].position[1] - 20,
          //             child:
          //                 Stack(alignment: Alignment.centerLeft, children: <Widget>[
          //               Container(
          //                 width: 15,
          //                 child: CircleAvatar(
          //                   backgroundColor: Colors.red,
          //                   child: Icon(
          //                     Icons.room,
          //                     size: 10,
          //                   ),
          //                 ),
          //               ),
          //               Transform(
          //                 transform: Matrix4.identity()..translate(17.0),
          //                 child: Stack(
          //                   children: [
          //                     Text(
          //                       phongHoc[index].name,
          //                       style: TextStyle(
          //                         fontSize: 9,
          //                         foreground: Paint()
          //                           ..style = PaintingStyle.stroke
          //                           ..strokeWidth = 0.7
          //                           ..color = Colors.black,
          //                       ),
          //                     ),
          //                     Text(
          //                       phongHoc[index].name,
          //                       style: TextStyle(
          //                         fontSize: 9.0,
          //                         color: Colors.white,
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               )
          //             ]));
          //       })
          // :
          List.generate(dayNha.length, (index) {
        return dayNha[index].name != ''
            ? Positioned(
                left: dayNha[index].location.dx - (30 + model.scale * 2) / 2,
                top: dayNha[index].id == 39
                    ? dayNha[index].location.dy -
                        (30 + model.scale * 2) / 2 -
                        30
                    : dayNha[index].location.dy - (30 + model.scale * 2) / 2,
                child: Container(
                  child: dayNha[index].id == 41 || dayNha[index].id == 40
                      ? RotatedBox(
                          quarterTurns: dayNha[index].id == 40 ? 0 : -1,
                          child: Stack(
                            children: [
                              Text(
                                dayNha[index].name,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 1
                                    ..color = Colors.black,
                                ),
                              ),
                              Text(
                                dayNha[index].name,
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        )
                      : InkWell(
                          // shape: CircleBorder(),
                          // fillColor: Colors.black,
                          splashColor: Colors.white,
                          onTap: () {
                            if (diem.length < 2) {
                              if (!diem.contains(dayNha[index].id)) {
                                setState(() {
                                  diem.add(dayNha[index].id);
                                });
                              }
                            } else {
                              setState(() {
                                diem.clear();
                                diem.add(dayNha[index].id);
                              });
                            }
                            widget.findPath(diem);
                          },
                          child: Stack(
                              alignment: Alignment.centerLeft,
                              children: <Widget>[
                                Container(
                                  width: 30 + model.scale * 2,
                                  height: 30 + model.scale * 2,
                                  // color: Colors.black54,
                                  padding: EdgeInsets.all(5),
                                  child: !model.isScaled
                                      ? CircleAvatar(
                                          backgroundColor:
                                              diem.contains(dayNha[index].id)
                                                  ? Colors.blue
                                                  : Colors.red,
                                          child: Icon(
                                            Icons.room,
                                            color: Colors.white,
                                            size: 15 - model.scale * 3,
                                          ),
                                        )
                                      : CircleAvatar(
                                          backgroundColor:
                                              diem.contains(dayNha[index].id)
                                                  ? Colors.blue
                                                  : Colors.red,
                                          backgroundImage:
                                              AssetImage('assets/utc2.png'),
                                        ),
                                ),
                                Transform(
                                  transform: Matrix4.identity()
                                    ..translate(32.0 + model.scale * 2),
                                  child: Stack(
                                    children: [
                                      Text(
                                        dayNha[index].name,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 1
                                            ..color = Colors.black,
                                        ),
                                      ),
                                      Text(
                                        dayNha[index].name,
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                )
                              ]),
                        ),
                ))
            : Container();
      }),
    );
  }
}
