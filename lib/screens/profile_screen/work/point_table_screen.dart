import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:utc2_student/models/hoc_ky.dart';
import 'package:utc2_student/models/mon_hoc.dart';
import 'package:utc2_student/screens/profile_screen/work/detail_point.dart';
import 'package:utc2_student/service/web_wraper_utc/diem_scraper.dart';
import 'package:utc2_student/utils/utils.dart';

class PointTableScreen extends StatefulWidget {
  @override
  _PointTableScreenState createState() => _PointTableScreenState();
}

class _PointTableScreenState extends State<PointTableScreen> {
  String getTinChi(List<MonHoc> ds_MonHoc) {
    int tongtc = 0;

    for (int i = 0; i < ds_MonHoc.length; i++) {
      tongtc += int.parse(ds_MonHoc[i].tinchi);
    }

    return tongtc.toString();
  }

  int curStep = 0;
  DiemScraper diemScraper = DiemScraper();
  List<Step> steps = [
    Step(
      title: const Text('New Account'),
      isActive: true,
      state: StepState.complete,
      content: Container(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: 'Điểm tích luỹ:  ',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                      text: '2.93',
                      style: TextStyle(
                        color: ColorApp.red,
                      )),
                  TextSpan(text: ' (Hệ 4) | ', style: TextStyle()),
                  TextSpan(
                      text: '7.8',
                      style: TextStyle(
                        color: ColorApp.red,
                      )),
                  TextSpan(text: ' (Hệ 10)', style: TextStyle()),
                ],
              ),
            )
          ],
        ),
      ),
    ),
    Step(
      title: const Text('New Account 1'),
      isActive: true,
      state: StepState.complete,
      content: Container(),
    ),
    Step(
      title: const Text('New Account 2'),
      isActive: true,
      state: StepState.complete,
      content: Container(),
    ),
    Step(
      title: const Text('New Account 3'),
      isActive: true,
      state: StepState.complete,
      content: Container(),
    ),
    Step(
      title: const Text('New Account'),
      isActive: true,
      state: StepState.complete,
      content: Container(),
    ),
    Step(
      title: const Text('New Account 1'),
      isActive: true,
      state: StepState.complete,
      content: Container(),
    ),
    Step(
      title: const Text('New Account 2'),
      isActive: true,
      state: StepState.complete,
      content: Container(),
    ),
    Step(
      title: const Text('New Account 3'),
      isActive: true,
      state: StepState.complete,
      content: Container(),
    )
  ];
  @override
  void initState() {
    super.initState();
    diemScraper.getDiemTong();
    diemScraper.getDiem();
  }

  @override
  void dispose() {
    diemScraper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Bảng điểm học tập',
          style: TextStyle(color: Colors.black),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              height: size.height / 4,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(0xff29166F),
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color(0xff29166F),
                        Color(0xff29166F).withOpacity(.8),
                        Color(0xff29166F).withOpacity(.7),
                      ])),
              child: StreamBuilder<List>(
                  stream: diemScraper.streamDiemTong,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    } else {
                      var diemHe4 = double.parse(snapshot.data[0]);
                      var diemHe10 = double.parse(snapshot.data[1]);
                      var xepLoai = '';
                      if (diemHe4 >= 3) {
                        xepLoai = 'Giỏi';
                      } else if (diemHe4 >= 2.2 && diemHe4 < 3) {
                        xepLoai = 'Khá';
                      } else {
                        xepLoai = 'Trung bình';
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 30),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      white('Điểm tích lũy'),
                                      Container(
                                          height: 18,
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: Colors.amber,
                                              ),
                                              white('Hệ 4 :  ' +
                                                  diemHe4.toString()),
                                            ],
                                          )),
                                      Container(
                                          height: 18,
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundColor:
                                                    Colors.greenAccent,
                                              ),
                                              white('Hệ 10 :  ' +
                                                  diemHe10.toString()),
                                            ],
                                          )),
                                      Container(
                                          height: 18,
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundColor:
                                                    Colors.blueAccent,
                                              ),
                                              white('Số tín chỉ :  ' +
                                                  snapshot.data[2].toString() +
                                                  '/142'),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              white('Học lực : ' + xepLoai),
                            ],
                          ),
                          Container(
                          
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularPercentIndicator(
                                  radius: size.width * 0.3,
                                  lineWidth: size.width * 0.01,
                                  animation: true,
                                  percent: diemHe10 / 10,
                                  animationDuration: 2500,
                                  restartAnimation: true,

                                  center: Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        new Countup(
                                          begin: 0,
                                          end: snapshot.data[2] * 100 / 142,
                                          duration:
                                              Duration(milliseconds: 2500),
                                          style: new TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: size.width * 0.05),
                                        ),
                                        Text(
                                          " %",
                                          style: new TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: size.width * 0.03),
                                        ),
                                      ],
                                    ),
                                  ),

                                  circularStrokeCap: CircularStrokeCap.round,
                                  // progressColor: Color(0xffFCD24B),
                                  backgroundColor: Colors.white,
                                  backgroundWidth: .2,
                                  linearGradient: LinearGradient(
                                    begin: Alignment(-1.3, 0),
                                    end: Alignment(1.3,
                                        0), // 10% of the width, so there are ten blinds.
                                    colors: [
                                      Colors.green,
                                      Colors.greenAccent
                                    ], // red to yellow
                                    tileMode: TileMode
                                        .repeated, // repeats the gradient over the canvas
                                  ),
                                ),
                                CircularPercentIndicator(
                                  radius: size.width * 0.35,
                                  lineWidth: size.width * 0.02,
                                  animation: true,
                                  percent: diemHe4 / 4,
                                  animationDuration: 2500,
                                  restartAnimation: true,

                                  circularStrokeCap: CircularStrokeCap.round,
                                  // progressColor: Color(0xffFCD24B),
                                  backgroundColor: Colors.white,
                                  backgroundWidth: 0.5,
                                  linearGradient: LinearGradient(
                                    begin: Alignment(-1.3, 0),
                                    end: Alignment(1.3,
                                        0), // 10% of the width, so there are ten blinds.
                                    colors: [
                                      Colors.amber,
                                      Colors.red
                                    ], // red to yellow
                                    tileMode: TileMode
                                        .repeated, // repeats the gradient over the canvas
                                  ),
                                ),
                                CircularPercentIndicator(
                                  radius: size.width * 0.41,
                                  lineWidth: size.width * 0.02,
                                  animation: true,
                                  percent: 100 / 170,
                                  animationDuration: 2500,
                                  restartAnimation: true,

                                  circularStrokeCap: CircularStrokeCap.round,
                                  // progressColor: Color(0xffFCD24B),
                                  backgroundColor: Colors.white,
                                  backgroundWidth: 1,
                                  linearGradient: LinearGradient(
                                    begin: Alignment(-1.3, 0),
                                    end: Alignment(1.3,
                                        0), // 10% of the width, so there are ten blinds.
                                    colors: [
                                      Colors.blue,
                                      Colors.blue[200]
                                    ], // red to yellow
                                    tileMode: TileMode
                                        .repeated, // repeats the gradient over the canvas
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    }
                  }),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                // height: size.height / 5,
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.03,
                    vertical: size.height * 0.02),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(-2, 5), // changes position of shadow
                    ),
                  ],
                ),
                child: StreamBuilder<List<HocKi>>(
                    stream: diemScraper.streamHocKy,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<HocKi> list = snapshot.data.reversed.toList();
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Quá trình',
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                      fontSize: size.width * 0.04),
                                ),
                                Text(
                                  'All(${list.length})',
                                  style: new TextStyle(
                                      color: Color(0xff29166F),
                                      fontSize: size.width * 0.035),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: Container(
                                height: size.height / 2,
                                alignment: Alignment.topCenter,
                                child: Stepper(
                                  currentStep: curStep,
                                  physics: BouncingScrollPhysics(),
                                  controlsBuilder: (BuildContext context,
                                      {VoidCallback onStepContinue,
                                      VoidCallback onStepCancel}) {
                                    return Container();
                                  },
                                  onStepTapped: (step) {
                                    setState(() {
                                      curStep = step;
                                    });
                                  },
                                  // currentStep: 1,
                                  steps: List.generate(list.length, (index) {
                                    return Step(
                                      title: Text(
                                        list[index].namhoc,
                                        style: TextStyle(
                                            fontSize: size.width * 0.04,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      isActive: true,
                                      state: StepState.complete,
                                      content: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                text: 'Điểm tích luỹ:  ',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize:
                                                        size.width * 0.035,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: list[index]
                                                          .getDiemHe4(),
                                                      style: TextStyle(
                                                        color: ColorApp.red,
                                                      )),
                                                  TextSpan(
                                                      text: ' (Hệ 4) | ',
                                                      style: TextStyle()),
                                                  TextSpan(
                                                      text: list[index]
                                                          .getDiemHe10(),
                                                      style: TextStyle(
                                                        color: ColorApp.red,
                                                      )),
                                                  TextSpan(
                                                      text: ' (Hệ 10)',
                                                      style: TextStyle()),
                                                ],
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: 'Số tin chỉ tích luỹ:  ',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize:
                                                        size.width * 0.035,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: getTinChi(
                                                          list[index]
                                                              .getDsMonHoc()),
                                                      style: TextStyle(
                                                        color: ColorApp.red,
                                                      )),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailPoint(
                                                              hocKi:
                                                                  list[index],
                                                              list: list,
                                                            )));
                                              },
                                              child: Text(
                                                'Xem chi tiết',
                                                style: TextStyle(
                                                    fontSize:
                                                        size.width * 0.035,
                                                    color: Colors.blue[600],
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            )
                          ],
                        );
                      } else {
                        return Container();
                      }
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget white(String text) {
  return Text(
    text,
    style: TextStyle(color: Colors.white),
  );
}
