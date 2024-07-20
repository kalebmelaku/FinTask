import 'dart:convert';

import 'package:FinTask/includes/colors.dart';
import 'package:FinTask/includes/top_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import "package:FinTask/includes/url.dart";
import "package:FinTask/includes/auth_service.dart";
import 'package:intl/intl.dart';

class Credit extends StatefulWidget {
  const Credit({super.key});

  @override
  State<Credit> createState() => _CreditState();
}

class _CreditState extends State<Credit> {
  final AuthService authService = AuthService();
  Map<String, int> categoryTotals = {};
  List<dynamic> expenses = [];
  List<dynamic> paidExpenses = [];

  int totalAmount = 0;
  final formatCurrency = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
  String? selectedDateTime;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchUnpaidExpenses();
      fetchPaidExpenses();
      // setState(() {
      //   selectedDateTime = DateTime.now();
      // });
    });
    super.initState();
  }

  Future<void> fetchUnpaidExpenses() async {
    final userData = await authService.getToken();
    final user = userData['userId'];
    final Map<String, dynamic> data = {
      'userId': user,
      'name': selectedDateTime.toString(),
    };
    String uri = "${Url.url}/credit/unpaid";
    final Uri url = Uri.parse(uri);
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));

    if (response.statusCode == 201) {
      final responseJson = jsonDecode(response.body);
      print(responseJson['credit']);
      setState(() {
        paidExpenses = responseJson['credit'];
      });
    } else {
      print(response.body);
    }
  }

  Future<void> fetchPaidExpenses() async {
    final userData = await authService.getToken();
    final user = userData['userId'];
    final Map<String, dynamic> data = {
      'userId': user,
      'name': selectedDateTime.toString(),
    };
    String uri = "${Url.url}/credit/paid";
    final Uri url = Uri.parse(uri);
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));

    if (response.statusCode == 201) {
      final responseJson = jsonDecode(response.body);
      print(responseJson['credit']);
      setState(() {
        expenses = responseJson['credit'];
      });
    } else {
      print(response.body);
    }
  }

  Map<String, int> calculateCategoryTotals(
      Map<String, List<dynamic>> expenses) {
    Map<String, int> totals = {};
    expenses.forEach((category, items) {
      int total = items.fold(0, (sum, item) => (sum + item['amount']).toInt());
      totals[category] = total;
    });
    return totals;
  }

  int calculateTotalAmount(Map<String, List<dynamic>> expenses) {
    return expenses.values
        .expand((items) => items)
        .fold(0, (sum, item) => (sum + item['amount']).toInt());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: MyColors.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: TopInfo(),
              ),
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
                          Row(
                            children: [
                              Text(
                                "Unpaid Credits",
                                style: TextStyle(fontSize: 20.sp),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          expenses.isEmpty
                              ? const Center(
                                  child: Text("No Unpaid Credit Available"))
                              : buildAccordion(status: false),
                          Row(
                            children: [
                              Text(
                                "Paid Credits",
                                style: TextStyle(fontSize: 20.sp),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          paidExpenses.isEmpty
                              ? const Center(
                                  child: Text("No Payed Credit Available"))
                              : buildAccordion(status: true),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAccordion({required bool status}) {
    return status
        ? Column(
            children: [
              ...expenses.map((element) {
                return Column(
                  children: [
                    ListTile(
                      tileColor: MyColors.secondaryColor,
                      title: Text(
                        element["provider_name"],
                        style: TextStyle(color: Colors.white, fontSize: 15.sp),
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(
                          formatCurrency.format(element["amount"]),
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(
                          element["date"].toString().split("T")[0],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      shape: const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18))),
                    ),
                    SizedBox(height: 10.h)
                  ],
                );
              })
            ],
          )
        : Column(
            children: [
              ...paidExpenses.map((element) {
                return Column(
                  children: [
                    ListTile(
                      tileColor: MyColors.secondaryColor,
                      title: Text(
                        element["provider_name"],
                        style: TextStyle(color: Colors.white, fontSize: 15.sp),
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(
                          formatCurrency.format(element["amount"]),
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(
                          element["date"].toString().split("T")[0],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      shape: const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18))),
                    ),
                    SizedBox(height: 10.h)
                  ],
                );
              })
            ],
          );
  }
}
