import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Sign_up_Login_page.dart';
import 'Custom_Widgets.dart'; // Adjust the path to your actual location

class OnboardinPage3 extends StatefulWidget {
  const OnboardinPage3({super.key});

  @override
  State<OnboardinPage3> createState() => _OnboardinPage3State();
}

class _OnboardinPage3State extends State<OnboardinPage3> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundImagePath: 'assets/Onboardin_screen 3.png',
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.45),
            FlexibleTextBlock(
              title: 'راقب حسابك',
              subtitle:
                  'تابع حركة أموالك أولًا بأول من خلال ميزة تتبع حسابك سجّل كل مصروف أو مدخول بسهولة وبدون تعقيد احصل على نظرة شاملة حول وضعك المالي في أي وقت',
              padding: const EdgeInsets.only(right: 17.0, top: 360.0, left: 5.0),
              titleFontSize: 34,
              titleFont: GoogleFonts.cairo,
              subtitleFontSize: 18,
              subtitleFont: GoogleFonts.almarai,
              crossAxisAlignment: CrossAxisAlignment.end,
              textAlign: TextAlign.right,
            ),
        
            const Spacer(),
            CustomButton(
              onPressed: () {
                navigateToNextPage(context, SignUpLoginPage());
              },
              text: 'استمرار',
              textStyle: GoogleFonts.almarai(fontSize: 20, color: Colors.black),
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.only(bottom: 20),
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}
