import 'dart:async';
import 'package:flutter/material.dart';
import 'package:utc2_student/utils/utils.dart';

class QuizSreen extends StatefulWidget {
  @override
  _QuizSreenState createState() => _QuizSreenState();
}

class _QuizSreenState extends State<QuizSreen> {
  int selectedRadio;
  bool start = false;

  final interval = const Duration(seconds: 1);

  final int timerMaxSeconds = 65;

  int currentSeconds = 0;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout([int milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) {
          timer.cancel();
          start = false;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
  }

  int totalAnswer = 2;
  List questionList = [
    {
      'Question':
          'A TextSpan is an immutable span of text. It has style property to give style to the text. It is also having children property to add more text to this widget and give style to the children.',
      'Option1': 'Python',
      'Option2': 'dart',
      'Option3': 'Java',
      'Option4': 'C#',
      'Correct': 3,
    },
    {
      'Question': 'What is API',
      'Option1':
          'TextSpan is an immutable span of text. It has style property to give style to the text. It is also having children property to add more text to this widget and give style to the children.',
      'Option2': 'dart',
      'Option3': 'Java',
      'Option4': 'C#',
      'Correct': 1,
    },
    {
      'Question': 'Xin chào',
      'Option1': 'UTC2',
      'Option2': 'GSA',
      'Option3': 'GTVT',
      'Option4': '',
      'Correct': 4,
    }
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(size.width * 0.03),
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: QuizTitle(
                title: 'Test C#',
                time: timerText,
                totalQuestion: totalAnswer.toString() +
                    "/" +
                    questionList.length.toString(),
                start: () {
                  startTimeout();
                  setState(() {
                    start = true;
                  });
                },
              ),
            ),
            SizedBox(
              height: size.width * 0.03,
            ),
            Flexible(
              flex: 5,
              child: AnimatedCrossFade(
                secondChild: Container(),
                firstCurve: Curves.easeInOutSine,
                crossFadeState: start
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: Duration(milliseconds: 500),
                firstChild: Container(
                  width: size.width,
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
                  child: Scrollbar(
                    child: ListView.builder(
                        padding: EdgeInsets.all(size.width * 0.03),
                        itemCount: questionList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Question(
                              number: index,
                              question: questionList[index]['Question'],
                              option1: Option(
                                answer: questionList[index]['Option1'],
                                value: 1,
                                selectedRadio: selectedRadio,
                                setSelectedRadio: (val) {
                                  setState(() {
                                    selectedRadio = val;
                                  });
                                },
                              ),
                              option2: Option(
                                answer: questionList[index]['Option2'],
                                value: 2,
                                selectedRadio: selectedRadio,
                                setSelectedRadio: (val) {
                                  setState(() {
                                    selectedRadio = val;
                                  });
                                },
                              ),
                              option3: Option(
                                answer: questionList[index]['Option3'],
                                value: 3,
                                selectedRadio: selectedRadio,
                                setSelectedRadio: (val) {
                                  setState(() {
                                    selectedRadio = val;
                                  });
                                },
                              ),
                              option4: Option(
                                answer: questionList[index]['Option4'],
                                value: 4,
                                selectedRadio: selectedRadio,
                                setSelectedRadio: (val) {
                                  setState(() {
                                    selectedRadio = val;
                                  });
                                },
                              ),
                            ),
                          );
                        }),
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
  final int value;
  final int selectedRadio;
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

class Question extends StatelessWidget {
  final String question;
  final int number;
  final Widget option1;
  final Widget option2;
  final Widget option3;
  final Widget option4;

  Question(
      {this.question,
      this.number,
      this.option1,
      this.option2,
      this.option3,
      this.option4});
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
            (number + 1).toString() + '. ' + question,
            style: TextStyle(
                color: ColorApp.black,
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
          option1,
          option2,
          option3,
          option4
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
  QuizTitle({this.title, this.time, this.totalQuestion, this.start});
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
                    child: Text("Bắt đầu",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.normal)),
                  ),
                  style: ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.padded,
                      shadowColor:
                          MaterialStateProperty.all<Color>(Colors.lightBlue),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(ColorApp.mediumOrange),
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
