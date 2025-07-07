import 'package:flutter/material.dart';


class BackgroudPage extends StatefulWidget {
  const BackgroudPage({super.key});

  @override
  _BackgroudPageState createState() => _BackgroudPageState();
}

class _BackgroudPageState extends State<BackgroudPage> {
  bool showSecond = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        showSecond = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image fills the whole screen
          Positioned.fill(
            child: Image.asset(
              'assets/Splash_screen.png', // Replace with your background image
              fit: BoxFit.cover, // Stretch and cover entire screen
            ),
          ),

          Center(
            child: SizedBox(
              width: 260, // fixed width to avoid resizing glitches
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedPadding(
                    duration: Duration(milliseconds: 600),
                    padding: EdgeInsets.only(right: showSecond ? 20 : 0),
                    curve: Curves.easeInOut,
                    child: Image.asset('assets/First_Logo.jpg', width: 120),
                  ),
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 600),
                    opacity: showSecond ? 1 : 0,
                    child: Image.asset('assets/Second_Logo.jpg', width: 120),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
