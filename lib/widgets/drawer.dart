import 'package:utc2_student/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  final Function(String) linkWeb;

  const CustomDrawer({this.linkWeb});
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  List service = [
    {
      'title': 'Trang chủ',
      'icon': Icons.home_rounded,
      'link': 'https://utc2.edu.vn/'
    },
    {
      'title': 'Xem điểm',
      'icon': Icons.table_view,
      'link':
          'http://xemdiem.utc2.edu.vn/svxemdiem.aspx?ID=5851071044&m_lopID=C%C3%B4ng%20ngh%E1%BB%87%20th%C3%B4ng%20tin%20K58&m_lopID_ID=5321&istinchi=1'
    },
     {
      'title': 'Đánh giá rèn luyện',
      'icon': Icons.night_shelter,
      'link': 'http://smart.utc2.edu.vn:8383/HTDRL/login.jsp;jsessionid=9F42BD32BC8BD2542813A97D57DA101A'
    },
     {
      'title': 'Đóng học phí',
      'icon': Icons.table_view,
      'link':
          'http://nophocphi.utc2.edu.vn/'
    },
    {
      'title': 'Đánh giá công tác Cố vấn học tập, Chủ nhiệm lớp',
      'icon': Icons.night_shelter,
      'link': 'http://smart.utc2.edu.vn:85/cvht/sv/login.jsp'
    },
    {
      'title': 'Đăng ký học phần',
      'icon': Icons.fact_check,
      'link': 'http://dangkyhoc.utc2.edu.vn/TaiKhoan/#'
    },
    {
      'title': 'Đăng ký nội trú ký túc xá',
      'icon': Icons.storage,
      'link': 'http://ktx.utc2.edu.vn/Default/Login'
    },
     {
      'title': 'Tra cứu phòng ở ký túc xá',
      'icon': Icons.storage,
      'link': 'http://nophocphi.utc2.edu.vn/tracuu_ktx.aspx'
    },
     {
      'title': 'Đăng ký cấp lại thẻ sinh viên',
      'icon': Icons.storage,
      'link': 'http://smart.utc2.edu.vn/dvsv/vi-vn'
    },
     {
      'title': 'Đăng ký cấp bảng điểm',
      'icon': Icons.storage,
      'link': 'http://smart.utc2.edu.vn/dvsv/vi-vn'
    },
    {
      'title': 'Đăng ký giấy xác nhận sinh viên',
      'icon': Icons.badge,
      'link': 'http://smart.utc2.edu.vn/dvsv/vi-vn'
    },
    {
      'title': 'Đăng ký giấy xác nhận vay vốn',
      'icon': Icons.badge,
      'link': 'http://smart.utc2.edu.vn/dvc/vi-vn'
    },
    {
      'title': 'Đăng ký giấy trợ cấp ưu đãi giáo dục',
      'icon': Icons.airport_shuttle,
      'link': 'http://smart.utc2.edu.vn/dvsv/vi-vn'
    },
    {
      'title': 'Đăng ký cấp biên lai thu học phí',
      'icon': Icons.date_range,
      'link': 'http://smart.utc2.edu.vn/dvsv/vi-vn'
    },
    {
      'title': 'Đăng ký giấy xác nhận đã bảo vệ tốt nghiệp',
      'icon': Icons.night_shelter,
      'link': 'http://smart.utc2.edu.vn/dvsv/vi-vn'
    },
    {
      'title': 'Đăng ký giấy xác nhận đoàn viên',
      'icon': Icons.night_shelter,
      'link': 'http://smart.utc2.edu.vn/dvsv/vi-vn/'
    },
    {
      'title': 'Đăng ký rút hồ sơ đoàn viên',
      'icon': Icons.night_shelter,
      'link': 'http://smart.utc2.edu.vn/dvsv/vi-vn'
    },
    {
      'title': 'Đăng ký thi lần 2, 3',
      'icon': Icons.night_shelter,
      'link': 'http://thidilan2.utc2.edu.vn/'
    },{
      'title': 'Đăng ký học kỳ phụ',
      'icon': Icons.night_shelter,
      'link': 'http://dangkyhoclai.utc2.edu.vn/'
    },
   
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
        child: Container(
      color: Colors.white,
      child: new ListView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          GestureDetector(
            onTap: () {
              //   homeTab();
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03, vertical: size.width * 0.02),
              height: AppBar().preferredSize.height,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: ColorApp.blue.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: CachedNetworkImage(
                imageUrl:
                    'https://utc2.edu.vn/upload/company/logo-15725982242.png',
              ),
            ),
          ),
          Container(
            height: size.height - AppBar().preferredSize.height * 2,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, ColorApp.lightGrey])),
            child: ListView.builder(
              itemCount: service.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(
                      color: ColorApp.grey,
                      width: .2,
                    ),
                  )),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.linkWeb(service[index]['link']);
                    },
                    leading: Icon(
                      service[index]['icon'],
                      color: ColorApp.black.withOpacity(.8),
                      // size: 14,
                    ),
                    title: Text(
                      service[index]['title'].toString(),
                      style: TextStyle(
                          color: ColorApp.black.withOpacity(.8),
                          fontSize: size.width * 0.042,
                          wordSpacing: 1.2,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    ));
  }
}
