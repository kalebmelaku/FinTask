// ignore_for_file: use_build_context_synchronously

import 'package:FinTask/includes/auth_service.dart';
import 'package:FinTask/includes/colors.dart';
import 'package:FinTask/state/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class TopInfo extends StatefulWidget {
  const TopInfo({super.key});

  @override
  State<TopInfo> createState() => _TopInfoState();
}

class _TopInfoState extends State<TopInfo> {
  late String userName;

  @override
  void initState() {
    super.initState();
    userName = '';
  }

  @override
  Widget build(BuildContext context) {
    userName = Provider.of<UserProvider>(context).name;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            // CircleAvatar(
            //   backgroundColor: MyColors.secondaryColor,
            //   radius: 25,
            // ),
            // SizedBox(
            //   width: 15.w,
            // ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 151, 151, 151),
                      fontSize: 15.sp),
                ),
                Text(
                  userName.split(" ")[0],
                  style: TextStyle(color: Colors.white, fontSize: 18.sp),
                ),
              ],
            )
          ],
        ),
        IconButton(
          onPressed: () async {
            bool state = await AuthService().removeToken();
            if (state) {
              Navigator.pushReplacementNamed(context, "/login");
            }
          },
          icon: const Icon(
            Icons.exit_to_app,
            size: 30,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
