import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:utc2_student/blocs/notify_app_bloc/notify_app_bloc.dart';
import 'package:utc2_student/blocs/notify_app_bloc/notify_app_event.dart';
import 'package:utc2_student/blocs/notify_app_bloc/notify_app_state.dart';
import 'package:utc2_student/models/content_utc_web.dart';
import 'package:utc2_student/models/event_web.dart';
import 'package:utc2_student/models/notify_web.dart';

import 'package:utc2_student/service/web_wraper_utc/event_utc_web.dart';
import 'package:utc2_student/service/web_wraper_utc/notify_utc_web.dart';
import 'package:utc2_student/utils/utils.dart';
import 'package:flutter/material.dart';

class NotifyPage extends StatefulWidget {
  final String idUser;

  const NotifyPage({Key key, this.idUser}) : super(key: key);
  @override
  _NotifyPageState createState() => _NotifyPageState();
}

class _NotifyPageState extends State<NotifyPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          //elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Thông báo',
            style: TextStyle(color: ColorApp.black),
          ),
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                width: size.width * 0.9,
                height: size.height * 0.06,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: ColorApp.lightGrey),
                child: TabBar(
                  physics: BouncingScrollPhysics(),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey[600],
                  indicatorColor: Colors.transparent,
                  indicator: new BubbleTabIndicator(
                    indicatorHeight: size.height * 0.05,
                    indicatorColor: ColorApp.mediumOrange,
                    tabBarIndicatorSize: TabBarIndicatorSize.tab,
                  ),
                  tabs: [
                    Tab(
                      icon: Container(
                        child: Text(
                          'Thông báo',
                        ),
                      ),
                    ),
                    Tab(
                      icon: Container(
                        child: Center(child: Text('Sự kiện')),
                      ),
                    ),
                    Tab(
                      icon: Container(
                        child: Center(child: Text('Lớp học')),
                      ),
                    ),
                  ],
                ),
              )),
        ),
        body: TabBarView(
          physics: BouncingScrollPhysics(),
          children: [
            NotiWeb(),
            // Container(),
            EventScreen(size: size),
            NotifyApp(
              size: size,
              idUser: widget.idUser,
            )
          ],
        ),
      ),
    );
  }
}

class NotiWeb extends StatefulWidget {
  @override
  _NotiWebState createState() => _NotiWebState();
}

