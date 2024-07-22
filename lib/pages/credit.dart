import 'dart:convert';

import 'package:FinTask/includes/colors.dart';
import 'package:FinTask/includes/top_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import "package:FinTask/includes/url.dart";
import "package:FinTask/includes/auth_service.dart";
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

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
  final TextEditingController _name = TextEditingController();
  int totalAmount = 0;
  final formatCurrency = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
  String? selectedDateTime;
  Logger logger = Logger();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchUnpaidExpenses();
      fetchPaidExpenses();
    });
    super.initState();
  }

  Future<void> fetchUnpaidExpenses() async {
    final userData = await authService.getToken();
    final user = userData['userId'];
    final Map<String, dynamic> data = {
      'userId': user,
      'name': _name.text,
    };
    String uri = "${Url.url}/credit/unpaid";
    final Uri url = Uri.parse(uri);
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));

    if (response.statusCode == 201) {
      final responseJson = jsonDecode(response.body);
      setState(() {
        paidExpenses = responseJson['credit'];
      });
      print(paidExpenses);
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
      setState(() {
        expenses = responseJson['credit'];
      });
      if (_name.text.isNotEmpty) {
        logger.i(paidExpenses);
      }
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
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     Expanded(
                      //       child: makeInput(
                      //         label: "Name",
                      //         obscureText: false,
                      //         keyType: TextInputType.text,
                      //         controller: _name,
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 10.w,
                      //     ),
                      //     Expanded(
                      //       child: Column(
                      //         children: [
                      //           const Text(""),
                      //           const SizedBox(
                      //             height: 5,
                      //           ),
                      //           MaterialButton(
                      //             minWidth: double.infinity,
                      //             height: 35.h,
                      //             onPressed: () {
                      //               print(expenses);
                      //               print(paidExpenses);
                      //               HapticFeedback.vibrate();
                      //               fetchUnpaidExpenses();
                      //               fetchPaidExpenses();
                      //             },
                      //             color: MyColors.primaryColor,
                      //             elevation: 0,
                      //             shape: RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.circular(15)),
                      //             child: Text(
                      //               "Search",
                      //               style: TextStyle(
                      //                   fontWeight: FontWeight.w600,
                      //                   fontSize: 15.sp,
                      //                   color: Colors.white),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     )
                      //   ],
                      // ),
                      SizedBox(
                        height: 20.h,
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
                          paidExpenses.isEmpty
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
                          expenses.isEmpty
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

Widget makeInput({label, obscureText, keyType, controller, error}) {
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
      TextField(
        obscureText: obscureText,
        controller: controller,
        keyboardType: keyType,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color.fromRGBO(189, 189, 189, 1)),
              borderRadius: BorderRadius.circular(15)),
          border: OutlineInputBorder(
              // borderSide: BorderSide(color: Color.fromRGBO(189, 189, 189, 1)),
              borderRadius: BorderRadius.circular(15)),
        ),
      ),
    ],
  );
}
