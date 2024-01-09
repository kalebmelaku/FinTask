import 'package:FinTask/includes/colors.dart';
import 'package:FinTask/includes/modals/add_credit.dart';
import 'package:FinTask/includes/modals/add_payment.dart';
import 'package:FinTask/includes/modals/add_task.dart';
import 'package:flutter/material.dart';

class Modal extends StatefulWidget {
  const Modal({super.key});

  @override
  State<Modal> createState() => _ModalState();
}

class _ModalState extends State<Modal> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 1.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Container(
              // height: 50,
              width: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: MyColors.tertiaryColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: TabBar(
                      unselectedLabelColor: Colors.white,
                      labelColor: MyColors.primaryColor,
                      indicatorColor: Colors.white,
                      indicatorWeight: 2,
                      dividerColor: Colors.transparent,
                      // indicator: BoxDecoration(
                      //   color: Colors.white,
                      //   borderRadius: BorderRadius.circular(5),
                      // ),
                      controller: tabController,
                      tabs: const [
                        Tab(
                          text: 'Add Task',
                        ),
                        Tab(
                          text: 'Payment',
                        ),
                        Tab(
                          text: 'Add Credit',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: const [AddTask(), AddPayment(), AddCredit()],
              ),
            )
          ],
        ),
      ),
    );
  }
}
