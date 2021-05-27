import 'package:utc2_student/utils/utils.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PayrollScreen extends StatefulWidget {
  @override
  _PayrollScreenState createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen>
    with SingleTickerProviderStateMixin {
  List<_SalesData> data = [
    _SalesData('1', 0),
    _SalesData('2', 28),
    _SalesData('3', 34),
    _SalesData('4', 32),
    _SalesData('5', 40),
    _SalesData('6', 35),
    _SalesData('7', 28),
    _SalesData('8', 34),
    _SalesData('9', 32),
    _SalesData('10', 40),
    _SalesData('11', 40),
    _SalesData('12', 40)
  ];
  ZoomPanBehavior _zoomPanBehavior;
  bool expanded = true;
  AnimationController controller;
  double listHeight = 0;
  int montNow = DateTime.now().month.toInt();
  PageController pageController;
  ValueNotifier<int> _pageNotifier;
  @override
  void initState() {
    pageController =
        PageController(initialPage: montNow - 1, viewportFraction: 0.85);
    _pageNotifier = new ValueNotifier<int>(montNow - 1);
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      zoomMode: ZoomMode.x,
      enableSelectionZooming: true,
      enableDoubleTapZooming: true,
      enablePanning: true,
    );
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
      reverseDuration: Duration(milliseconds: 400),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: ColorApp.black,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Bảng Lương Tháng',
            style: TextStyle(color: ColorApp.black),
          ),
        ),
        body: Column(children: [
          //Initialize the chart widget
          Expanded(
            flex: 2,
            child: Container(
              width: size.width,
              margin: EdgeInsets.all(size.width * 0.03),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: ColorApp.blue.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: SfCartesianChart(
                  zoomPanBehavior: _zoomPanBehavior,
                  primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Tháng')),
                  primaryYAxis: NumericAxis(
                      labelFormat: '{value}',
                      numberFormat:
                          NumberFormat.simpleCurrency(decimalDigits: 0)),
                  // Chart title
                  // title: ChartTitle(
                  //   text: 'Lương 2 Theo Tháng',
                  // ),
                  // Enable legend
                  legend: Legend(
                      isVisible: true,
                      position: LegendPosition.top,
                      iconBorderColor: Colors.blue),
                  // Enable tooltip
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <ChartSeries<_SalesData, String>>[
                    LineSeries<_SalesData, String>(
                        color: Colors.blue,
                        width: 2,
                        dataSource: data,
                        xValueMapper: (_SalesData sales, _) => sales.year,
                        yValueMapper: (_SalesData sales, _) => sales.sales,
                        name: 'Lương 2',
                        // Enable data label
                        dataLabelSettings: DataLabelSettings(isVisible: true)),
                    LineSeries<_SalesData, String>(
                        color: ColorApp.red,
                        width: 1,
                        dataSource: data,
                        xValueMapper: (_SalesData sales, _) => sales.year,
                        yValueMapper: (_SalesData sales, _) => 35,
                        name: 'Lương cứng',
                        // Enable data label
                        dataLabelSettings: DataLabelSettings(isVisible: false))
                  ]),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              width: size.width,
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.03),
              padding: EdgeInsets.all(size.width * 0.03),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: ColorApp.blue.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Flexible(
                    flex: 2,
                    child: Column(
                      children: [
                        level1(
                            'Giảng viên Hạng 2 - Bậc 4', '4.533.055', '2.35'),
                        level('Lương cứng : Cơ bản * Hệ số', true),
                        level('Lương 2 : Cơ bản * Hệ số * Số tiết', false),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Bảng lương chi tiết ',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                              softWrap: true,
                            ),
                            Text(
                              ' Tháng - ' +
                                  (_pageNotifier.value + 1).toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: ColorApp.mediumBlue),
                              softWrap: true,
                            ),
                          ],
                        ),
                        Center(
                          child: DotsIndicator(
                            dotsCount: data.length,
                            mainAxisAlignment: MainAxisAlignment.center,
                            position: _pageNotifier.value.toDouble(),
                            decorator: DotsDecorator(
                              color: ColorApp.lightGrey, // Inactive color
                              activeColor: ColorApp.lightBlue,
                              size: const Size.square(9.0),
                              activeSize: const Size(15.0, 9.0),
                              activeShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Container(
                        child: PageView(
                            physics: BouncingScrollPhysics(),
                            controller: pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _pageNotifier.value = index;
                              });
                            },
                            children: List.generate(data.length, (index) {
                              return AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                width: size.width,
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(size.width * 0.02),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: ColorApp.blue.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                        offset: Offset(
                                            0, 1), // changes position of shadow
                                      ),
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [table(data)],
                                ),
                              );
                            }))),
                  )
                ],
              ),
            ),
          )
        ]));
  }
}

Widget table(List<_SalesData> data) {
  return Expanded(
      child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                },
                // border: TableBorder.symmetric(
                //   inside: BorderSide(color: Colors.green, width: 0.2),
                //   outside: BorderSide(color: Colors.green, width: 0.4),
                // ),
                children: List.generate(data.length, (index) {
                  return index == 0
                      ? TableRow(
                          // decoration: BoxDecoration(
                          //     color: Colors.blue[200].withOpacity(0.5)),
                          children: [
                              cellContent(''),
                              cirle(false),
                              cirle(true),
                            ])
                      : TableRow(children: [
                          cellContent('Vắng'),
                          cellContent(data[index].sales.toString()),
                          cellContent('0'),
                        ]);
                })),
          )));
}

Widget cellContent(String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Center(
      child: Text(
        value ?? '',
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Widget cirle(bool level) {
  return Container(
    width: 12,
    height: 12,
    margin: EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
        shape: BoxShape.circle, color: level ? ColorApp.red : Colors.blue),
  );
}

Widget detail(String value) {
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.all(3.5),
        child: Container(
          width: 5,
          height: 5,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: ColorApp.black),
        ),
      ),
      SizedBox(
        width: 5,
      ),
      Text(value)
    ],
  );
}

Widget level1(String name, String nomarl, String number) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star_rate_rounded,
            color: Colors.yellow[300],
          ),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15,
                color: ColorApp.mediumBlue,
                fontWeight: FontWeight.bold),
            softWrap: true,
          ),
          Icon(
            Icons.star_rate_rounded,
            color: Colors.yellow[300],
          ),
        ],
      ),
      SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 5,
                height: 5,
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: ColorApp.black),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Cơ bản : ',
                style: TextStyle(fontSize: 15),
                softWrap: true,
              ),
              Text(
                nomarl,
                style: TextStyle(
                    fontSize: 15,
                    color: ColorApp.mediumBlue,
                    fontWeight: FontWeight.w600),
                softWrap: true,
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 5,
                height: 5,
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: ColorApp.black),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Hệ số : ',
                style: TextStyle(fontSize: 15),
                softWrap: true,
              ),
              Text(
                number,
                style: TextStyle(
                    fontSize: 15,
                    color: ColorApp.mediumBlue,
                    fontWeight: FontWeight.w600),
                softWrap: true,
              )
            ],
          ),
        ],
      ),
    ],
  );
}

Widget level(String name, bool level) {
  return Row(
    children: [
      Container(
        width: 12,
        height: 12,
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: level ? ColorApp.red : Colors.blue),
      ),
      SizedBox(
        width: 5,
      ),
      Text(
        name,
        style: TextStyle(fontSize: 15),
        softWrap: true,
      )
    ],
  );
}

class _SalesData {
  _SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
