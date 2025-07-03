import 'package:flutter/material.dart';

import 'Pages/backgroud_page.dart';
import 'Pages/onboardin_page1.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyPageViewScreen() );
  }
}


class MyPageViewScreen extends StatefulWidget {
  const MyPageViewScreen({super.key});

  @override
  _MyPageViewScreenState createState() => _MyPageViewScreenState();
}


class _MyPageViewScreenState extends State<MyPageViewScreen> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();

    // After 5 seconds, animate to the next page
    Future.delayed(Duration(seconds: 5), () {
      _pageController.animateToPage(
        1,
        duration: Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(), // disables user swiping
        children: [
          LogoTransitionScreen(),  // Your first page
          OnboardinPage1(),        // Your second page
        ],
      ),
    );
  }
}
