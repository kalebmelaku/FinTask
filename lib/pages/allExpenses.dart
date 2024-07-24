import 'dart:convert';

import 'package:FinTask/includes/colors.dart';
import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import "package:FinTask/includes/url.dart";
import "package:FinTask/includes/auth_service.dart";
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class AllExpenses extends StatefulWidget {
  const AllExpenses({super.key});

  @override
  State<AllExpenses> createState() => _AllExpensesState();
}

class _AllExpensesState extends State<AllExpenses> {
  final AuthService authService = AuthService();
  Map<String, int> categoryTotals = {};
  Map<String, List<dynamic>> expenses = {};
  int totalAmount = 0;
  final formatCurrency = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
  String? selectedDateTime;
  Logger logger = Logger();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchExpenses();
      // setState(() {
      //   selectedDateTime = DateTime.now();
      // });
    });
    super.initState();
  }

  Future<void> fetchExpenses() async {
    final userData = await authService.getToken();
    final user = userData['userId'];
    final Map<String, dynamic> data = {
      'userId': user,
      'date': selectedDateTime.toString(),
    };
    String uri = "${Url.url}/expense/today";
    final Uri url = Uri.parse(uri);
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      setState(() {
        expenses = Map<String, List<dynamic>>.from(responseJson['result']);
        categoryTotals = calculateCategoryTotals(expenses);
        totalAmount = calculateTotalAmount(expenses);
      });
    } else {
      logger.e(response.body);
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
                        TextButton(
                          style: const ButtonStyle(
                              padding:
                                  WidgetStatePropertyAll(EdgeInsets.all(0))),
                          onPressed: () async {
                            final DateTime? dateTime =
                                await showOmniDateTimePicker(
                              context: context,
                              type: OmniDateTimePickerType.date,
                            );
                            print(dateTime.toString().split(" ")[0]);
                            setState(() {
                              selectedDateTime =
                                  dateTime.toString().split(" ")[0];
                              fetchExpenses();
                            });
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: const Color.fromRGBO(
                                            189, 189, 189, 1),
                                        width: 1.0,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    child: Center(
                                      child: Text(
                                        selectedDateTime ?? "Select Date",
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        CircleAvatar(
                          radius: 65.0,
                          backgroundColor: MyColors.tertiaryColor,
                          child: Text(
                            formatCurrency.format(totalAmount),
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.sp),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Wrap(
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 20,
                          runSpacing: 20,
                          children: categoryTotals.entries.map((entry) {
                            return totalCategory(
                                total: entry.value, name: entry.key);
                          }).toList(),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        const Divider(
                          thickness: 1.0,
                          color: Colors.white54,
                        ),
                        expenses.isEmpty
                            ? const Center(
                                child: Text("No Expense Available for Today"))
                            : buildAccordion(),
                      ],
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

  Widget buildAccordion() {
    return Accordion(
      openAndCloseAnimation: true,
      contentBorderWidth: 0,
      sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
      sectionClosingHapticFeedback: SectionHapticFeedback.light,
      children: expenses.entries.map((entry) {
        return AccordionSection(
          isOpen: false,
          headerBackgroundColor: MyColors.secondaryColor,
          headerPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          rightIcon: const Icon(Icons.keyboard_arrow_down),
          header: Text(
            entry.key.toString(),
            style: TextStyle(fontSize: 18.sp, color: Colors.white),
          ),
          content: Column(
            children: entry.value.map<Widget>((expense) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      expense['note'],
                      style: TextStyle(color: Colors.black, fontSize: 18.sp),
                    ),
                    Text(
                      formatCurrency.format(expense['amount']),
                      style: TextStyle(color: Colors.black, fontSize: 18.sp),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}
