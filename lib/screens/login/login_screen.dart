import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utc2_student/screens/login/login_form.dart';
import 'package:utc2_student/utils/utils.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(
              'assets/images/plash.jpg',
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            Container(
              height: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                stops: [
                  0.11,
                  0.4,
                  0.6,
                  .9,
                ],
                colors: [
                  Colors.white.withOpacity(.99),
                  Colors.white10..withOpacity(.1),
                  Colors.white12.withOpacity(.1),
                  Colors.white.withOpacity(.1),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                tileMode: TileMode.clamp,
              )),
              child: Column(
                children: [
                  SizedBox(
                    height: 90,
                  ),
                  Text(
                    'Trường đại học giao thông vận tải\nphân hiệu tại TP.Hồ Chí Minh',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ColorApp.black, fontSize: size.width * 0.05),
                  ),
                  SizedBox(
                    height: 20,
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
                  Spacer(),
                  LoginForm(),
                  Image.asset(
                    "assets/images/path@2x.png",
                    width: size.width,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
