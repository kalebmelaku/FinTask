import 'package:FinTask/includes/colors.dart';
import 'package:FinTask/includes/top_info.dart';
import 'package:FinTask/state/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/icons8.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/ooui.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String userName;
  late String userEmail;
  late String userPhone;
  late List user;
  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>();
    userName = user.name;
    userEmail = user.email;
    userPhone = user.phone;
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
                        const Iconify(
                          Ic.round_mode_edit,
                          color: Colors.white,
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
                      // shape: BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
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
                      // shape: BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
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
                      // shape: BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
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
