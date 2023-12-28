import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Header extends StatelessWidget {
  final String pageName;
  final String pageDesc;
  const Header(
      {super.key,
      required this.pageName,
      required this.pageDesc});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          pageName,
          style: TextStyle(fontSize: 35.sp, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          pageDesc,
          style: TextStyle(fontSize: 18.sp,),
        ),
      ],
    );
  }
}
