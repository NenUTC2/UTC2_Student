import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:utc2_student/utils/utils.dart';

class NewCommentClass extends StatefulWidget {
  @override
  _NewCommentClassState createState() => _NewCommentClassState();
}

class _NewCommentClassState extends State<NewCommentClass> {
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
              onPressed: () {
                print('refresh');
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
        child: TextFormField(
          style: TextStyle(fontSize: 16, color: ColorApp.mediumOrange),
          decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  print('sennd-----------------------------');
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
          onRefresh: () {},
          child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: 3,
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
                                backgroundImage: CachedNetworkImageProvider(
                                    'https://lh3.googleusercontent.com/a/AATXAJz3f95XAgjw2BkmaR53xLtc4wV8Q2dOY-5JXKrd=s96-c'),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Trần Quốc Khánh',
                                        style: TextStyle(
                                            color: ColorApp.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '07 th 6',
                                        style: TextStyle(
                                            color:
                                                ColorApp.black.withOpacity(.4)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'ttps://lh3.googleusercontent.com/a/AATXAJz3f95XAgjw2BkmaR5lh3.googleusercontent.com/a/AATXAJz3f95XAgjw2BkmaR53xLtc4wV8Q2dOY-5JXKrd=s96-c',
                                    softWrap: true,
                                    maxLines: 5,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                        color: ColorApp.black, fontSize: 15),
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
              }),
        ),
      ),
    );
  }
}
