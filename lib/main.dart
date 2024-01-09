import 'package:FinTask/controller.dart';
import 'package:FinTask/pages/home.dart';
import 'package:FinTask/pages/login.dart';
import 'package:FinTask/pages/profile.dart';
import 'package:FinTask/pages/signup.dart';
import 'package:FinTask/pages/welcome.dart';
import 'package:FinTask/state/modal_provider.dart';
import 'package:FinTask/state/user_provider.dart';
// import 'package:FinTask/states/user_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'first_time_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ScreenUtilInit;
  SharedPreferences pref = await SharedPreferences.getInstance();
  bool isFirstRun = pref.getBool('firstRun') ?? true;
  if (isFirstRun) {
    pref.setBool('firstRun', false);
  }
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ModalProvider(),
        lazy: true,
      ),
      ChangeNotifierProvider(
        create: (context) => UserProvider(),
        lazy: true,
      )
    ],
    child: ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      // designSize: const Size(300, 640),
      designSize: const Size(360, 640),
      // designSize: const Size(420, 640),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: isFirstRun ? const Welcome() : const Welcome(),
        routes: {
          '/homecontroller': (context) => Controller(),
          '/home': (context) => const Home(),
          '/login': (context) => const Login(),
          // '/otp': (context) => const OTP(),
          '/signup': (context) => const SignUp(),
          // '/chat': (context) => const Chat(),
          '/setting': (context) => const Profile(),
        },
        theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: "Agbalumo",
            hintColor: Colors.white,
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white),
              bodySmall: TextStyle(color: Colors.white),
              labelLarge: TextStyle(color: Colors.white),
              labelMedium: TextStyle(color: Colors.white),
              labelSmall: TextStyle(color: Colors.white),
            )),
      ),
    ),
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    // TODO: implement initState
// SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Center();
  }
}
