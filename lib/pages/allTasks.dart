import 'dart:convert';

import 'package:FinTask/includes/colors.dart';
import 'package:FinTask/includes/tasks_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import "package:FinTask/includes/url.dart";
import "package:FinTask/includes/auth_service.dart";

class AllTasks extends StatefulWidget {
  const AllTasks({super.key});

  @override
  State<AllTasks> createState() => _AllTasksState();
}

class _AllTasksState extends State<AllTasks> {
  final AuthService authService = AuthService();
  List<dynamic> tasks = [];
  List<dynamic> completedTasks = [];
  bool isLoadingTasks = true;
  @override
  void initState() {
    fetchTasks();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchCompletedTasks();
    });
    super.initState();
  }

  Future<void> fetchTasks() async {
    final userData = await authService.getToken();
    final user = userData['userId'];
    String uri = "${Url.url}/upcomingTasks/$user";
    final Uri url = Uri.parse(uri);
    final response = await http.get(url);
    if (response.statusCode == 201) {
      final responseJson = jsonDecode(response.body);
      setState(() {
        tasks = responseJson['tasks'];
        isLoadingTasks = false;
      });
    } else {}
  }

  Future<void> fetchCompletedTasks() async {
    final userData = await authService.getToken();
    final user = userData['userId'];
    String uri = "${Url.url}/completedTasks/$user";
    final Uri url = Uri.parse(uri);
    final response = await http.get(url);
    if (response.statusCode == 201) {
      final responseJson = jsonDecode(response.body);
      setState(() {
        completedTasks = responseJson['tasks'];
        isLoadingTasks = false;
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        excludeHeaderSemantics: true,
        foregroundColor: Colors.white,
        title: const Text(
          "All Tasks",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: MyColors.tertiaryColor,
      ),
      body: SafeArea(
        child: isLoadingTasks
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 16),
                      child: ListView(
                        children: [
                          Text(
                            "Upcoming",
                            style: TextStyle(fontSize: 20.sp),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          (tasks.isEmpty)
                              ? const Center(
                                  child: Text("No Tasks Available for today"),
                                )
                              : TasksBox(tasks: tasks, page: 'task'),
                          SizedBox(
                            height: 20.h,
                          ),
                          Text(
                            "Completed",
                            style: TextStyle(fontSize: 20.sp),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          (completedTasks.isEmpty)
                              ? const Center(
                                  child: Text("No Tasks Available for today"),
                                )
                              : TasksBox(
                                  tasks: completedTasks,
                                  page: 'task',
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