class _NotiWebState extends State<NotiWeb> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final blocNoti = NotiScraper();
  String view = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    blocNoti.fetchProducts();
  }

  void _showBottomSheet(
      BuildContext context, Size size, String title, String time) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.001),
            child: GestureDetector(
              onTap: () {},
              child: DraggableScrollableSheet(
                initialChildSize: 0.5,
                minChildSize: 0.2,
                maxChildSize: .9,
                builder: (_, controller) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20.0),
                        topRight: const Radius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Center(
                            child: Container(
                          margin: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: ColorApp.grey,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(3),
                              topRight: const Radius.circular(3),
                            ),
                          ),
                          height: 3,
                          width: 50,
                        )),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Center(
                            child: Text(
                              title,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(size.width * 0.03),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: ColorApp.mediumOrange,
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/logoUTC.png',
                                        width: size.width * 0.07,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'UTC2',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color:
                                            Colors.blue[200].withOpacity(0.2)),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.timelapse,
                                          color: Color(0xff29166F),
                                          size: 15,
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          time,
                                          style: TextStyle(
                                            color: Color(0xff29166F),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color:
                                            Colors.blue[200].withOpacity(0.2)),
                                    child: Row(children: [
                                      Icon(
                                        Icons.visibility,
                                        color: Color(0xff29166F),
                                        size: 15,
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        view,
                                        overflow: TextOverflow.clip,
                                        softWrap: true,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Color(0xff29166F),
                                        ),
                                      )
                                    ]),
                                  )
                                ])
                              ]),
                        ),
                        Divider(
                          thickness: 0.5,
                          height: 5,
                        ),
                        StreamBuilder<List<Block>>(
                            stream: blocNoti.streamContent,
                            builder: (context, snapshot) {
                              return snapshot.hasData
                                  ? Expanded(
                                      child: ListView.builder(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: size.width * 0.03,
                                            vertical: size.width * 0.03),
                                        controller: controller,
                                        itemCount: 1,
                                        itemBuilder: (_, index) {
                                          view = snapshot.data[0].luotxem;
                                          return Column(
                                            children: List.generate(
                                                snapshot.data.length, (index) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  snapshot.data[index].link !=
                                                          null
                                                      ? InkWell(
                                                          onTap: () {
                                                            launch(snapshot
                                                                .data[index]
                                                                .link);
                                                          },
                                                          child: Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        5),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .blue)),
                                                            child: Text(
                                                              snapshot
                                                                  .data[index]
                                                                  .text
                                                                  .trim(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .justify,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue),
                                                            ),
                                                          ),
                                                        )
                                                      : Text(
                                                          '    ' +
                                                              snapshot
                                                                  .data[index]
                                                                  .text
                                                                  .trim(),
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                  snapshot.data[index]
                                                                  .imgLink ==
                                                              '' ||
                                                          snapshot.data[index]
                                                                  .imgLink ==
                                                              null
                                                      ? Container()
                                                      : Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: snapshot
                                                                .data[index]
                                                                .imgLink,
                                                            // height: size.height * 0.3,
                                                            width: size.width,
                                                            fit:
                                                                BoxFit.fitWidth,
                                                            memCacheWidth: size
                                                                    .width
                                                                    .toInt() *
                                                                2,
                                                          ),
                                                        ),
                                                ],
                                              );
                                            }),
                                          );
                                        },
                                      ),
                                    )
                                  : Container(
                                      child: Center(
                                          child: SpinKitThreeBounce(
                                        color: Colors.lightBlue,
                                        size: size.width * 0.06,
                                      )),
                                    );
                            }),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
      color: Colors.white,
      child: RefreshIndicator(
        color: ColorApp.orange,
        displacement: 60,
        onRefresh: () async {
          await blocNoti.fetchProducts();
        },
        child: StreamBuilder<List<Noti>>(
            stream: blocNoti.stream,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: size.width,
                          margin: EdgeInsets.symmetric(vertical: 7),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                  stops: [0.2, 0.9],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.white, ColorApp.lightGrey])),
                          child: TextButton(
                            onPressed: () {
                              blocNoti.getContent(snapshot.data[index].link);
                              _showBottomSheet(
                                context,
                                size,
                                snapshot.data[index].tieude,
                                snapshot.data[index].thoigian,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                    flex: 3,
                                    child: leading(
                                        size, snapshot.data[index].thoigian)),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  flex: 7,
                                  child: title(snapshot.data[index].tieude),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                  : Container(
                      child: Center(
                          child: SpinKitThreeBounce(
                        color: Colors.lightBlue,
                        size: size.width * 0.06,
                      )),
                    );
            }),
      ),
    );
  }
}

class NotifyApp extends StatefulWidget {
  const NotifyApp({
    Key key,
    @required this.size,
    this.idUser,
  }) : super(key: key);

  final Size size;
  final String idUser;

  @override
  _NotifyAppState createState() => _NotifyAppState();
}

class _NotifyAppState extends State<NotifyApp> {
  NotifyAppBloc notifyAppBloc = new NotifyAppBloc();
  @override
  void initState() {
    notifyAppBloc = BlocProvider.of<NotifyAppBloc>(context);
    notifyAppBloc.add(GetNotifyAppEvent(widget.idUser));
    super.initState();
  }

