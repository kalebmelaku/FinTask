import 'package:FinTask/includes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TasksBox extends StatefulWidget {
  const TasksBox({super.key});

  @override
  State<TasksBox> createState() => _TasksBoxState();
}

class _TasksBoxState extends State<TasksBox> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: MyColors.tertiaryColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0))),
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          CustomTile(),
          CustomTile(),
          CustomTile(),
          CustomTile(),
          CustomTile(),
        ],
      ),
    ));
  }

  Widget CustomTile() {
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
              padding:  EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      "Go to School",
                      style: TextStyle(fontSize: 18.sp),
                    ),
                  ),
                  Text(
                    "2024/4/2",
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
}

void doNothing(BuildContext context) {}
