// ignore_for_file: must_be_immutable

import 'dart:convert';
import "package:FinTask/includes/auth_service.dart";
import 'package:FinTask/includes/colors.dart';
import 'package:FinTask/includes/url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import "package:FinTask/state/user_provider.dart";
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class TasksBox extends StatefulWidget {
  List<dynamic> tasks;
  String page;
  TasksBox({super.key, required this.tasks, required this.page});

  @override
  State<TasksBox> createState() => _TasksBoxState();
}

class _TasksBoxState extends State<TasksBox> {
  final AuthService authService = AuthService();
  // late List<dynamic> _tasks = [];
  List<Widget> taskWidget = [];
  late String userId;
  bool isLoading = true;

  @override
  void initState() {
    userId = '';
    setState(() {
      // _tasks = widget.tasks;
    });
    // print(widget.tasks);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // fetchTasks();
    });

    super.initState();
  }

  Future<void> deleteTask(taskId, status) async {
    final userData = await authService.getToken();
    final user = userData['userId'];
    final page = widget.page;
    final Map<String, dynamic> data = {
      'taskId': taskId,
      'userId': user,
      'page': page,
      'status': status
    };
    String uri = "${Url.url}/tasks";
    final Uri url = Uri.parse(uri);
    final response = await http.delete(url,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));
    if (response.statusCode == 201) {
      // final responseJson = jsonDecode(response.body);
      Navigator.pushNamed(context, '/homecontroller');
      setState(() {
        // widget.tasks = responseJson['tasks'];
        // isLoading = false;
      });
    } else {
      print(response.body);
      isLoading = false;
    }
  }

  Future<void> updateTask(taskId) async {
    final userData = await authService.getToken();
    final user = userData['userId'];
    final page = widget.page;
    final Map<String, dynamic> data = {'taskId': taskId, 'userId': user, 'page': page};
    String uri = "${Url.url}/tasks/confirm";
    final Uri url = Uri.parse(uri);
    final response = await http.put(url,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));
    if (response.statusCode == 201) {
      // final responseJson = jsonDecode(response.body);
      setState(() {
        Navigator.pushNamed(context, '/homecontroller');
        // widget.tasks = responseJson['tasks'];
        isLoading = false;
      });
    } else {
      print(response.body);
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    userId = Provider.of<UserProvider>(context).userId;
    return (widget.tasks.isEmpty)
        ? Center(
            child: Text(
            "No Task Available",
            style: TextStyle(fontSize: 18.sp),
          ))
        : Column(
            children: [
              ...(widget.tasks).map((e) {
                return customTile(
                    task_id: e['task_id'],
                    taskName: e['name'],
                    date: e['due_date'],
                    status: e['status']);
              })
            ],
          );
  }

  Widget customTile(
      {required taskName, required date, required task_id, required status}) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color:
                status == 0 ? MyColors.secondaryColor : MyColors.tertiaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Slidable(
            startActionPane: ActionPane(
              motion: const StretchMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) => {deleteTask(task_id, status)},
                  icon: Icons.delete,
                  backgroundColor: Colors.red,
                )
              ],
            ),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) => {updateTask(task_id)},
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
                      style: TextStyle(fontSize: 15.sp),
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: TextStyle(fontSize: 15.sp),
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
