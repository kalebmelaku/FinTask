import 'dart:convert';

import 'package:FinTask/includes/colors.dart';
import 'package:FinTask/includes/top_info.dart';
import 'package:FinTask/includes/url.dart';
import 'package:FinTask/state/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/ooui.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String userName;
  late String userEmail;
  late String userPhone;
  late String userId;
  late List user;
  Logger logger = Logger();
  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  Future<Map<String, dynamic>> updateUser() async {
    final Map<String, dynamic> data = {
      'name': name.text,
      'phone': phone.text,
      'email': email.text,
      'password': password.text,
      'userId': userId
    };
    final String baseUrl = '${Url.url}/users';
    final Uri url = Uri.parse(baseUrl);
    final response = await http.put(url,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));
    final responseData = json.decode(response.body);
    if (response.statusCode == 201) {
      Navigator.pushReplacementNamed(context, "/login");
    } else {
      logger.e(response);
    }
    return responseData;
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>();
    userName = user.name;
    userEmail = user.email;
    userPhone = user.phone;
    userId = user.userId;
    // user = Provider.of<UserProvider>(context).name;
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const TopInfo(),
              SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.manual,
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          userName,
                          style: TextStyle(fontSize: 20.sp),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    const Divider(),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Personal Settings",
                            style: TextStyle(fontSize: 15.sp)),
                        IconButton(
                          onPressed: () => {
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return Container(
                                  height: MediaQuery.of(context).size.height/1.1,
                                  color: MyColors.backgroundColor,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8),
                                    child: SafeArea(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Text("Update Profile",
                                              style: TextStyle(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold)),
                                          makeInput(
                                            label: "Name",
                                            obscureText: false,
                                            keyType: TextInputType.text,
                                            controller: name,
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          makeInput(
                                            label: "Phone",
                                            obscureText: false,
                                            keyType: TextInputType.text,
                                            controller: phone,
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          makeInput(
                                            label: "Email",
                                            obscureText: false,
                                            keyType: TextInputType.emailAddress,
                                            controller: email,
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          makeInput(
                                            label: "Password",
                                            obscureText: true,
                                            keyType:
                                                TextInputType.visiblePassword,
                                            controller: password,
                                          ),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 40),
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  top: 3, left: 3),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  border: const Border(
                                                    bottom: BorderSide(
                                                        color: Colors.white),
                                                    top: BorderSide(
                                                        color: Colors.white),
                                                    left: BorderSide(
                                                        color: Colors.white),
                                                    right: BorderSide(
                                                        color: Colors.white),
                                                  )),
                                              child: MaterialButton(
                                                minWidth: double.infinity,
                                                height: 35.h,
                                                onPressed: () {
                                                  updateUser();
                                                },
                                                color: MyColors.primaryColor,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Text(
                                                  "Update",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 20.sp,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          },
                          icon: const Iconify(
                            Ic.round_mode_edit,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    ListTile(
                      tileColor: MyColors.tertiaryColor,
                      title: Text(
                        "Name",
                        style: TextStyle(color: Colors.white, fontSize: 15.sp),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(
                          userName,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      trailing: const Iconify(
                        Ooui.user_avatar,
                        color: Color(0x47d9d9d9),
                        size: 40,
                      ),
                      shape: const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18))),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    ListTile(
                      tileColor: MyColors.tertiaryColor,
                      title: Text(
                        "Email",
                        style: TextStyle(color: Colors.white, fontSize: 15.sp),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(
                          userEmail,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      trailing: const Iconify(
                        MaterialSymbols.alternate_email,
                        color: Color(0x47d9d9d9),
                        size: 40,
                      ),
                      shape: const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18))),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    ListTile(
                      tileColor: MyColors.tertiaryColor,
                      title: Text(
                        "Phone",
                        style: TextStyle(color: Colors.white, fontSize: 15.sp),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(
                          userPhone,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      trailing: const Iconify(
                        Ic.baseline_phone_enabled,
                        color: Color(0x47d9d9d9),
                        size: 40,
                      ),
                      shape: const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18))),
                    ),
                  ],
                ),
              ),
            ],
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
