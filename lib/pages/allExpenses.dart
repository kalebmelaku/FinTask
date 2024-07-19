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
import 'package:intl/intl.dart';

class AllExpenses extends StatefulWidget {
  const AllExpenses({super.key});

  @override
  State<AllExpenses> createState() => _AllExpensesState();
}

class _AllExpensesState extends State<AllExpenses> {
  final AuthService authService = AuthService();
  List<dynamic> tasks = [];
  List<dynamic> completedTasks = [];
  final formatCurrency = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
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
        excludeHeaderSemantics: true,
        title: const Text(
          "Today's Expenses",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: MyColors.tertiaryColor,
        elevation: 0,
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
                    SizedBox(
                      height: 10.h,
                    ),
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 65.0,
                          backgroundColor: MyColors.tertiaryColor,
                          child: Text(
                            formatCurrency.format(900000),
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.sp),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            totalCategory(total: 2500, name: "Personal"),
                            totalCategory(total: 3500, name: "Home"),
                            totalCategory(total: 500, name: "Office"),
                            totalCategory(total: 4500, name: "Other"),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        const Divider(
                          thickness: 1.0,
                          color: Colors.white54,
                        ),
                      ],
                    ),
                    (tasks.isEmpty)
                        ? const Center(
                            child: Text("No Expenses Available for today"),
                          )
                        : TasksBox(tasks: tasks),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget totalCategory({required int total, required String name}) {
    return Column(
      children: [
        Text(
          formatCurrency.format(total),
          style: TextStyle(color: Colors.white, fontSize: 15.sp),
        ),
        Text(
          name,
          style: TextStyle(color: Colors.white54, fontSize: 12.sp),
        ),
      ],
    );
  }
}
