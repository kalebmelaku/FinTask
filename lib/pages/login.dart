// ignore_for_file: use_build_context_synchronously
import "dart:convert";
import 'package:FinTask/includes/auth_service.dart';
import 'package:FinTask/includes/colors.dart';
import 'package:FinTask/includes/header.dart';
import 'package:FinTask/includes/url.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  String? emailErr;
  String? passErr;
  String? servErr;
  late Box box1;
  Logger logger = Logger();
  @override
  void initState() {
    super.initState();
    createBox();
  }

  void createBox() async {
    box1 = await Hive.openBox('loginData');
    getData();
  }

  void getData() async {
    if (box1.get("email") != null) {
      setState(() {
        _email.text = box1.get("email");
      });
    }
    if (box1.get("password") != null) {
      _password.text = box1.get("password");
    }
  }

  validateInput() {
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_email.text)) {
      setState(() {
        servErr = "";
        passErr = "";
        emailErr = "Invalid Email Address";
      });
    } else if (_password.text == "") {
      setState(() {
        servErr = "";
        emailErr = "";
        passErr = "Password is required";
      });
    } else {
      setState(() {
        passErr = "";
        emailErr = "";
      });
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => const Home()));
      // loginUser(_email.text, _password.text);
      box1.put('email', _email.text);
      box1.put('password', _password.text);
      AuthService().login(context, _email.text, _password.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Header(
                          pageName: "Login", pageDesc: "Login to your account"),
                      SizedBox(
                        height: 5.h,
                      ),
                      // if (servErr != null)
                      //   Text(
                      //     servErr!,
                      //     style: const TextStyle(color: Colors.redAccent),
                      //   ),
                      SizedBox(
                        height: 50.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: <Widget>[
                            makeInput(
                              label: "Email",
                              obscureText: false,
                              keyType: TextInputType.emailAddress,
                              controller: _email,
                              error: emailErr,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            makeInput(
                              label: "Password",
                              obscureText: true,
                              keyType: TextInputType.visiblePassword,
                              controller: _password,
                              error: passErr,
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            //   children: [
                            //     TextButton(
                            //         onPressed: () => {},
                            //         child: const Text(
                            //           "Forget Password?",
                            //           style: TextStyle(color: Colors.white),
                            //         ))
                            //   ],
                            // ),
                            SizedBox(
                              height: 25.h,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Container(
                          padding: const EdgeInsets.only(top: 3, left: 3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: const Border(
                                bottom: BorderSide(color: Colors.white),
                                top: BorderSide(color: Colors.white),
                                left: BorderSide(color: Colors.white),
                                right: BorderSide(color: Colors.white),
                              )),
                          child: MaterialButton(
                            minWidth: double.infinity,
                            height: 35.h,
                            onPressed: () {
                              HapticFeedback.vibrate();
                              validateInput();
                            },
                            color: MyColors.primaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20.sp,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 3.5,
                  // decoration: const BoxDecoration(
                  //     image: DecorationImage(
                  //   image: AssetImage('assets/login.png'),
                  //   fit: BoxFit.cover,
                  // )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget makeInput({label, obscureText, keyType, controller, error}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      TextField(
        obscureText: obscureText,
        controller: controller,
        keyboardType: keyType,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color.fromRGBO(189, 189, 189, 1)),
              borderRadius: BorderRadius.circular(15)),
          border: OutlineInputBorder(
              // borderSide: BorderSide(color: Color.fromRGBO(189, 189, 189, 1)),
              borderRadius: BorderRadius.circular(15)),
        ),
      ),
      if (error != null)
        Text(
          error,
          style: TextStyle(color: Colors.redAccent, fontSize: 13.sp),
        ),
    ],
  );
}
