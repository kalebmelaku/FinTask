import 'package:FinTask/includes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopInfo extends StatefulWidget {
  const TopInfo({super.key});

  @override
  State<TopInfo> createState() => _TopInfoState();
}

class _TopInfoState extends State<TopInfo> {
  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: MyColors.secondaryColor,
              radius: 25,
            ),
            SizedBox(
              width: 15.w,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 151, 151, 151),
                      fontSize: 18.sp),
                ),
                Text(
                  "Name",
                  style: TextStyle(color: Colors.white, fontSize: 20.sp),
                ),
              ],
            )
          ],
        ),
        IconButton(
          onPressed: () => {},
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
