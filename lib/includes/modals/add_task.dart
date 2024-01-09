import 'package:FinTask/includes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  //  String _selectedDate = '';
  DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: MyColors.primaryColorBg,
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
              // controller: _email,
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

  Widget makeInput({label, keyType}) {
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
                    padding: MaterialStatePropertyAll(EdgeInsets.all(0))),
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
