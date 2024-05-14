import "dart:convert";

import "package:FinTask/includes/auth_service.dart";
import "package:FinTask/includes/colors.dart";
import "package:FinTask/includes/credit_card.dart";
import "package:FinTask/includes/expenses_box.dart";
import "package:FinTask/includes/modal.dart";
import "package:FinTask/includes/task_box.dart";
import "package:FinTask/includes/top_info.dart";
import "package:FinTask/includes/url.dart";
import "package:FinTask/state/modal_provider.dart";
import "package:FinTask/state/user_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:provider/provider.dart";
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController tabController;
  final AuthService authService = AuthService();

  List<dynamic> tasks = [];
  late String userId;
  bool tabs = true;
  @override
  void initState() {
    userId = '';
    tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchTasks();
    });
    super.initState();
  }

  Future<void> fetchTasks() async {
    final userData = await authService.getToken();
    print(userData);
    final user = userData['userId'];
    String uri = "${Url.url}/getTasks/$user";
    final Uri url = Uri.parse(uri);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        tasks = jsonDecode(response.body);
      });
      
    } else {
      print(response.body);
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool modal = Provider.of<ModalProvider>(context).isActive;
    userId = Provider.of<UserProvider>(context).userId;

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
                  tabs
                      ? TaskBox(
                          tasks: Future(() => tasks),
                        )
                      : const ExpensesBox()
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
