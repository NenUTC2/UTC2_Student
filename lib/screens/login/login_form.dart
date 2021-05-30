import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:utc2_student/blocs/login_bloc/login_bloc.dart';
import 'package:utc2_student/blocs/login_bloc/login_event.dart';
import 'package:utc2_student/blocs/login_bloc/login_state.dart';

import 'package:utc2_student/repositories/user_repository.dart';
import 'package:utc2_student/screens/home_screen.dart';
import 'package:utc2_student/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  const LoginForm({Key key, UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isPass = true;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChange);
    _passwordController.addListener(_onPasswordChange);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailure) {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Login Failure'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Color(0xffffae88),
              ),
            );
        }

        if (state.isSubmitting) {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Logging In...'),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  ],
                ),
                backgroundColor: Color(0xffffae88),
              ),
            );
        }

        if (state.isSuccess) {
          print(FirebaseAuth.instance.currentUser.displayName);
          Get.to(() => HomeScreen());
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Email'),
                SizedBox(
                  height: 3,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.black,
                      ),
                      //labelText: "Email",
                      hintText: 'Mã sinh viên@st.utc2.edu.vn'),
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.always,
                  autocorrect: false,
                  validator: (_) {
                    return !state.isEmailValid ? 'Invalid Email' : null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Text('Mật khẩu'),
                SizedBox(
                  height: 3,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Colors.black),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPass ? isPass = false : isPass = true;
                          });
                        },
                        child: Icon(
                          isPass
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          size: 16,
                        ),
                      ),
                      //labelText: "Password",
                      hintText: '..............'),
                  obscureText: isPass,
                  autovalidateMode: AutovalidateMode.always,
                  autocorrect: false,
                  validator: (_) {
                    return !state.isPasswordValid ? 'Invalid Password' : null;
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: ElevatedButton(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: size.width * 0.2, vertical: 10),
                        child: Text("Đăng nhập",
                            style: TextStyle(
                                fontSize: size.width * 0.045,
                                letterSpacing: 1,
                                wordSpacing: 1,
                                fontWeight: FontWeight.normal)),
                      ),
                      style: ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.padded,
                          shadowColor: MaterialStateProperty.all<Color>(
                              Colors.lightBlue),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(ColorApp.orange),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side: BorderSide(color: Colors.red)))),
                      onPressed: () {
                        if (isButtonEnabled(state)) {
                          _onFormSubmitted();
                        }
                        // print('áda');
                      }),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChange() {
    _loginBloc.add(LoginEmailChange(email: _emailController.text));
  }

  void _onPasswordChange() {
    _loginBloc.add(LoginPasswordChanged(password: _passwordController.text));
  }

  void _onFormSubmitted() {
    _loginBloc.add(LoginWithCredentialsPressed(
        email: _emailController.text, password: _passwordController.text));
  }
}