  String formatTime(String time) {
    DateTime parseDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(time);
    return DateFormat.yMEd('vi').format(parseDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size.height,
      padding: EdgeInsets.symmetric(horizontal: widget.size.width * 0.03),
      child: RefreshIndicator(
        displacement: 20,
        onRefresh: () async {
          notifyAppBloc.add(GetNotifyAppEvent(widget.idUser));
        },
        child: BlocBuilder<NotifyAppBloc, NotifyAppState>(
          builder: (context, state) {
            if (state is LoadingNotifyApp)
              return Container(
                child: Center(
                    child: SpinKitThreeBounce(
                  color: Colors.lightBlue,
                  size: widget.size.width * 0.06,
                )),
              );
            else if (state is LoadedNotifyApp) {
              return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: state.list.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 7),
                      width: widget.size.width,
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
                                    backgroundImage: CachedNetworkImageProvider(
                                        state.list[index].avatar != ''
                                            ? state.list[index].avatar
                                            : 'https://utc2.edu.vn/upload/company/logo-15725982242.png'),
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
                                            formatTime(state.list[index].date),
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
                                        state.list[index].content,
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
            } else if (state is LoadErrorNotifyApp) {
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
                  size: widget.size.width * 0.06,
                )),
              );
            }
          },
        ),
      ),
    );
  }
}

