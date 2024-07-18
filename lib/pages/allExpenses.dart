import 'dart:convert';

import 'package:FinTask/includes/colors.dart';
import 'package:FinTask/includes/tasks_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import "package:FinTask/includes/url.dart";
import "package:FinTask/includes/auth_service.dart";

class AllExpenses extends StatefulWidget {
  const AllExpenses({super.key});

  @override
  State<AllExpenses> createState() => _AllExpensesState();
}

class _AllExpensesState extends State<AllExpenses> {
  final AuthService authService = AuthService();
  List<dynamic> tasks = [];
  List<dynamic> completedTasks = [];
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
    String uri = "${Url.url}/todayExpense/$user";
    final Uri url = Uri.parse(uri);
    final response = await http.get(url);
    if (response.statusCode == 201) {
      final responseJson = jsonDecode(response.body);
      setState(() {
        tasks = responseJson['tasks'];
      });
    } else {
      // print(response.body);
    }
  }

  Future<void> fetchCompletedTasks() async {
    final userData = await authService.getToken();
    final user = userData['userId'];
    String uri = "${Url.url}/pastExpense/$user";
    final Uri url = Uri.parse(uri);
    final response = await http.get(url);
    if (response.statusCode == 201) {
      final responseJson = jsonDecode(response.body);
      setState(() {
        completedTasks = responseJson['tasks'];
      });
    } else {
      // print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          "All Tasks",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: MyColors.backgroundColor,
        actions: const [],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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
                        : TasksBox(tasks: tasks),
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
                        : TasksBox(tasks: completedTasks),
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
