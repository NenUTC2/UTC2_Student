import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:utc2_student/blocs/question_bloc/question_bloc.dart';
import 'package:utc2_student/blocs/question_bloc/question_event.dart';
import 'package:utc2_student/blocs/question_bloc/question_state.dart';
import 'package:utc2_student/blocs/quiz_bloc/quiz_bloc.dart';
import 'package:utc2_student/blocs/quiz_bloc/quiz_event.dart';
import 'package:utc2_student/blocs/quiz_bloc/quiz_state.dart';
import 'package:utc2_student/service/firestore/quiz_database.dart';
import 'package:utc2_student/service/pdf/pdf_api.dart';
import 'package:utc2_student/service/pdf/pdf_class_detail.dart';
import 'package:utc2_student/utils/utils.dart';

class QuizSreen extends StatefulWidget {
  final String quizId;
  final String idTeacher;

  QuizSreen({this.quizId, this.idTeacher});
  @override
  _QuizSreenState createState() => _QuizSreenState();
}

class _QuizSreenState extends State<QuizSreen> {
  String selectedRadio;
  List<String> listAnswer = [];
  String status = 'not start';

  final interval = const Duration(seconds: 1);

  int timerMaxSeconds = 0;

  int currentSeconds = 0;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';
  Timer _timer;
  startTimeout([int milliseconds]) {
    var duration = interval;
    _timer = Timer.periodic(duration, (timer) {
      setState(() {
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) {
          setState(() {
            status = 'end';
          });
          for (var item in listCorrect) {
            if (item == listAnswer[listCorrect.indexOf(item)]) {
              setState(() {
                totalCorrect += 1;
              });
            }
          }

          _timer.cancel();
        }
      });
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Huỷ"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Kết thúc"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Bài kiểm tra chưa hoàn thành, bạn có muốn kết thúc?"),
      content: Text('Số câu: ' +
          totalAnswer.toString() +
          '/' +
          listAnswer.length.toString()),
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

  int totalAnswer = 0;
  int totalCorrect = 0;
  QuestionBloc questionBloc = new QuestionBloc();
  QuizBloc quizBloc;

  List<List> listRandom = [];
  List listCorrect = [];
  @override
  void initState() {
    super.initState();
    // selectedRadio = 0;
    // timerMaxSeconds = int.parse(widget.quiz.timePlay.toString()) * 60;
    questionBloc = BlocProvider.of<QuestionBloc>(context);
    questionBloc.add(GetQuestionEvent(widget.idTeacher, widget.quizId));
    quizBloc = BlocProvider.of<QuizBloc>(context);
    quizBloc.add(Get1QuizEvent(widget.idTeacher, widget.quizId));
  }

  @override
  void dispose() {
    status == 'start' ? _timer.cancel() : print('');
    super.dispose();
  }

  void updateTotal() {
    setState(() {
      totalAnswer = 0;
    });
    for (var item in listAnswer) {
      if (item != '') {
        setState(() {
          totalAnswer += 1;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (status == 'start') {
              showAlertDialog(context);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          'Xem trước',
          style: TextStyle(color: ColorApp.black),
        ),
        actions: [
          TextButton.icon(
              onPressed: () async {
                // final pdfFile = await PdfParagraphApi.generate();
                // PdfApi.openFile(pdfFile);
                print(listAnswer);
              },
              icon: Icon(Icons.note_add_rounded),
              label: Text('Nộp bài'))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(size.width * 0.03),
        height: size.height,
        child: Column(
          children: [
            BlocConsumer<QuizBloc, QuizState>(
              listener: (context, state) {
                if (state is LoadedQuiz) {
                  setState(() {
                    timerMaxSeconds =
                        int.parse(state.list[0].timePlay.toString()) * 60;
                  });
                }
              },
              builder: (context, state) {
                if (state is LoadedQuiz)
                  return Container(
                    child: QuizTitle(
                      title: state.list[0].titleQuiz,
                      time: timerText,
                      totalQuestion: totalAnswer.toString() +
                          "/" +
                          state.list[0].totalQuestion,
                      start: () {
                        if (status == 'not start') {
                          setState(() {
                            status = 'start';
                          });
                          startTimeout();
                        } else if (status == 'start') {
                          setState(() {
                            status = 'end';
                          });
                          for (var item in listCorrect) {
                            if (item == listAnswer[listCorrect.indexOf(item)]) {
                              setState(() {
                                totalCorrect += 1;
                              });
                            }
                          }

                          _timer.cancel();
                        } else if (status == 'end') {}
                      },
                      isStart: status,
                    ),
                  );
                else
                  return Container();
              },
            ),
            SizedBox(
              height: size.width * 0.03,
            ),
            Expanded(
              child: AnimatedCrossFade(
                secondChild: status == 'end'
                    ? Container(
                        height: 100,
                        width: size.width,
                        child: Center(
                          child: Text(
                            'Kết quả: ' +
                                totalCorrect.toString() +
                                '/' +
                                listAnswer.length.toString(),
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      )
                    : Container(),
                firstCurve: Curves.easeInOutSine,
                crossFadeState: status == 'start'
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: Duration(milliseconds: 500),
                firstChild: Container(
                  width: size.width,
                  height: size.height,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: ColorApp.orange.withOpacity(0.05),
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: ColorApp.lightGrey)),
                  child: BlocConsumer<QuestionBloc, QuestionState>(
                    listener: (context, state) {
                      if (state is LoadedQuestion) {
                        listRandom.clear();
                        for (int i = 0; i < state.list.length; i++) {
                          listRandom.add([]);
                          listAnswer.add('');
                          listCorrect.add(state.list[i].answerCorrect);
                          listRandom[i].add(state.list[i].answerCorrect);
                          listRandom[i].add(state.list[i].answer2);
                          listRandom[i].add(state.list[i].answer3);
                          listRandom[i].add(state.list[i].answer4);
                        }
                        for (var item in listRandom) {
                          item.shuffle();
                        }
                      }
                    },
                    builder: (context, state) {
                      if (state is LoadingQuestion)
                        return SpinKitThreeBounce(
                          color: ColorApp.lightOrange,
                        );
                      else if (state is LoadedQuestion) {
                        if (listRandom.isNotEmpty && listAnswer.isNotEmpty)
                          return RefreshIndicator(
                            onRefresh: () async {
                              questionBloc.add(GetQuestionEvent(
                                  widget.idTeacher, widget.quizId));
                            },
                            child: Scrollbar(
                              child: ListView.builder(
                                  padding: EdgeInsets.all(size.width * 0.03),
                                  itemCount: state.list.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Question(
                                        number: index,
                                        question: state.list[index].question,
                                        listRandom: [
                                          Option(
                                            answer: listRandom[index][0],
                                            value: listRandom[index][0],
                                            selectedRadio: listAnswer[index],
                                            setSelectedRadio: (val) {
                                              setState(() {
                                                listAnswer[index] = val;
                                              });
                                              updateTotal();
                                            },
                                          ),
                                          Option(
                                            answer: listRandom[index][1],
                                            value: listRandom[index][1],
                                            selectedRadio: listAnswer[index],
                                            setSelectedRadio: (val) {
                                              setState(() {
                                                listAnswer[index] = val;
                                              });
                                              updateTotal();
                                            },
                                          ),
                                          state.list[index].answer3 != ''
                                              ? Option(
                                                  answer: listRandom[index][2],
                                                  value: listRandom[index][2],
                                                  selectedRadio:
                                                      listAnswer[index],
                                                  setSelectedRadio: (val) {
                                                    setState(() {
                                                      listAnswer[index] = val;
                                                    });
                                                    updateTotal();
                                                  },
                                                )
                                              : Container(),
                                          state.list[index].answer4 != ''
                                              ? Option(
                                                  answer: listRandom[index][3],
                                                  value: listRandom[index][3],
                                                  selectedRadio:
                                                      listAnswer[index],
                                                  setSelectedRadio: (val) {
                                                    setState(() {
                                                      listAnswer[index] = val;
                                                    });
                                                    updateTotal();
                                                  },
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          );
                        else
                          return Container();
                      } else if (state is LoadErrorQuestion) {
                        return Center(
                          child: Text(
                            state.error,
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        );
                      } else {
                        return SpinKitThreeBounce(
                          color: ColorApp.lightOrange,
                        );
                      }
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Option extends StatelessWidget {
  final String answer;
  final String value;
  final String selectedRadio;
  final Function setSelectedRadio;
  Option({this.selectedRadio, this.value, this.setSelectedRadio, this.answer});

  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: Radio(
          value: value,
          groupValue: selectedRadio,
          activeColor: ColorApp.red,
          onChanged: (val) {
            setSelectedRadio(val);
          },
        ),
        title: Text(answer),
      ),
    );
  }
}

class Question extends StatefulWidget {
  final String question;
  final int number;

  final List listRandom;
  Question({this.question, this.number, this.listRandom});

  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorApp.lightGrey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (widget.number + 1).toString() + '. ' + widget.question,
            style: TextStyle(
                color: ColorApp.black,
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
          Column(
            children: List.generate(
                widget.listRandom.length, (index) => widget.listRandom[index]),
          )
        ],
      ),
    );
  }
}

class QuizTitle extends StatelessWidget {
  final String title;
  final String time;
  final String totalQuestion;
  final Function start;
  final String isStart;
  QuizTitle(
      {this.title, this.time, this.totalQuestion, this.start, this.isStart});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width,
        alignment: Alignment.center,
        padding: EdgeInsets.all(size.width * 0.03),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: ColorApp.orange.withOpacity(0.05),
                spreadRadius: 3,
                blurRadius: 3,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ColorApp.lightGrey)),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(title),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Thời gian:  ',
                      style: TextStyle(
                          color: ColorApp.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                            text: time,
                            style: TextStyle(
                                color: ColorApp.red,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Câu hỏi:  ',
                      style: TextStyle(
                          color: ColorApp.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                            text: totalQuestion,
                            style: TextStyle(
                                color: ColorApp.red,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ],
              ),
              ElevatedButton(
                  child: Container(
                    //  margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(isStart == 'start' ? 'Kết thúc' : "Bắt đầu",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.normal)),
                  ),
                  style: ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.padded,
                      shadowColor: MaterialStateProperty.all<Color>(
                          ColorApp.lightOrange),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          ColorApp.mediumOrange),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.transparent)))),
                  onPressed: start),
            ],
          ),
        ));
  }
}
