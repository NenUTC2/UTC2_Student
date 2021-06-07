import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:utc2_student/blocs/login_bloc/login_bloc.dart';
import 'package:utc2_student/repositories/google_signin_repo.dart';
import 'package:utc2_student/screens/home_screen.dart';
import 'package:utc2_student/utils/utils.dart';

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
  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
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
              Text(
                'Nhập mã sinh viên của bạn',
                style: TextStyle(fontSize: 17, color: Colors.black54),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: sIdController,
                  // validator: (val) => val.isEmpty || val.length != 10
                  //     ? 'Mã sinh viên bao gồm 10 kí tự'
                  //     : null,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
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
                    return SpinKitThreeBounce(
                      color: ColorApp.lightOrange,
                      size: 30,
                    );
                  else if (state is EnteredSIDState) {
                    return Column(children: [
                      Row(
                        children: [
                          Text('Họ tên: '),
                          Text(state.sinhvienInfo.hoten),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Ngày sinh: '),
                          Text(state.sinhvienInfo.ngaysinh),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Khoá: '),
                          Text(state.sinhvienInfo.khoa),
                        ],
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
                loginBloc.add(
                    SubmitSIDEvent(widget.ggLogin, sIdController.text.trim()));
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
