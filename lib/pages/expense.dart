import 'dart:convert';
import 'package:FinTask/includes/colors.dart';
import 'package:FinTask/includes/top_info.dart';
import 'package:FinTask/state/user_provider.dart';
import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import "package:FinTask/includes/url.dart";
import "package:FinTask/includes/auth_service.dart";
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';

class Expense extends StatefulWidget {
  const Expense({super.key});

  @override
  State<Expense> createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> {
  final AuthService authService = AuthService();
  late String userId;
  Map<String, int> categoryTotals = {};
  Map<String, List<dynamic>> expenses = {};
  int totalAmount = 0;
  final formatCurrency = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
  String? selectedDateTime;
  String? selectedYear = DateTime.now().year.toString();
  String? selectedMonth = DateTime.now().month.toString();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchExpenses();
    });
    super.initState();
  }

  Future<void> fetchExpenses() async {
    final userData = await authService.getToken();
    final user = userData['userId'];
    final Map<String, dynamic> data = {
      'userId': user,
      'year': selectedYear,
      'month': selectedMonth,
    };
    String uri = "${Url.url}/expense/monthly"; // Adjust API endpoint as needed
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
    userId = Provider.of<UserProvider>(context).userId;
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: TopInfo(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton(
                      style: const ButtonStyle(
                          padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                      onPressed: () async {
                        final DateTime? dateTime = await showOmniDateTimePicker(
                          context: context,
                          type: OmniDateTimePickerType.date,
                        );
                        // print(dateTime.toString().split(" ")[0]);
                        selectedDateTime = dateTime.toString().split(" ")[0];
                        setState(() {
                          selectedYear = dateTime.toString().split("-")[0];
                          selectedMonth = dateTime.toString().split("-")[1];
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
                                    color:
                                        const Color.fromRGBO(189, 189, 189, 1),
                                    width: 1.0,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                                child: Center(
                                  child: Text(
                                    '$selectedYear  $selectedMonth',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: DropdownButton<String>(
                  //     value: selectedYear,
                  //     onChanged: (String? newYear) {
                  //       setState(() {
                  //         selectedYear = newYear!;
                  //         fetchExpenses();
                  //       });
                  //     },
                  //     items: List.generate(5, (index) {
                  //       int year = DateTime.now().year - 2 + index;
                  //       return DropdownMenuItem<String>(
                  //         value: year.toString(),
                  //         child: Text(year.toString()),
                  //       );
                  //     }),
                  //   ),
                  // ),
                  // const SizedBox(width: 16),
                  // Expanded(
                  //   child: DropdownButton<String>(
                  //     value: selectedMonth,
                  //     onChanged: (String? newMonth) {
                  //       setState(() {
                  //         selectedMonth = newMonth!;
                  //         fetchExpenses();
                  //       });
                  //     },
                  //     items: List.generate(12, (index) {
                  //       String monthStr =
                  //           DateFormat('MM').format(DateTime(0, index + 1));
                  //       return DropdownMenuItem<String>(
                  //         value: monthStr,
                  //         child: Text(DateFormat('MMMM')
                  //             .format(DateTime(0, index + 1))),
                  //       );
                  //     }),
                  //   ),
                  // ),
                ],
              ),
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
                                child: Text(
                                    "No expense Available for selected month and year"))
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
