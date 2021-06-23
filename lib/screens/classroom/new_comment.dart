import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utc2_student/blocs/comment_bloc/comment_bloc.dart';
import 'package:utc2_student/blocs/comment_bloc/comment_event.dart';
import 'package:utc2_student/blocs/comment_bloc/comment_state.dart';
import 'package:utc2_student/service/firestore/class_database.dart';
import 'package:utc2_student/service/firestore/comment_database.dart';
import 'package:utc2_student/service/firestore/post_database.dart';
import 'package:utc2_student/service/firestore/push_noti_firebase.dart';
import 'package:utc2_student/service/firestore/student_database.dart';
import 'package:utc2_student/utils/utils.dart';
import 'package:utc2_student/widgets/loading_widget.dart';

class NewCommentClass extends StatefulWidget {
  final Student student;
  final Class utcClass;
  final Post post;
  NewCommentClass({this.student, this.utcClass, this.post});
  @override
  _NewCommentClassState createState() => _NewCommentClassState();
}

class _NewCommentClassState extends State<NewCommentClass> {
  CommentBloc commentBloc = new CommentBloc();
  String formatTime(String time) {
    DateTime parseDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(time);
    return DateFormat.yMMMEd('vi').format(parseDate);
  }

  CommentDatabase commentDatabase = new CommentDatabase();
  bool error = false;
  String content;
  @override
  void initState() {
    commentBloc = BlocProvider.of<CommentBloc>(context);
    commentBloc.add(GetCommentEvent(widget.utcClass.id, widget.post.id));
    print(widget.utcClass.id + widget.post.id);
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
              Icons.close_rounded,
              color: ColorApp.black,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Nhận xét của lớp học',
            style: TextStyle(color: ColorApp.black),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  commentBloc
                      .add(GetCommentEvent(widget.utcClass.id, widget.post.id));
                },
                icon: Icon(
                  Icons.refresh_rounded,
                  color: Colors.lightBlue,
                ))
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: ColorApp.orange.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(3, -3), // changes position of shadow
              ),
            ],
          ),
          child: TextField(
            onChanged: (val) {
              if (val.isEmpty) {
                setState(() {
                  error = true;
                  content = val;
                });
              } else
                setState(() {
                  error = false;
                  content = val;
                });
            },
            style: TextStyle(fontSize: 16, color: ColorApp.mediumOrange),
            decoration: InputDecoration(
                errorText: error ? 'Vui lòng thêm nhận xét' : null,
                suffixIcon: IconButton(
                  onPressed: () async {
                    if (content != null) {
                      var idComment = generateRandomString(5);
                      final prefs = await SharedPreferences.getInstance();
                      String token = prefs.getString('token');
                      Map<String, String> dataComment = {
                        'id': idComment,
                        'idClass': widget.utcClass.id,
                        'idPost': widget.post.id,
                        'content': content,
                        'name': widget.student.name,
                        'avatar': widget.student.avatar,
                        'date': DateTime.now().toString(),
                      };
                      commentDatabase.createComment(dataComment,
                          widget.utcClass.id, widget.post.id, idComment);

                      commentBloc.add(
                          GetCommentEvent(widget.utcClass.id, widget.post.id));
                      setState(() {
                        error = false;
                      });
                      var response = await PushNotiFireBaseAPI.pushNotiTopic(
                        widget.student.name + ' đã thêm nhận xét mới',
                        content,
                        {
                          'idNoti': 'newNoti',
                          "isAtten": false,
                          "msg": 'student post',
                          "idChannel": widget.utcClass.id,
                          "className": widget.utcClass.name,
                          "classDescription": widget.utcClass.note,
                          "timeAtten": null,
                          "idQuiz": null,
                          "token": token,
                          'name': widget.student.name,
                          'avatar': widget.student.avatar,
                          "content": widget.utcClass.name +
                              "\nĐã nhận xét bài viết của " +
                              widget.post.name +
                              '\n' +
                              content,
                        },
                        widget.utcClass.id,
                      );
                      if (response.statusCode == 200) {
                        print('success');
                      } else
                        print('fail');
                    } else {
                      setState(() {
                        error = true;
                      });
                    }
                  },
                  icon: Icon(Icons.send),
                ),
                hintText: 'Thêm nhận xét của lớp học',
                contentPadding: EdgeInsets.all(size.width * 0.03)),
          ),
        ),
        body: Container(
          height: size.height,
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
          child: RefreshIndicator(
            displacement: 60,
            onRefresh: () async {
              commentBloc
                  .add(GetCommentEvent(widget.utcClass.id, widget.post.id));
            },
            child: BlocBuilder<CommentBloc, CommentState>(
                builder: (context, state) {
              if (state is LoadingComment)
                return loadingWidget();
              else if (state is LoadedComment) {
                return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: state.list.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 7),
                        width: size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Colors.white, ColorApp.lightGrey])),
                        child: TextButton(
                          onPressed: () {},
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    child: CircleAvatar(
                                      backgroundColor: ColorApp.lightGrey,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              state.list[index].avatar),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              state.list[index].name,
                                              style: TextStyle(
                                                  color: ColorApp.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              formatTime(
                                                  state.list[index].date),
                                              style: TextStyle(
                                                  color: ColorApp.black
                                                      .withOpacity(.4)),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          state.list[index].content ?? 'null',
                                          softWrap: true,
                                          maxLines: 10,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                              color: ColorApp.black,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              } else if (state is LoadErrorComment) {
                return Center(
                  child: Text(
                    state.error,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                );
              } else {
                return loadingWidget();
              }
            }),
          ),
        ));
  }
}
