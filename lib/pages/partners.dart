import 'dart:convert';

import 'package:FinTask/includes/colors.dart';
import 'package:FinTask/state/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:FinTask/includes/url.dart';
import 'package:http/http.dart' as http;
import '../includes/header.dart';

class Partners extends StatefulWidget {
  const Partners({super.key});

  @override
  State<Partners> createState() => _PartnersState();
}

class _PartnersState extends State<Partners> {
  var logger = Logger();
  late String userId;
  final TextEditingController _name = TextEditingController();
  List<dynamic> partners = [];
  @override
  void initState() {
    userId = '';
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPartner();
    });
  }

  Future<Map<String, dynamic>> addPartner() async {
    final Map<String, dynamic> data = {'owner_id': userId, 'name': _name.text};
    final String baseUrl = '${Url.url}/partner';
    final Uri url = Uri.parse(baseUrl);
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));
    final responseData = json.decode(response.body);
    if (response.statusCode == 201) {
      // final resData = jsonDecode(response.body);
      Navigator.pushReplacementNamed(context, "/partners");
      // Navigator.pushNamed(context, "/partners");
    } else {
      logger.e(response.body);
    }

    return responseData;
  }

  Future<void> fetchPartner() async {
    String uri = "${Url.url}/partner/$userId";
    final Uri url = Uri.parse(uri);
    final response = await http.get(url);
    if (response.statusCode == 201) {
      final responseJson = jsonDecode(response.body);
      setState(() {
        partners = responseJson['tasks'];
      });
    } else {}
  }

  Future<void> deletePartner(taskId) async {
    // final Map<String, dynamic> data = {'taskId': taskId, 'userId': userId};
    String uri = "${Url.url}/partner/$taskId";
    final Uri url = Uri.parse(uri);
    final response = await http.delete(url);
    if (response.statusCode == 201) {
      Navigator.pushReplacementNamed(context, "/partners");
    } else {
      logger.e(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    userId = Provider.of<UserProvider>(context).userId;
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        excludeHeaderSemantics: true,
        title: const Text(
          "Partners",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: MyColors.tertiaryColor,
        elevation: 0,
        actions: const [],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Header(
                    pageName: "Partners", pageDesc: "Add Credit Partner"),
                SizedBox(
                  height: 25.h,
                ),
                SizedBox(
                  height: 0.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: <Widget>[
                      makeInput(
                        label: "Name",
                        obscureText: false,
                        keyType: TextInputType.text,
                        controller: _name,
                      ),
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
                        addPartner();
                        // Navigator.of(context)
                        //     .pushNamed("/homecontroller");
                      },
                      color: MyColors.primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Text(
                        "Add Partner",
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
                Text(
                  "Partners",
                  style: TextStyle(fontSize: 16.sp),
                ),
                SizedBox(
                  height: 10.h,
                ),
                (partners.isEmpty
                    ? const Center(
                        child: Text("No Partners Available"),
                      )
                    : Column(
                        children: [
                          ...(partners).map((e) {
                            return customTile(
                                partName: e['name'], partId: e['id']);
                          })
                        ],
                      ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customTile({required partName, required partId}) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: MyColors.secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Slidable(
            startActionPane: ActionPane(
              motion: const StretchMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) => {deletePartner(partId)},
                  icon: Icons.delete,
                  backgroundColor: Colors.red,
                )
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      partName,
                      style: TextStyle(fontSize: 15.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 10.h),
      ],
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
