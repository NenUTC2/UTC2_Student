
import 'package:flutter/material.dart';
import 'package:utc2_student/models/hoc_ky.dart';
import 'package:utc2_student/models/mon_hoc.dart';
import 'package:utc2_student/utils/utils.dart';

class DetailPoint extends StatefulWidget {
  final HocKi hocKi;
  final List<HocKi> list;
  DetailPoint({this.hocKi, this.list});

  @override
  _DetailPointState createState() => _DetailPointState();
}

class _DetailPointState extends State<DetailPoint> {
  bool isAll = false;
  String getTinChi(List<MonHoc> dsMonHoc) {
    int tongtc = 0;

    for (int i = 0; i < dsMonHoc.length; i++) {
      tongtc += int.parse(dsMonHoc[i].tinchi);
    }

    return tongtc.toString();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Bảng điểm chi tiết',
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              !isAll ? isAll = true : isAll = false;
            });
          },
          child: Container(
            color: ColorApp.orange,
            padding: EdgeInsets.all(8),
            child: Text(
                !isAll
                    ? 'Xem tất cả (' + widget.list.length.toString() + ')'
                    : 'Ẩn bớt',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.w700)),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 18),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Điểm tích lũy : ',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: widget.hocKi.getDiemHe4(),
                      style: TextStyle(
                          color: Colors.green[300],
                          fontSize: size.width * 0.045,
                          fontWeight: FontWeight.w700),
                    ),
                    TextSpan(
                      text: '  (Hệ 4)  | ',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: widget.hocKi.getDiemHe10(),
                      style: TextStyle(
                          color: Colors.green[300],
                          fontSize: size.width * 0.045,
                          fontWeight: FontWeight.w700),
                    ),
                    TextSpan(
                      text: '  (Hệ 10)',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Số tín chỉ tích lũy : ',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: getTinChi(widget.hocKi.getDsMonHoc()),
                      style: TextStyle(
                          color: Colors.green[300],
                          fontSize: size.width * 0.045,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: isAll ? widget.list.length : 1,
                    itemBuilder: (context, i) {
                      return Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Center(
                            child: Text(
                                !isAll
                                    ? widget.hocKi.namhoc
                                    : widget.list[i].namhoc,
                                style: TextStyle(
                                    color: ColorApp.orange,
                                    fontSize: size.width * 0.04,
                                    fontWeight: FontWeight.w700)),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Table(
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              columnWidths: {
                                0: FlexColumnWidth(0.5),
                                1: FlexColumnWidth(1.5),
                                2: FlexColumnWidth(3),
                                3: FlexColumnWidth(0.5),
                                4: FlexColumnWidth(2.2),
                              },
                              border: TableBorder.symmetric(
                                inside:
                                    BorderSide(color: Colors.green, width: 0.2),
                                outside:
                                    BorderSide(color: Colors.green, width: 0.5),
                              ),
                              children: List.generate(
                                  !isAll
                                      ? widget.hocKi.getDsMonHoc().length + 1
                                      : widget.list[i].getDsMonHoc().length + 1,
                                  (index) {
                                return index == 0
                                    ? TableRow(
                                        decoration: BoxDecoration(
                                            color: Colors.blue[200]
                                                .withOpacity(0.5)),
                                        children: [
                                            cellContent('STT'),
                                            cellContent('Mã môn'),
                                            cellContent('Tên môn'),
                                            cellContent('Số TC'),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                cellContent('Điểm thi'),
                                                Divider(
                                                  color: Colors.green,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        child:
                                                            cellContent('L1'),
                                                        decoration: BoxDecoration(
                                                            border: Border(
                                                                right: BorderSide(
                                                                    color: Colors
                                                                        .green,
                                                                    width:
                                                                        0.3))),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        child: cellContent(
                                                            'Thi Lại'),
                                                        decoration: BoxDecoration(
                                                            border: Border(
                                                                right: BorderSide(
                                                                    color: Colors
                                                                        .green,
                                                                    width:
                                                                        0.2))),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ])
                                    : TableRow(children: [
                                        cellContent(!isAll
                                            ? widget.hocKi
                                                .getDsMonHoc()[index - 1]
                                                .stt
                                            : widget.list[i]
                                                .getDsMonHoc()[index - 1]
                                                .stt),
                                        cellContent(!isAll
                                            ? widget.hocKi
                                                .getDsMonHoc()[index - 1]
                                                .mamon
                                            : widget.list[i]
                                                .getDsMonHoc()[index - 1]
                                                .mamon),
                                        cellContent(!isAll
                                            ? widget.hocKi
                                                .getDsMonHoc()[index - 1]
                                                .tenmonhoc
                                            : widget.list[i]
                                                .getDsMonHoc()[index - 1]
                                                .tenmonhoc),
                                        cellContent(!isAll
                                            ? widget.hocKi
                                                .getDsMonHoc()[index - 1]
                                                .tinchi
                                            : widget.list[i]
                                                .getDsMonHoc()[index - 1]
                                                .tinchi),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                child: cellContent(!isAll
                                                    ? widget.hocKi
                                                        .getDsMonHoc()[
                                                            index - 1]
                                                        .thilanmot
                                                    : widget.list[i]
                                                        .getDsMonHoc()[
                                                            index - 1]
                                                        .thilanmot),
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        right: BorderSide(
                                                            color: Colors.green,
                                                            width: 0.2))),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: cellContent(!isAll
                                                    ? widget.hocKi
                                                        .getDsMonHoc()[
                                                            index - 1]
                                                        .thilai
                                                    : widget.list[i]
                                                        .getDsMonHoc()[
                                                            index - 1]
                                                        .thilai),
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        right: BorderSide(
                                                            color: Colors.green,
                                                            width: 0.5))),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]);
                              }),
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
