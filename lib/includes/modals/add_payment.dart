import 'package:FinTask/includes/colors.dart';
import 'package:FinTask/state/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:FinTask/includes/url.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class AddPayment extends StatefulWidget {
  const AddPayment({super.key});

  @override
  State<AddPayment> createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  var logger = Logger();
  String selectedOption = 'Personal';
  late String userId;
  String? selectedReason;
  List<dynamic> reasons = [];
  final TextEditingController amount = TextEditingController();
  final TextEditingController note = TextEditingController();
  @override
  void initState() {
    userId = '';
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchExpenseOptions();
    });
  }

  Future<void> fetchExpenseOptions() async {
    String uri = "${Url.url}/expense/options/$userId";
    final Uri url = Uri.parse(uri);
    final response = await http.get(url);
    if (response.statusCode == 201) {
      final responseJson = jsonDecode(response.body);
      setState(() {
        reasons = responseJson['result'];
      });
    } else {}
  }

  Future<Map<String, dynamic>> addExpense() async {
    final Map<String, dynamic> data = {
      'owner_id': userId,
      'reason': selectedReason,
      'amount': amount.text,
      'note': note.text
    };
    final String baseUrl = '${Url.url}/expense';
    final Uri url = Uri.parse(baseUrl);
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));
    final responseData = json.decode(response.body);
    if (response.statusCode == 201) {
      Navigator.pushReplacementNamed(context, "/homecontroller");
    } else {
      logger.e(response.body);
    }

    return responseData;
  }

  @override
  Widget build(BuildContext context) {
    userId = Provider.of<UserProvider>(context).userId;
    return Container(
      decoration: BoxDecoration(
          color: MyColors.backgroundColor,
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(15),
              bottomLeft: Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10.h,
            ),
            makeInput(
              label: "Amount", keyType: TextInputType.number,
              controller: amount,
              // error: emailErr,
            ),
            SizedBox(
              height: 10.h,
            ),
            makeInput(
              label: "Note",
              keyType: TextInputType.text,
              controller: note,
              // error: passErr,
            ),
            SizedBox(
              height: 15.h,
            ),
            Text(
              "Select Reason",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            DropdownButton(
              isExpanded: true,
              // isDense: true,
              selectedItemBuilder: (BuildContext context) {
                return reasons.map<Widget>((partner) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      partner['name'],
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList();
              },
              items: reasons.map((partner) {
                return DropdownMenuItem<String>(
                  value: partner['id']
                      .toString(), // Assuming 'id' is a string or can be converted to a string
                  child: Text(
                    partner[
                        'name'], // Adjust this according to your data structure
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              hint: const Text('Select Reason'),
              value: selectedReason,
              style: const TextStyle(color: Colors.white),
              onChanged: (newValue) {
                setState(() {
                  selectedReason = newValue;
                });
              },
            ),
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
                    addExpense().then((data) => print(data));
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

  Widget makeInput({label, keyType, controller}) {
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
          controller: controller,
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
