import 'package:FinTask/includes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:FinTask/includes/url.dart';
import 'package:FinTask/state/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class CreditCard extends StatefulWidget {
  const CreditCard({super.key});

  @override
  State<CreditCard> createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
   var logger = Logger();
  int deposit = 0;
  @override
  void initState() {
    super.initState();
    getDeposit();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  Future<void> getDeposit() async {
    final user = context.read<UserProvider>();
    final userId = user.userId;
    String uri = "${Url.url}/deposit/$userId";
    final Uri url = Uri.parse(uri);
    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      setState(() {
        deposit = responseData['depositAmount'];
      });
    } else {
      logger.e(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 3.5,
      child: Stack(
        children: [
          Positioned(
            top: 5.0,
            left: 0,
            right: 0,
            child: Transform.rotate(
              angle: -0.2,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 70.h),
                      decoration: BoxDecoration(
                        color: MyColors.tertiaryColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(20)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 10.0,
            left: 0,
            right: 0,
            child: Transform.rotate(
              angle: -0.1,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 70.h),
                      decoration: BoxDecoration(
                        color: MyColors.secondaryColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(20)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 15.0,
            left: 0,
            right: 0,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      image: DecorationImage(
                          image: AssetImage('./assets/bg.jpg'),
                          fit: BoxFit.fill),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.fileInvoice,
                              color: Colors.white.withAlpha(35),
                              size: 60,
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total Balance",
                                  style: TextStyle(fontSize: 23.sp),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  deposit.toString(),
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                              ],
                            )
                          ],
                        ),
                        Column(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.fileInvoiceDollar,
                              color: Colors.white.withAlpha(35),
                              size: 60,
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total Credit",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 23.sp),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  "100, 000",
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
