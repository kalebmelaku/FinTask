import 'package:FinTask/includes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddPayment extends StatefulWidget {
  const AddPayment({super.key});

  @override
  State<AddPayment> createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  String selectedOption = 'Personal';
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
              label: "Amount", keyType: TextInputType.number,
              // controller: _email,
              // error: emailErr,
            ),
            SizedBox(
              height: 10.h,
            ),
            makeInput(
              label: "Reason",
              keyType: TextInputType.text,
              // controller: _password,
              // error: passErr,
            ),
            Row(
              children: [
                Expanded(
                  child: ListTileTheme(
                    horizontalTitleGap: 0,
                    child: RadioListTile(
                                    
                      contentPadding: const EdgeInsets.all(0),
                      fillColor: MaterialStateProperty.all(Colors.white),
                      title: const Text(
                        'Personal',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: 'personal',
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value.toString();
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTileTheme(
                    horizontalTitleGap: 0,
                    child: RadioListTile(
                      contentPadding: const EdgeInsets.all(0),
                      fillColor: MaterialStateProperty.all(Colors.white),
                      title: const Text(
                        'Home',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: 'home',
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value.toString();
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ListTileTheme(
                    horizontalTitleGap: 0,
                    child: RadioListTile(
                      contentPadding: const EdgeInsets.all(0),
                      fillColor: MaterialStateProperty.all(Colors.white),
                      title: const Text(
                        'Office',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: 'office',
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value.toString();
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTileTheme(
                    horizontalTitleGap: 0,
                    child: RadioListTile(
                      contentPadding: const EdgeInsets.all(0),
                      fillColor: MaterialStateProperty.all(Colors.white),
                      title: const Text(
                        'Other',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: 'other',
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value.toString();
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            // Row(
            //   children: [makeRadio(title: "Personal", value: "Personal")],
            // ),
            SizedBox(
              height: 10.h,
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
                    "Add Payment",
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

  Widget makeRadio({title, value}) {
    return Container(
      color: Colors.amber,
      height: 100,
      child: RadioListTile(
        title: const Text(
          'Personal',
          style: TextStyle(color: Colors.white),
        ),
        value: 'personal',
        activeColor: Colors.white,
        groupValue: selectedOption,
        onChanged: (value) {
          setState(() {
            selectedOption = value.toString();
          });
        },
      ),
    );
  }
}
