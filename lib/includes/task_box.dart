import 'package:FinTask/includes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class TaskBox extends StatelessWidget {
  late Future<List<dynamic>> tasks;
  TaskBox({super.key, required this.tasks});

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
        child: FutureBuilder(
          future: tasks,
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
}
