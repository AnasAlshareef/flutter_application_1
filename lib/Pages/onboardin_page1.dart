import 'package:flutter/material.dart';
import 'Custom_Widgets.dart';
import 'Onboardin_page2.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardinPage1 extends StatefulWidget {
  const OnboardinPage1({super.key});

  @override
  State<OnboardinPage1> createState() => _OnboardinPage1State();
}

class _OnboardinPage1State extends State<OnboardinPage1> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundImagePath: 'assets/Onboardin_screen 1.png',
      body: Stack(
        children: [
          // Top bar
          Container(
            height: 35,
            decoration: const BoxDecoration(color: Color(0xFF6026E2)),
          ),

         

          FlexibleTextBlock(
            title: 'مرحبا بكم\nفي تطبيق\nمحفظتي',
            subtitle:
                'تطبيق خاص بتتبع المصروفات والمدخولات الشخصية يساعدك على تنظيم ميزانيتك وتحليل نفقاتك اليومية ويوفر لك إحصائيات أسبوعية وشهرية وسنوية بدقة وسهولة',
            padding: const EdgeInsets.only(right: 17.0, top: 270.0, left: 2.0),
            titleFontSize: 31,
            titleFont: GoogleFonts.cairo,
            subtitleFontSize: 18,
            subtitleFont: GoogleFonts.almarai,
            crossAxisAlignment: CrossAxisAlignment.end, // right aligned
            textAlign: TextAlign.right,
          ),

          // 🔘 Continue Button using CustomContinueButton
          CustomButton(
            onPressed: () {
              navigateToNextPage(context, OnboardinPage2());
            },
            text: 'استمرار',
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.symmetric(
              horizontal: 27.0,
              vertical: 35.0,
            ),
          ),
        ],
      ),
    );
  }
}
