import 'package:FinTask/includes/colors.dart';
import 'package:FinTask/includes/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confPassword = TextEditingController();
  late var info = '';
  late String pin;
  String? nameErr;
  String? emailErr;
  String? passErr;
  String? confPassErr;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height / 9,
                ),
                const Header(pageName: "Signup", pageDesc: "Create an account"),
                // if (servErr != null)
                //   Text(
                //     servErr!,
                //     style: const TextStyle(color: Colors.redAccent),
                //   ),
                SizedBox(
                  height: 25.h,
                ),
                Column(
                  children: <Widget>[
                    makeInput(
                      label: "Full Name",
                      controller: _name,
                      keyType: TextInputType.text,
                      error: nameErr,
                    ),
                    makeInput(
                      label: "Email",
                      controller: _email,
                      keyType: TextInputType.emailAddress,
                      error: emailErr,
                    ),
                    makeInput(
                      label: "Password",
                      obscureText: true,
                      controller: _password,
                      keyType: TextInputType.visiblePassword,
                      error: passErr,
                    ),
                    makeInput(
                      label: "Confirm Password",
                      obscureText: true,
                      controller: _confPassword,
                      keyType: TextInputType.visiblePassword,
                      error: confPassErr,
                    ),
                    SizedBox(
                      height: 15.h,
                    )
                  ],
                ),
                Container(
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
                      // validateInput();
                      Navigator.of(context).pushNamed("/homecontroller");
                    },
                    color: MyColors.primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      "Signup",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Already have an account?",
                      overflow: TextOverflow.visible,
                      style: TextStyle(fontSize: 15.sp),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed("/login");
                      },
                      child: Text(
                        " login",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18.sp),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    
  }
}

Widget makeInput(
    {label, obscureText = false, labelText = "", controller, keyType, error}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyType,
        decoration: InputDecoration(
          fillColor: Colors.white,
          labelText: labelText,
          labelStyle: TextStyle(fontSize: 14.sp, color: Colors.white),
          floatingLabelBehavior: FloatingLabelBehavior.never,
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
      SizedBox(
        height: 15.h,
      ),
    ],
  );
}
