import 'package:FinTask/includes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpensesBox extends StatefulWidget {
  const ExpensesBox({super.key});

  @override
  State<ExpensesBox> createState() => _ExpensesBoxState();
}

class _ExpensesBoxState extends State<ExpensesBox> {
  @override
  DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: MyColors.tertiaryColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(0),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () async {
                  DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(1990),
                    lastDate: DateTime(2100),
                  );
                  if (newDate != null) {
                    setState(() {
                      date = newDate;
                    });
                  }
                },
                child: Text(
                  '${DateTime.now().year} - ${DateTime.now().month} - ${DateTime.now().day}',
                  style: TextStyle(fontSize: 15.sp, color: Colors.white),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/homecontroller");
                },
                color: MyColors.primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  'See More',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                 SizedBox(height: 10.h),
                ExpenseBox(
                  day: 7,
                  month: 'Jan',
                  category: "Personal",
                  reason: "Mobile Card",
                  amount: 100.00,
                ),
                SizedBox(
                  height: 10.h,
                ),
                ExpenseBox(
                  day: 9,
                  month: 'Dec',
                  category: "Office",
                  reason: "Printer",
                  amount: 10000.00,
                ),
                SizedBox(
                  height: 10.h,
                ),
                ExpenseBox(
                  day: 17,
                  month: 'Dec',
                  category: "Home",
                  reason: "Fruits",
                  amount: 500.00,
                ),
                SizedBox(
                  height: 10.h,
                ),
                ExpenseBox(
                  day: 7,
                  month: 'Jan',
                  category: "Personal",
                  reason: "Mobile Card",
                  amount: 100.00,
                ),
                SizedBox(
                  height: 10.h,
                ),
                ExpenseBox(
                  day: 7,
                  month: 'Jan',
                  category: "Personal",
                  reason: "Mobile Card",
                  amount: 100.00,
                ),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget ExpenseBox(
      {required int day,
      required String month,
      required String category,
      required String reason,
      required double amount}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: MyColors.secondaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                    color: MyColors.primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(4))),
                child: Column(
                  children: [
                    Text(
                      day.toString(),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      month,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 20.sp,
                    ),
                  ),
                  Text(
                    reason,
                    style: TextStyle(
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            "\$$amount",
            style: TextStyle(fontSize: 20.sp),
          )
        ],
      ),
    );
  }
}
