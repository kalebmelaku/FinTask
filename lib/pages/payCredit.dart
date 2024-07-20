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

class PayCredit extends StatefulWidget {
  const PayCredit({super.key});

  @override
  State<PayCredit> createState() => _PayCreditState();
}

class _PayCreditState extends State<PayCredit> {
  var logger = Logger();
  late String userId;
  String? selectedPartner;
  List<dynamic> partners = [];
  final TextEditingController amount = TextEditingController();
  @override
  void initState() {
    userId = '';
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPartner();
    });
  }

  Future<void> fetchPartner() async {
    String uri = "${Url.url}/partner/$userId";
    final Uri url = Uri.parse(uri);
    final response = await http.get(url);
    if (response.statusCode == 201) {
      final responseJson = jsonDecode(response.body);
      setState(() {
        partners = responseJson['tasks'];
      });
    } else {
      // print(response.body);
    }
  }

  Future<Map<String, dynamic>> payCredit() async {
    final Map<String, dynamic> data = {
      'owner_id': userId,
      'partner': selectedPartner,
      'amount': amount.text
    };
    final String baseUrl = '${Url.url}/credit/pay';
    final Uri url = Uri.parse(baseUrl);
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));
    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      Navigator.pushReplacementNamed(context, "/homecontroller");
    } else {
      logger.e(response.body);
    }

    return responseData;
  }

  @override
  Widget build(BuildContext context) {
    userId = Provider.of<UserProvider>(context).userId;
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        excludeHeaderSemantics: true,
        title: const Text(
          "Pay Credit",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: MyColors.tertiaryColor,
        elevation: 0,
        actions: const [],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "Select Partner",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      DropdownButton(
                        isExpanded: true,
                        // isDense: true,
                        selectedItemBuilder: (BuildContext context) {
                          return partners.map<Widget>((partner) {
                            return Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                partner['name'],
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList();
                        },
                        items: partners.map((partner) {
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
                        hint: const Text('Select Partner'),
                        value: selectedPartner,
                        style: const TextStyle(color: Colors.white),
                        onChanged: (newValue) {
                          setState(() {
                            selectedPartner = newValue;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      makeInput(
                        label: "Amount",
                        keyType: TextInputType.number,
                        controller: amount,
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
                              payCredit().then((data) {
                                print(data);
                              });
                            },
                            color: MyColors.primaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Text(
                              "Pay Credit",
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
              ],
            ),
          ),
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
