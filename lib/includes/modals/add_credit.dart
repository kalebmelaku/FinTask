import 'package:FinTask/includes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddCredit extends StatefulWidget {
  const AddCredit({super.key});

  @override
  State<AddCredit> createState() => _AddCreditState();
}

class _AddCreditState extends State<AddCredit> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: MyColors.primaryColorBg,
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(15),
              bottomLeft: Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10.h,
            ),
            makeInput(
              label: "Provider Name", keyType: TextInputType.text,
              // controller: _email,
              // error: emailErr,
            ),
            SizedBox(
              height: 10.h,
            ),
            makeInput(
              label: "Amount",
              keyType: TextInputType.number,
              // controller: _password,
              // error: passErr,
            ),
            SizedBox(
              height: 25.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Container(
                padding: const EdgeInsets.only(top: 3, left: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: const Border(
                      bottom: BorderSide(color: Colors.white),
                      top: BorderSide(color: Colors.white),
                      left: BorderSide(color: Colors.white),
                      right: BorderSide(color: Colors.white),
                    )),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 35.h,
                  onPressed: () {
                    HapticFeedback.vibrate();
                    // Navigator.of(context).pushNamed("/homecontroller");
                    // validateInput();
                  },
                  color: MyColors.primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    "Add Credit",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget makeInput({label, keyType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        TextField(
          keyboardType: keyType,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color.fromRGBO(189, 189, 189, 1)),
                borderRadius: BorderRadius.circular(15)),
            border: OutlineInputBorder(
                // borderSide: BorderSide(color: Color.fromRGBO(189, 189, 189, 1)),
                borderRadius: BorderRadius.circular(15)),
          ),
        )
      ],
    );
  }
}
