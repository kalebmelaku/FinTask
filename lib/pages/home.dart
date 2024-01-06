import "package:FinTask/includes/colors.dart";
import "package:FinTask/includes/credit_card.dart";
import "package:FinTask/includes/top_info.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Column(
            children: [
              const TopInfo(),
              Container(
                height: 15.h,
                color: MyColors.backgroundColor,
              ),
              const CreditCard(),
              Container(
                decoration: BoxDecoration(
                    color: MyColors.tertiaryColor,
                    borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(15)
                          )),
                child: TabBar(
                  dividerHeight: 0,
                  indicator: null,
                  unselectedLabelColor: Colors.white,
                  labelColor: Colors.black,
                  indicatorColor: Colors.transparent,
                  controller: tabController,
                  tabs: const [
                    Tab(
                      text: "Task",
                    ),
                    Tab(
                      text: 'Expense',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: MyColors.tertiaryColor,
                      borderRadius:
                          const BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15)
                          )),
                  child: TabBarView(
                    controller: tabController,
                    children: const [
                      Column(
                        children: [
                          Text('data'),
                          Text('data'),
                          Text('data'),
                        ],
                      ),
                      Text("data")
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
