import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:utc2_student/blocs/test_bloc/test_bloc.dart';
import 'package:utc2_student/blocs/test_bloc/test_event.dart';
import 'package:utc2_student/blocs/test_bloc/test_state.dart';
import 'package:utc2_student/service/firestore/class_database.dart';
import 'package:utc2_student/service/firestore/post_database.dart';
import 'package:utc2_student/service/firestore/quiz_database.dart';
import 'package:utc2_student/service/firestore/student_database.dart';
import 'package:utc2_student/utils/utils.dart';

class ScroreScreen extends StatefulWidget {
  final String idTeacher;
  final Student student;
  final Class classUtc;
  final List<Post> listPost;

  const ScroreScreen(
      {Key key, this.idTeacher, this.student, this.classUtc, this.listPost})
      : super(key: key);

  @override
  _ScroreScreenState createState() => _ScroreScreenState();
}

class _ScroreScreenState extends State<ScroreScreen> {
  TestBloc testBloc = new TestBloc();
  List<Quiz> listQuiz = [];
  getQuiz() async {
    if (widget.listPost.isNotEmpty) {
      for (int i = 0; i < widget.listPost.length; i++) {
        var quiz = await QuizDatabase.getOneQuiz(
            widget.idTeacher, widget.listPost[i].idQuiz);
        listQuiz.add(quiz);
      }
    }
  }

  @override
  void initState() {
    testBloc = BlocProvider.of<TestBloc>(context);
    print(widget.classUtc.id);
    print(widget.listPost.length);
    print(widget.student.id);
    testBloc.add(
        GetTestEvent(widget.classUtc.id, widget.listPost, widget.student.id));
    getQuiz();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: ColorApp.lightGrey,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: ColorApp.black,
          ),
        ),
        elevation: 3,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Xem điểm ' + widget.classUtc.name,
          style: TextStyle(color: ColorApp.black),
        ),
      ),
      body: Container(
          height: size.height,
          margin: EdgeInsets.all(size.width * 0.03),
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Bài test'),
                    Text('Số câu'),
                    Text('Điểm'),
                  ],
                ),
              ),
              Divider(),
              BlocListener<TestBloc, TestState>(
                listener: (context, state) {
                  if (state is LoadedTest) {
                    for (var item in state.list) {
                      print(item.score + ' diem');
                    }
                  }
                },
                child:
                    BlocBuilder<TestBloc, TestState>(builder: (context, state) {
                  if (state is LoadingTest) {
                    return Container(
                      child: Center(
                          child: SpinKitThreeBounce(
                        color: Colors.lightBlue,
                        size: size.width * 0.06,
                      )),
                    );
                  } else if (state is LoadedTest) {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: listQuiz.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(listQuiz[index].titleQuiz,
                                        style:
                                            TextStyle(color: ColorApp.black)),
                                  ),
                                  Expanded(
                                    child: Text(
                                      state.list
                                              .where((element) =>
                                                  element.idQuiz ==
                                                      widget.listPost[index]
                                                          .idQuiz &&
                                                  element.idPost ==
                                                      widget.listPost[index].id)
                                              .isNotEmpty
                                          ? state.list
                                              .where((element) =>
                                                  element.idQuiz ==
                                                  listQuiz[index].idQuiz)
                                              .first
                                              .totalAnswer
                                          : '0',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: ColorApp.black),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      state.list
                                              .where((element) =>
                                                  element.idQuiz ==
                                                      widget.listPost[index]
                                                          .idQuiz &&
                                                  element.idPost ==
                                                      widget.listPost[index].id)
                                              .isNotEmpty
                                          ? state.list
                                              .where((element) =>
                                                  element.idQuiz ==
                                                  listQuiz[index].idQuiz)
                                              .first
                                              .score
                                          : '0',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(color: ColorApp.black),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    );
                  } else if (state is LoadErrorTest) {
                    return Center(
                      child: Text(
                        state.error,
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    );
                  } else {
                    return Container(
                      child: Center(
                          child: SpinKitThreeBounce(
                        color: Colors.lightBlue,
                        size: size.width * 0.06,
                      )),
                    );
                  }
                }),
              ),
            ],
          )),
    );
  }
}
