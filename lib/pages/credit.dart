import 'package:FinTask/includes/functions/local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class Credit extends StatefulWidget {
  const Credit({super.key});

  @override
  State<Credit> createState() => _CreditState();
}

class _CreditState extends State<Credit> {
  TextEditingController dateController = TextEditingController();
  DateTime date = DateTime.now();
  DateTime? selectedDateTime;

  @override
  void initState() {
    super.initState();
    // requestExactAlarmPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        final DateTime? dateTime = await showOmniDateTimePicker(
                            context: context, is24HourMode: false);
                        setState(() {
                          selectedDateTime = dateTime;
                        });
                      },
                      child: const Text("Select Date Time"),
                    ),
                    // final DateTime? dateTime =
                    //     await showOmniDateTimePicker(context: context);

                    // Use dateTime here
                    // debugPrint('dateTime: $dateTime');
                  ),
                ],
              ),
              ElevatedButton(
                  onPressed: () => {
                        LocalNotifications.showSimpleNotification(
                            title: "title", body: "body", payload: "payload")
                        // NotificationService().scheduleNotification(
                        //     title: "Hello World",
                        //     body: '$selectedDateTime',
                        //     scheduledNotificationDateTime: selectedDateTime)
                      },
                  child: const Text("Notify")),
              ElevatedButton(
                  onPressed: () => {
                        // LocalNotifications.showPeriodicNotification(title: "title", body: "Periodic", payload: "payload")
                        /*LocalNotifications.showScheduleNotification(
                          title: "Hello World",
                          body: 'selectedDateTime',
                          payload: 'this is scheduled date',
                          scheduledNotificationDateTime: selectedDateTime
                        ),*/
                        print('$selectedDateTime')
                      },
                  child: const Text("Notify Period"))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        dateController.text = picked.toString().split(" ")[0];
      });
    }
  }
}
