import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/services/base.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:utc2_student/service/firestore/post_database.dart';

import 'package:utc2_student/service/firestore/student_database.dart';
import 'package:utc2_student/service/geo_service.dart';
import 'package:utc2_student/utils/custom_glow.dart';
import 'package:utc2_student/utils/utils.dart';

class AttendanceScreen extends StatefulWidget {
  final Student student;
  final String idClass, idPost, input, time;

  const AttendanceScreen(
      {Key key, this.student, this.idClass, this.idPost, this.input, this.time})
      : super(key: key);
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  TextEditingController _controller = TextEditingController();
  bool isLoading = false, isChecked = false, success = false, isErro = false;
  String code, error = 'Nhập mã điểm danh';

  GeoService geoService = GeoService();
  Future<Position> getLocation() async {
    var currentPosition = await geoService.getCurrentLocation();
    return currentPosition;
  }

  Position location;
  Geocoding geocoding;
  List<Address> results = [];

  Future search(String code) async {
    location = await getLocation();
    setState(() {
      isLoading = true;
    });
    if (location == null) {
      setState(() {
        isLoading = false;
        error = 'Bật dịch vụ vị trí và thử lại';
      });
    } else {
      // if (code == '123') {
      setState(() {
        isLoading = false;
      });
      try {
        var geocoding = Geocoder.local;
        var longitude = location.longitude;
        var latitude = location.latitude;
        var results = await geocoding
            .findAddressesFromCoordinates(new Coordinates(latitude, longitude));
        this.setState(() {
          this.results = results;
        });
        var post = await PostDatabase.getPost(widget.idClass, widget.idPost);
        print(post['idAtten']);
        var status = '';
        var now =
            DateFormat("yyyy-MM-dd HH:mm:ss").parse(DateTime.now().toString());
        var attenTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(widget.time);
        if (code == post['idAtten'] &&
            now.difference(attenTime).inMinutes < 1) {
          status = 'Thành công';
        } else
          status = 'Thất bại';
        StudentDatabase.attend(
            widget.idClass,
            widget.idPost,
            widget.student.id,
            results[0].addressLine.toString(),
            latitude.toString() + ', ' + longitude.toString(),
            status);

        print(results[0].addressLine);
      } catch (e) {
        print("Error occured: $e");
      }
      // finally {
      //   setState(() {
      //     isLoading = false;
      //   });
      // }
      // } else {
      //   setState(() {
      //     isLoading = false;
      //   });
      //   showError('2');
      // }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.text = widget.input;
  }

  void showError(String result) {
    switch (result) {
      case '1':
        setState(() {
          error = 'Nhập mã điểm danh';
        });
        break;
      case '2':
        setState(() {
          error = 'Mã điểm danh không đúng';
        });
        break;
      case '3':
        setState(() {
          error = 'Mã điểm danh hết hạn';
        });
        break;
      case '4':
        setState(() {
          error = 'Bạn đang không có mặt';
        });
        break;
      default:
        break;
    }
  }

  Future _scan() async {
    await Permission.camera.request();
    String barcode = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Hủy", false, ScanMode.DEFAULT);
    if (barcode == null) {
      print('Không tìm thấy mã code');
    } else {
      search(barcode);
    }
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
          'Điểm danh',
          style: TextStyle(color: ColorApp.black),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: Icon(
              Icons.edit,
              color: ColorApp.lightOrange,
              size: 16,
            ),
            label: Text(
              'Lịch sử',
              style: TextStyle(color: ColorApp.lightOrange),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, ColorApp.lightGrey.withOpacity(.4)])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomAvatarGlow(
                glowColor: ColorApp.lightOrange,
                endRadius: 70.0,
                duration: Duration(milliseconds: 2000),
                repeat: true,
                showTwoGlows: true,
                repeatPauseDuration: Duration(milliseconds: 100),
                child: Container(
                  padding: EdgeInsets.all(4),
                  width: 120,
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: ColorApp.lightGrey,
                    backgroundImage: NetworkImage(widget.student.avatar),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Nhập mã điểm danh',
                style: TextStyle(fontSize: size.width * 0.05),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                child: TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                      hintText: 'Mã điểm danh',
                      errorText: isErro ? 'Vui lòng nhập mã' : null),
                  autocorrect: true,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              isLoading
                  ? CircularProgressIndicator()
                  : Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: size.width * 0.06,
                          vertical: results.length > 0 ? size.width * 0.03 : 0),
                      child: Text(results.length > 0
                          ? results[0].addressLine +
                              '\n${location.latitude}      //    ${location.longitude}'
                          : ''),
                    ),
              Center(
                child: ElevatedButton(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: size.width * 0.2, vertical: 10),
                      child: Text("Điểm danh",
                          style: TextStyle(
                              fontSize: size.width * 0.045,
                              letterSpacing: 1,
                              wordSpacing: 1,
                              fontWeight: FontWeight.normal)),
                    ),
                    style: ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize.padded,
                        shadowColor: MaterialStateProperty.all<Color>(
                            ColorApp.lightOrange),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            ColorApp.lightOrange),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: BorderSide(color: Colors.white)))),
                    onPressed: () async {
                      if (_controller.text.isNotEmpty) {
                        search(_controller.text);
                        setState(() {
                          isErro = false;
                        });
                        _controller.text = '';
                      } else {
                        setState(() {
                          isErro = true;
                        });
                      }
                    }),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Hoặc quét mã Code',
                style: TextStyle(fontSize: size.width * 0.042),
              ),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                onPressed: () {
                  // _scan();
                  _scan();
                },
                color: ColorApp.lightOrange,
                textColor: Colors.white,
                child: Icon(
                  Icons.qr_code_scanner_outlined,
                  size: 24,
                ),
                padding: EdgeInsets.all(16),
                shape: CircleBorder(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
