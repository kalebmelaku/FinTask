// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:FinTask/includes/auth_service.dart';
import 'package:FinTask/includes/colors.dart';
import 'package:FinTask/includes/url.dart';
import 'package:FinTask/state/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ExpenseBox extends StatefulWidget {
  List<dynamic> expenses;
  ExpenseBox({super.key, required this.expenses});

  @override
  State<ExpenseBox> createState() => _ExpenseBoxState();
}

class _ExpenseBoxState extends State<ExpenseBox> {
  var logger = Logger();
  final formatCurrency = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
  final AuthService authService = AuthService();
  // late List<dynamic> _tasks = [];
  List<Widget> taskWidget = [];
  late String userId;

  Future<void> deleteExpense(taskId) async {
    String uri = "${Url.url}/expense/$taskId";
    final Uri url = Uri.parse(uri);
    final response = await http.delete(url);
    if (response.statusCode == 201) {
      final responseJson = jsonDecode(response.body);
      logger.i(responseJson);
      Navigator.pushReplacementNamed(context, '/homecontroller');
      setState(() {
        widget.expenses = responseJson['result'];
      });
    } else {
      logger.e(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    userId = Provider.of<UserProvider>(context).userId;
    return (widget.expenses.isEmpty)
        ? Center(
            child: Text(
            "No Expenses Available",
            style: TextStyle(fontSize: 18.sp),
          ))
        : Column(
            children: [
              ...(widget.expenses).map((e) {
                return customTile(
                    task_id: e['id'], taskName: e['note'], price: e['amount']);
              })
            ],
          );
  }

  Widget customTile({required taskName, required price, required task_id}) {
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
                  onPressed: (context) => {deleteExpense(task_id)},
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
                      taskName,
                      style: TextStyle(fontSize: 15.sp),
                    ),
                  ),
                  Text(
                    formatCurrency.format(price),
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
