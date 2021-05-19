import 'package:utc2_student/utils/custom_glow.dart';
import 'package:utc2_student/utils/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/gestures.dart';

/// Icons by svgrepo.com (https://www.svgrepo.com/collection/job-and-professions-3/)
class PieChartSample3 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PieChartSample3State();
}

class PieChartSample3State extends State {
  int touchedIndex;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: ColorApp.blue.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 1), // changes position of shadow
            )
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 3,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                      pieTouchData:
                          PieTouchData(touchCallback: (pieTouchResponse) {
                        setState(() {
                          final desiredTouch = pieTouchResponse.touchInput
                                  is! PointerExitEvent &&
                              pieTouchResponse.touchInput is! PointerUpEvent;
                          if (desiredTouch &&
                              pieTouchResponse.touchedSection != null) {
                            touchedIndex = pieTouchResponse
                                .touchedSection.touchedSectionIndex;
                          } else {
                            touchedIndex = -1;
                          }
                        });
                      }),
                      borderData: FlBorderData(
                          show: true,
                          border: Border.all(color: Colors.transparent)),
                      sectionsSpace: 2,
                      centerSpaceRadius: 15,
                      sections: showingSections()),
                ),
                CustomAvatarGlow(
                    glowColor: Colors.white,
                    endRadius: 25.0,
                    duration: Duration(milliseconds: 1000),
                    repeat: true,
                    showTwoGlows: true,
                    repeatPauseDuration: Duration(milliseconds: 100),
                    child: Image.asset(
                      'assets/images/logoUTC.png',
                      width: 20,
                    )),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  detail('Công tác', Color(0xff0293ee), 0, touchedIndex),
                  detail('Giảng dạy', Color(0xfff8b250), 1, touchedIndex),
                  detail('Dạy bù', Color(0xff845bef), 2, touchedIndex),
                  detail('Gác thi', Color(0xff13d38e), 3, touchedIndex)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget detail(String value, Color color, int index, int indexT) {
    Color glow = color;
    switch (indexT) {
      case 0:
        glow = Color(0xff0293ee);

        break;
      case 1:
        glow = Color(0xfff8b250);
        break;
      case 2:
        glow = Color(0xff845bef);
        break;
      case 3:
        glow = Color(0xff13d38e);
        break;
    }
    return Row(
      children: [
        CustomAvatarGlow(
          glowColor: index == indexT ? glow : Colors.white,
          endRadius: 10.0,
          duration: Duration(milliseconds: 1000),
          repeat: true,
          showTwoGlows: true,
          repeatPauseDuration: Duration(milliseconds: 100),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          value,
          style: TextStyle(color: ColorApp.black, fontSize: 15),
        )
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 20 : 16;
      final double radius = isTouched ? 100 : 90;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            // badgeWidget: _Badge(
            //   'assets/ophthalmology-svgrepo-com.svg',
            //   size: widgetSize,
            //   borderColor: const Color(0xff0293ee),
            // ),
            titlePositionPercentageOffset: .5,
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            // badgeWidget: _Badge(
            //   'assets/images/logoUTC.svg',
            //   size: widgetSize,
            //   borderColor: const Color(0xfff8b250),
            // ),
            titlePositionPercentageOffset: .5,
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: 16,
            title: '16%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            // badgeWidget: _Badge(
            //   'assets/images/logoUTC.svg',
            //   size: widgetSize,
            //   borderColor: const Color(0xff845bef),
            // ),
            titlePositionPercentageOffset: .5,
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            // badgeWidget: _Badge(
            //   'assets/images/logoUTC.svg',
            //   size: widgetSize,
            //   borderColor: const Color(0xff13d38e),
            // ),
            titlePositionPercentageOffset: .5,
          );
        default:
          return null;
      }
    });
  }
}