class EventScreen extends StatefulWidget {
  const EventScreen({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final blocEvent = EventScraper();
  void initState() {
    super.initState();

    blocEvent.fetchEvent();
  }

  void _showBottomSheet(
      BuildContext context, Size size, String title, String time, String view) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.001),
            child: GestureDetector(
              onTap: () {},
              child: DraggableScrollableSheet(
                initialChildSize: 0.5,
                minChildSize: 0.2,
                maxChildSize: .9,
                builder: (_, controller) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20.0),
                        topRight: const Radius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Center(
                            child: Container(
                          margin: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: ColorApp.grey,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(3),
                              topRight: const Radius.circular(3),
                            ),
                          ),
                          height: 3,
                          width: 50,
                        )),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Center(
                            child: Text(
                              title,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(size.width * 0.03),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: ColorApp.mediumOrange,
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/logoUTC.png',
                                        width: size.width * 0.07,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'UTC2',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color:
                                            Colors.blue[200].withOpacity(0.2)),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.timelapse,
                                          color: Color(0xff29166F),
                                          size: 15,
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          time,
                                          style: TextStyle(
                                            color: Color(0xff29166F),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color:
                                            Colors.blue[200].withOpacity(0.2)),
                                    child: Row(children: [
                                      Icon(
                                        Icons.visibility,
                                        color: Color(0xff29166F),
                                        size: 15,
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        view,
                                        overflow: TextOverflow.clip,
                                        softWrap: true,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Color(0xff29166F),
                                        ),
                                      )
                                    ]),
                                  )
                                ])
                              ]),
                        ),
                        Divider(
                          thickness: 0.5,
                          height: 5,
                        ),
                        StreamBuilder<List<Block>>(
                            stream: blocEvent.streamContent,
                            builder: (context, snapshot) {
                              return snapshot.hasData
                                  ? Expanded(
                                      child: ListView.builder(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: size.width * 0.03,
                                            vertical: size.width * 0.03),
                                        controller: controller,
                                        itemCount: 1,
                                        itemBuilder: (_, index) {
                                          return Column(
                                            children: List.generate(
                                                snapshot.data.length, (index) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  snapshot.data[index].link !=
                                                          null
                                                      ? InkWell(
                                                          onTap: () {
                                                            launch(snapshot
                                                                .data[index]
                                                                .link);
                                                          },
                                                          child: Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        5),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .blue)),
                                                            child: Text(
                                                              snapshot
                                                                  .data[index]
                                                                  .text
                                                                  .trim(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .justify,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue),
                                                            ),
                                                          ),
                                                        )
                                                      : Text(
                                                          '    ' +
                                                              snapshot
                                                                  .data[index]
                                                                  .text
                                                                  .trim(),
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                  snapshot.data[index]
                                                                  .imgLink ==
                                                              '' ||
                                                          snapshot.data[index]
                                                                  .imgLink ==
                                                              null
                                                      ? Container()
                                                      : Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: snapshot
                                                                .data[index]
                                                                .imgLink,
                                                            // height: size.height * 0.3,
                                                            width: size.width,
                                                            fit:
                                                                BoxFit.fitWidth,
                                                            memCacheWidth: size
                                                                    .width
                                                                    .toInt() *
                                                                2,
                                                          ),
                                                        ),
                                                  index ==
                                                          snapshot.data.length -
                                                              1
                                                      ? Divider(
                                                          height: 10,
                                                          color: ColorApp.black,
                                                          thickness: 1,
                                                        )
                                                      : Container()
                                                ],
                                              );
                                            }),
                                          );
                                        },
                                      ),
                                    )
                                  : Container(
                                      child: Center(
                                          child: SpinKitThreeBounce(
                                        color: Colors.lightBlue,
                                        size: 30,
                                      )),
                                    );
                            }),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: widget.size.height,
      padding: EdgeInsets.symmetric(horizontal: widget.size.width * 0.03),
      child: StreamBuilder<List<Event>>(
          stream: blocEvent.stream,
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? Container(
                    child: Center(
                        child: SpinKitThreeBounce(
                      color: Colors.lightBlue,
                      size: widget.size.width * 0.06,
                    )),
                  )
                : RefreshIndicator(
                    displacement: 60,
                    onRefresh: () async {
                      blocEvent.fetchEvent();
                    },
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data.length < 11
                            ? snapshot.data.length + 1
                            : snapshot.data.length,
                        itemBuilder: (context, index) {
                          return index == snapshot.data.length &&
                                  snapshot.data.length < 11
                              ? Container(
                                  child: Center(
                                      child: SpinKitThreeBounce(
                                    color: Colors.lightBlue,
                                    size: 30,
                                  )),
                                )
                              : Container(
                                  margin: EdgeInsets.symmetric(vertical: 7),
                                  width: widget.size.width,
                                  height: widget.size.width / 3,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.white,
                                            ColorApp.lightGrey
                                          ])),
                                  child: TextButton(
                                    onPressed: () {
                                      blocEvent.getContent(
                                          snapshot.data[index].link);
                                      _showBottomSheet(
                                          context,
                                          size,
                                          snapshot.data[index].tittle,
                                          snapshot.data[index].ngay,
                                          snapshot.data[index].luotxem);
                                    },
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  snapshot.data[index].img,
                                              width: widget.size.width / 3,
                                              fit: BoxFit.fitHeight,
                                              height: 130,
                                              memCacheWidth: 300,
                                              // memCacheHeight: 200,
                                              placeholder: (context, url) =>
                                                  CupertinoActivityIndicator(),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data[index].tittle,
                                                softWrap: true,
                                                textAlign: TextAlign.start,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: ColorApp.black),
                                              ),
                                              Container(
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 5),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          color: Colors
                                                              .blue[200]
                                                              .withOpacity(
                                                                  0.2)),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.timelapse,
                                                            color: Colors.grey,
                                                            size: 15,
                                                          ),
                                                          SizedBox(
                                                            width: 3,
                                                          ),
                                                          Text(
                                                            snapshot.data[index]
                                                                .ngay,
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 12),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 5),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          color: Colors
                                                              .blue[200]
                                                              .withOpacity(
                                                                  0.2)),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.visibility,
                                                            color: Colors.grey,
                                                            size: 15,
                                                          ),
                                                          SizedBox(
                                                            width: 3,
                                                          ),
                                                          Text(
                                                            snapshot.data[index]
                                                                .luotxem,
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 12),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                        }),
                  );
          }),
    );
  }
}

Widget title(String title) {
  return Container(
    child: Text(
      title,
      maxLines: 3,
      style: TextStyle(fontSize: 16, color: ColorApp.black),
      softWrap: true,
      overflow: TextOverflow.ellipsis,
    ),
  );
}

Widget leading(Size size, String date) {
  return Container(
    alignment: Alignment.center,
    margin: EdgeInsets.symmetric(vertical: 5),
    decoration: BoxDecoration(
        border: Border(
          left: BorderSide(width: 3.0, color: ColorApp.red),
        ),
        gradient: LinearGradient(
            stops: [0.2, 0.9],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [ColorApp.lightOrange, ColorApp.mediumOrange])),
    child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 5,
        ),
        Text(
          date.split('-')[0],
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          date.split('-')[1] + "/" + date.split('-')[2],
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        Image.asset(
          'assets/images/path@2x.png',
          fit: BoxFit.fill,
        )
      ],
    ),
  );
}
