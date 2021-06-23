import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:utc2_student/blocs/login_bloc/login_bloc.dart';
import 'package:utc2_student/repositories/google_signin_repo.dart';
import 'package:utc2_student/scraper/student_info_scraper.dart';
import 'package:utc2_student/screens/home_screen.dart';
import 'package:utc2_student/utils/utils.dart';
import 'package:utc2_student/widgets/loading_widget.dart';

class EnterSIDScreen extends StatefulWidget {
  final GoogleSignInAccount ggLogin;

  EnterSIDScreen({Key key, this.ggLogin}) : super(key: key);

  @override
  _EnterSIDScreenState createState() => _EnterSIDScreenState();
}

class _EnterSIDScreenState extends State<EnterSIDScreen> {
  GoogleSignInRepository ggSignIn = GoogleSignInRepository();
  TextEditingController sIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  LoginBloc loginBloc;
  bool isError = true;
  SinhVien student;
  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Thoát"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Đúng là tôi"),
      onPressed: () {
        Navigator.pop(context);
        loginBloc
            .add(SubmitSIDEvent(widget.ggLogin, sIdController.text.trim()));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Đây đúng là thông tin của bạn ?"),
      content: Container(
        width: double.infinity,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: ColorApp.lightOrange.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
            color: Colors.white,
            border: Border.all(width: 1, color: ColorApp.lightOrange),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text('Họ tên: '),
                Text(student.hoten),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text('Ngày sinh: '),
                Text(student.ngaysinh),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text('Mã sinh viên: '),
                Text(student.msv),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text('Khoá: '),
                Text(student.khoa),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text('Lớp: '),
                Text(student.lop),
              ],
            ),
          ],
        ),
      ),
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        unfocus(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.back();
              ggSignIn.signOut();
            },
          ),
        ),
        floatingActionButton: buttonSubmit(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                '    Vì bạn đang sử dụng tài khoản cá nhân để đăng nhập ngoài phạm vi truy cập của UTC2.',
                style: TextStyle(fontSize: 17, color: ColorApp.black),
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                '    Vui lòng nhập mã sinh viên để xác nhận !',
                style: TextStyle(fontSize: 17, color: ColorApp.black),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: sIdController,
                  keyboardType: TextInputType.number,

                  // validator: (val) => val.isEmpty || val.length != 10
                  //     ? 'Mã sinh viên bao gồm 10 kí tự'
                  //     : null,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'Nhập mã Sinh Viên',
                    hintStyle: TextStyle(
                        color: ColorApp.black.withOpacity(.5),
                        fontWeight: FontWeight.normal,
                        fontSize: 15),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black87, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: ColorApp.mediumOrange, width: 3),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: ColorApp.mediumOrange, width: 3),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.red, width: 3),
                    ),
                  ),
                  onChanged: (val) {
                    if (val.length == 10) {
                      loginBloc.add(EnterSIDEvent(val.trim()));
                    }
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is EnteredSIDState) {
                    setState(() {
                      isError = false;
                    });
                  } else if (state is WrongSIDState) {
                    setState(() {
                      isError = true;
                    });
                  } else if (state is SubmittedSIDState) {
                    Get.to(() => HomeScreen());
                  }
                },
                builder: (context, state) {
                  if (state is UpdatingSIDState || state is SubmittingSIDState)
                    return loadingWidget();
                  else if (state is EnteredSIDState) {
                    student = state.sinhvienInfo;
                    return Column(children: [
                      Row(
                        children: [
                          Text('Họ tên: '),
                          Text(state.sinhvienInfo.hoten),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text('Ngày sinh: '),
                          Text(state.sinhvienInfo.ngaysinh),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text('Mã sinh viên: '),
                          Text(state.sinhvienInfo.msv),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text('Khoá: '),
                          Text(state.sinhvienInfo.khoa),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text('Lớp: '),
                          Text(state.sinhvienInfo.lop),
                        ],
                      ),
                    ]);
                  } else if (state is WrongSIDState)
                    return Text(
                      '   Sai mã sinh viên',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    );
                  else
                    return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonSubmit() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: MaterialButton(
              color: Colors.black87,
              onPressed: () {
                showAlertDialog(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Xác nhận',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ],
      ),
    );
  }
}
