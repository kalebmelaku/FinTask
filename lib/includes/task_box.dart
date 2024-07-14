// ignore_for_file: must_be_immutable

import 'package:FinTask/includes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class TaskBox extends StatefulWidget {
  late Future<List<dynamic>> tasks;

  TaskBox({super.key, required this.tasks});

  @override
  State<TaskBox> createState() => _TaskBoxState();
}

class _TaskBoxState extends State<TaskBox> {
  TextEditingController dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: MyColors.tertiaryColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: dateController,
                  decoration: const InputDecoration(
                      floatingLabelStyle: null,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: 'Select Date',
                      labelStyle: TextStyle(color: Colors.white),
                      focusColor: Colors.transparent,
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                      ),
                      enabledBorder:
                          OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder:
                          OutlineInputBorder(borderSide: BorderSide.none)),
                  readOnly: true,
                  onTap: _selectDate,
                ),
              ),
              
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/homecontroller");
                },
                color: MyColors.primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  'See More',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: FutureBuilder(
              future: widget.tasks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error:  ${snapshot.error}'),
                  );
                } else {
                  List<dynamic> tasks = snapshot.data as List<dynamic>;
                  return ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: [
                      ...(tasks).map((e) {
                        return CustomTile(
                          taskName: e['name'],
                          date: e['due_date'],
                        );
                      })
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget CustomTile({required taskName, required date}) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = DateFormat("y-MM-DD").format(dateTime.toLocal());

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
                  onPressed: (context) => {},
                  icon: Icons.delete,
                  backgroundColor: Colors.red,
                )
              ],
            ),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) => {},
                  icon: Icons.check,
                  backgroundColor: Colors.green,
                ),
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
                      taskName,
                      style: TextStyle(fontSize: 18.sp),
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: TextStyle(fontSize: 18.sp),
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

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        dateController.text = picked.toString().split(" ")[0];
      });
    }
  }
}
