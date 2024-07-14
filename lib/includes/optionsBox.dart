import 'package:FinTask/includes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OptionsBox extends StatelessWidget {
  final String title;
  final Widget icon;
  const OptionsBox({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => {
            Navigator.of(context).pushNamed("/$title")
          },
          child: Container(
            padding: EdgeInsets.all(10.h),
            decoration: BoxDecoration(
              color: MyColors.tertiaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: ClipRRect(child: icon),
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(
          title,
          style: TextStyle(fontSize: 12.sp),
        )
      ],
    );
  }
}
