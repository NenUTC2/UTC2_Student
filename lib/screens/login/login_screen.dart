import 'package:utc2_student/repositories/user_repository.dart';
import 'package:utc2_student/screens/login/login_form.dart';
import 'package:utc2_student/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  final UserRepository _userRepository;

  const LoginScreen({Key key, UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            height: size.height,
            decoration: BoxDecoration(),
            child: Stack(
              // alignment: Alignment.topCenter,
              // overflow: Overflow.clip,
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          color: Colors.transparent,
                          margin: EdgeInsets.only(top: 10),
                          height: size.height * 0.32,
                          width: size.width,
                          child: CustomPaint(
                            painter: CurvePainter1(),
                          ),
                        ),
                        Container(
                          color: Colors.transparent,
                          height: size.height * 0.32,
                          width: size.width,
                          child: CustomPaint(
                            painter: CurvePainter(),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.06),
                        child: LoginForm()),
                    Spacer(),
                    Image.asset(
                      'assets/images/teaching.png',
                      width: size.width,
                      height: 300,
                      //  fit: BoxFit.fill,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Image.asset(
                      'assets/images/path@2x.png',
                      width: size.width,
                      fit: BoxFit.fill,
                    )
                  ],
                ),
                Positioned(
                  top: 50,
                  child: Container(
                    width: size.width,
                    child: Column(
                      children: [
                        Text(
                          'Trường đại học giao thông vận tải\nphân hiệu tại TP.Hồ Chí Minh',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColorApp.black,
                              fontSize: size.width * 0.05),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: ClipOval(
                            child: Image.asset(
                              "assets/images/logoUTC.png",
                              height: size.width * 0.28,
                              width: size.width * 0.28,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.9);
    path.quadraticBezierTo(
        size.width / 2, size.height * 0.98, size.width, size.height * 0.9);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CurvePainter1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.grey[400];
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.86);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height * 0.86);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
