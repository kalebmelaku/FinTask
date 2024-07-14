import "dart:convert";

import "package:FinTask/includes/auth_service.dart";
import "package:FinTask/includes/colors.dart";
import "package:FinTask/includes/credit_card.dart";
import "package:FinTask/includes/expense_box.dart";
import "package:FinTask/includes/options.dart";
import "package:FinTask/includes/tasks_box.dart";
import "package:FinTask/includes/top_info.dart";
import "package:FinTask/includes/url.dart";
// import "package:FinTask/state/modal_provider.dart";
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
  List<dynamic> expenses = [];
  late String userId;
  bool tabs = true;
  @override
  void initState() {
    userId = '';
    tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchTasks();
      fetchExpenses();
    });
    super.initState();
  }

  Future<void> fetchTasks() async {
    final userData = await authService.getToken();
    final user = userData['userId'];
    String uri = "${Url.url}/tasks/$user";
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

  Future<void> fetchExpenses() async {
    final userData = await authService.getToken();
    final user = userData['userId'];
    String uri = "${Url.url}/expense/$user";
    final Uri url = Uri.parse(uri);
    final response = await http.get(url);
    if (response.statusCode == 201) {
      final responseJson = jsonDecode(response.body);
      setState(() {
        expenses = responseJson['result'];
      });
    } else {
      // print(response.body);
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // bool modal = Provider.of<ModalProvider>(context).isActive;
    userId = Provider.of<UserProvider>(context).userId;
    return Scaffold(
        backgroundColor: MyColors.backgroundColor,
        body: SafeArea(
          child: (Column(
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
                      const CreditCard(),
                      const Options(),
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Today's Tasks",
                              style: TextStyle(fontSize: 15.sp),
                            ),
                            TextButton(
                              onPressed: () => {print("more")},
                              child: Text(
                                "See All",
                                style: TextStyle(
                                    fontSize: 15.sp, color: Colors.white),
                              ),
                            ),
                          ]),
                      (tasks.isEmpty)
                          ? const Center(
                              child: Text("No Tasks Available for today"),
                            )
                          : TasksBox(tasks: tasks),
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Today's Expenses",
                            style: TextStyle(fontSize: 15.sp),
                          ),
                          TextButton(
                            onPressed: () => {print("more")},
                            child: Text(
                              "See All",
                              style: TextStyle(
                                  fontSize: 15.sp, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      (expenses.isEmpty)
                          ? const Center(
                              child: Text("No Expenses Available for today"),
                            )
                          : ExpenseBox(expenses: expenses),
                    ],
                  ),
                ),
              ),
            ],
          )),
        ));
  }
}
