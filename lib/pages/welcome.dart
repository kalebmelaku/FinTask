import 'package:FinTask/includes/colors.dart';
import 'package:FinTask/pages/login.dart';
import 'package:FinTask/pages/signup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushNamed("/signup");
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    var pageDecoration = PageDecoration(
      titleTextStyle:
          const TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: MyColors.backgroundColor,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: MyColors.backgroundColor,
      allowImplicitScrolling: true,
      // autoScrollDuration: null,
      // infiniteAutoScroll: true,
      pages: [
        PageViewModel(
          title: "Welcome",
          body:
              "Welcome to FinTask – where task management meets finance tracking. Your all-in-one solution for productivity and financial success.",
          image: Container(
            margin: EdgeInsets.only( top: 25.h),
            child: Lottie.asset(
              './animations/welcome.json', // Replace with the path to your Lottie animation file
              width: 300,
              height: 300,
              fit: BoxFit.contain,
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Task Management",
          body:
              "Effortlessly organize your tasks. Prioritize, set due dates, and boost your productivity with FinTask.",
            image: Lottie.asset(
            './animations/task.json', // Replace with the path to your Lottie animation file
            width: 300,
            height: 300,
            fit: BoxFit.cover,
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Finance Tracking",
          body:
              "Take control of your finances and monitor expenses. FinTask - Your path to financial freedom.",
          image: Lottie.asset(
            './animations/finance.json', // Replace with the path to your Lottie animation file
            width: 300,
            height: 300,
            fit: BoxFit.cover,
          ),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      initialPage: 0,
      showBackButton: false,
      //rtl: true, // Display as right-to-left
      back: const Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
      skip: const Text('Skip',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
      next: const Icon(
        Icons.arrow_forward,
        color: Colors.white,
      ),
      done: const Text('Done',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.white,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: ShapeDecoration(
        color: MyColors.primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
