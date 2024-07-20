import 'package:FinTask/includes/optionsBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/fa_solid.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/vaadin.dart';

class Options extends StatefulWidget {
  const Options({super.key});

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.w, bottom: 10.w),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          OptionsBox(
            title: 'Deposit',
            url: 'deposit',
            icon: Iconify(
              Vaadin.money_deposit,
              color: Colors.white,
              size: 30,
            ),
          ),
          OptionsBox(
            title: 'Expense Opt',
            url: 'expenseOpt',
            icon: Iconify(
              MaterialSymbols.fact_check,
              color: Colors.white,
              size: 30,
            ),
          ),
          OptionsBox(
            title: 'Pay Credit',
            url: 'payCredit',
            icon: Iconify(
              Mdi.account_check,
              color: Colors.white,
              size: 30,
            ),
          ),
          OptionsBox(
            title: 'Partners',
            url: 'partners',
            icon: Iconify(
              FaSolid.user_friends,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
