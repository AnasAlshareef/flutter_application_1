import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Custom_Widgets.dart';
import 'Onboardin_page3.dart';

class OnboardinPage2 extends StatefulWidget {
  const OnboardinPage2({super.key});

  @override
  State<OnboardinPage2> createState() => _OnboardinPage2State();
}

class _OnboardinPage2State extends State<OnboardinPage2> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundImagePath: 'assets/Onboardin_screen 2.png',
      body: Stack(
        children: [
          // Top purple bar
          Container(
            height: 35,
            decoration: const BoxDecoration(color: Color(0xFF6026E2)),
          ),

         
          FlexibleTextBlock(
            title: 'ادخر اموالك',
            subtitle:
                'وفر أموالك بسهولة من خلال ميزة الادخار الذكي حدد هدفك المالي وسيتتبع التطبيق تقدمك تلقائيًا راقب تطور مدخراتك أسبوعيًا وشهريًا بخطط مرنة وواقعية',
            padding: const EdgeInsets.only(right: 17.0, top: 360.0, left: 13.0),
            titleFontSize: 33,
            titleFont: GoogleFonts.cairo,
            subtitleFontSize: 18,
            subtitleFont: GoogleFonts.almarai,
            crossAxisAlignment: CrossAxisAlignment.end,
            textAlign: TextAlign.right,
          ),

          // Bottom button using CustomContinueButton
          CustomButton(
            onPressed: () {
              navigateToNextPage(context, OnboardinPage3());
            },
            text: 'استمرار',
            textStyle: GoogleFonts.almarai(fontSize: 20, color: Colors.black),
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(bottom: 20),
            width: 300,
            height: 60,
            ),
          
    
        ],
      ),
    );
  }
}
