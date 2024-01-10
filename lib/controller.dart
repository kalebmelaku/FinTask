import 'package:FinTask/includes/auth_service.dart';
import 'package:FinTask/includes/colors.dart';
import 'package:FinTask/includes/functions/custom_function.dart';
import 'package:FinTask/includes/modal.dart';
import 'package:FinTask/pages/credit.dart';
import 'package:FinTask/pages/home.dart';
import 'package:FinTask/state/modal_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Controller extends StatefulWidget {
  Controller({super.key});
  int selectedIndex = 0;

  @override
  State<Controller> createState() => _ControllerState();
}

class _ControllerState extends State<Controller> {
  int currentIndex = 0;
  final authService = AuthService();
  void onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
      currentIndex = widget.selectedIndex;
    });
  }

  @override
  void initState() {
    onItemTapped(widget.selectedIndex);
    getAuth();
    super.initState();
  }

  void getAuth() async {
    final userData = await authService.getToken();
    final userId = userData['userId'];

    getUserInfo(context, userId);
  }

  final List<Widget> pages = [
    const Home(),
    const Home(),
    const Home(),
    const Home(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    final modal = context.read<ModalProvider>();
    Widget currentScreen = currentIndex == 0
        ? const Home()
        : currentIndex == 1
            ? const Credit()
            : currentIndex == 2
                ? const Home()
                : const Home();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.backgroundColor,
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.secondaryColor,
        child: modal.isActive
            ? const Icon(
                Icons.close,
                color: Colors.white,
              )
            : const Icon(
                Icons.add,
                color: Colors.white,
              ),
        onPressed: () {
          setState(() {
            // modal.setModalStatus(!modal.isActive);
            showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                      height: MediaQuery.of(context).size.height / 1.1,
                      child: ListView(children: const [Modal()]));
                });
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: MyColors.backgroundColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            color: MyColors.tertiaryColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 50,
                    onPressed: () {
                      setState(() {
                        currentScreen = const Home();
                        currentIndex = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home_filled,
                          color: currentIndex == 0
                              ? MyColors.primaryColor
                              : Colors.white,
                        ),
                        Text(
                          "Home",
                          style: TextStyle(
                              color: currentIndex == 0
                                  ? MyColors.primaryColor
                                  : Colors.white),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 50,
                    onPressed: () {
                      setState(() {
                        currentScreen = const Credit();
                        currentIndex = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon(
                        //   Icons.person,
                        //   color: currentIndex == 1
                        //       ? MyColors.primaryColor
                        //       : Colors.white,
                        // ),
                        FaIcon(
                          FontAwesomeIcons.commentDollar,
                          color: currentIndex == 1
                              ? MyColors.primaryColor
                              : Colors.white,
                        ),
                        Text(
                          "Expense",
                          style: TextStyle(
                              color: currentIndex == 1
                                  ? MyColors.primaryColor
                                  : Colors.white),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 50,
                    onPressed: () {
                      setState(() {
                        currentScreen = const Home();
                        currentIndex = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt,
                          color: currentIndex == 2
                              ? MyColors.primaryColor
                              : Colors.white,
                        ),
                        Text(
                          "Credit",
                          style: TextStyle(
                              color: currentIndex == 2
                                  ? MyColors.primaryColor
                                  : Colors.white),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 50,
                    onPressed: () {
                      setState(() {
                        currentScreen = const Home();
                        currentIndex = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.settings,
                          color: currentIndex == 3
                              ? MyColors.primaryColor
                              : Colors.white,
                        ),
                        Text(
                          "Setting",
                          style: TextStyle(
                              color: currentIndex == 3
                                  ? MyColors.primaryColor
                                  : Colors.white),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
