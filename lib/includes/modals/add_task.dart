import 'dart:convert';

import 'package:FinTask/includes/auth_service.dart';
import 'package:FinTask/includes/colors.dart';
import 'package:FinTask/includes/url.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var logger = Logger();
  final AuthService authService = AuthService();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _password.dispose();
  }

  //  String _selectedDate = '';
  DateTime date = DateTime.now();

  Future<void> addTask() async {
    final userData = await authService.getToken();
    final user = userData['userId'];
    print(date.toString());
    final Map<String, dynamic> data = {
      'owner_id': user,
      'taskName': _name.text,
      'taskDate': date.toString()
    };
    String uri = "${Url.url}/tasks";
    final Uri url = Uri.parse(uri);
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));
    if (response.statusCode == 201) {
      Navigator.of(context).pushNamed("/homecontroller");
      // final responseJson = jsonDecode(response.body);
      setState(() {
        // widget.tasks = responseJson['tasks'];
        // isLoading = false;
      });
    } else {
      logger.e(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: MyColors.backgroundColor,
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(15),
              bottomLeft: Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10.h,
            ),
            makeInput(
              label: "Task Name", keyType: TextInputType.text,
              controller: _name,
              // error: emailErr,
            ),
            SizedBox(
              height: 10.h,
            ),
            makeInput(
              label: "Date",
              keyType: TextInputType.datetime,
              // controller: _password,
              // error: passErr,
            ),
            SizedBox(
              height: 25.h,
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
                    addTask();
                    // Navigator.of(context).pushNamed("/homecontroller");
                    // validateInput();
                  },
                  color: MyColors.primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    "Add Task",
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
    );
  }

  Widget makeInput({label, keyType, controller}) {
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
        (label == 'Date')
            ? TextButton(
                style: const ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                onPressed: () async {
                  DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(1990),
                    lastDate: DateTime(2100),
                  );
                  setState(() {
                    date = newDate!;
                  });
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: const Color.fromRGBO(189, 189, 189, 1),
                              width: 1.0,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          child: Text(
                            '${date.year} - ${date.month} - ${date.day}',
                            style:
                                TextStyle(fontSize: 16.sp, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : TextField(
                keyboardType: keyType,
                controller: controller,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(189, 189, 189, 1)),
                      borderRadius: BorderRadius.circular(15)),
                  border: OutlineInputBorder(
                      // borderSide: BorderSide(color: Color.fromRGBO(189, 189, 189, 1)),
                      borderRadius: BorderRadius.circular(15)),
                ),
              )
      ],
    );
  }
}
