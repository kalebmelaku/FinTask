import 'package:FinTask/includes/colors.dart';
import 'package:FinTask/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Controller extends StatefulWidget {
  const Controller({Key? key}) : super(key: key);

  @override
  _ControllerState createState() => _ControllerState();
}

class _ControllerState extends State<Controller> {
  int currentIndex = 0;
  final _screens = [
    const Home(),
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const Home();
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: PageStorage(
    //     child: currentScreen,
    //     bucket: bucket,
    //   ),
    //   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    //   floatingActionButton: FloatingActionButton(
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(25.0), // Adjust as needed
    //     ),
    //     onPressed: () => {},
    //     backgroundColor: MyColors.secondaryColor,
    //     foregroundColor: Colors.white,
    //     child: const Icon(Icons.add),
    //   ),
     
    // );
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.yellow,
        elevation: 0,
        // shape: BeveledRectangleBorder(
        //     // borderRadius: BorderRadius.circular(20.0),
        //     // side: BorderSide(color: Colors.blue, width: 2.0, style: BorderStyle.solid)
        //     ),
        // mini: true,
      ),
      bottomNavigationBar: SafeArea(
        child:  BottomAppBar(
          notchMargin: 10,
          shape: const CircularNotchedRectangle(),
          color: MyColors.primaryColor,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  Text(
                    "Home",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  Text(
                    "Shop",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
                  Text(
                    "Fav",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    Text(
                      "Setting",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
