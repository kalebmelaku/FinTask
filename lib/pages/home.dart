import "package:FinTask/includes/colors.dart";
import "package:FinTask/includes/credit_card.dart";
import "package:FinTask/includes/expenses_box.dart";
import "package:FinTask/includes/modal.dart";
import "package:FinTask/includes/tasks_box.dart";
import "package:FinTask/includes/top_info.dart";
import "package:FinTask/state/modal_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:provider/provider.dart";

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController tabController;
  bool tabs = true;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    // final modal = context.read<UserProvider>();
    // user.setUserId(stdId, name, year, email, profilePicture);

    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // bool modal = Provider.of<UserProvider>(context).setCourseId();
    bool modal = Provider.of<ModalProvider>(context).isActive;
    print(modal);
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Stack(children: [
              Column(
                children: [
                  const TopInfo(),
                  SizedBox(
                    height: 15.h,
                  ),
                  const CreditCard(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: tabs
                                ? MyColors.tertiaryColor
                                : MyColors.backgroundColor,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(0)),
                          ),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                tabs = true;
                              });
                            },
                            child: Text(
                              "Tasks",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.sp),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: tabs
                                  ? MyColors.backgroundColor
                                  : MyColors.tertiaryColor,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(0),
                                  bottomRight: Radius.circular(0))),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                tabs = false;
                              });
                            },
                            child: Text(
                              "Expenses",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.sp),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  tabs ? const TasksBox() : const ExpensesBox()
                ],
              ),
              modal
                  ? const Positioned(
                      child: Align(alignment: Alignment.center, child: Modal()),
                    )
                  : const SizedBox.shrink(),
            ])),
      ),
    );
  }
}
