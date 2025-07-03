// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Onboardin_page3.dart';

class OnboardinPage2 extends StatefulWidget {
  const OnboardinPage2({super.key});

  @override
  State<OnboardinPage2> createState() => _OnboardinPage2State();
}

class _OnboardinPage2State extends State<OnboardinPage2> {


   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/Onboardin_screen 2.png', // Your background image
              fit: BoxFit.cover, // Makes image fill the screen
            ),
          ),  
        
         
           Container(
            height: 35,
            decoration: BoxDecoration(
              color: Color(0xFF6026E2),
   
            ),
          ),


          
          
          // 📝 Right-aligned Title & Subtitle with padding
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 17.0,
                top: 200,
                left: 13,
              ), // space from right edge
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.end, // align text inside to right
                children: [
                  Text(
                    'ادخر اموالك',
                    textAlign: TextAlign.right, // align multiline text to right
                    style: GoogleFonts.cairo(
                      fontSize: 31,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'وفر أموالك بسهولة من خلال ميزة الادخار الذكي حدد هدفك المالي وسيتتبع التطبيق تقدمك تلقائيًا راقب تطور مدخراتك أسبوعيًا وشهريًا بخطط مرنة وواقعية',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.almarai(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),



           // 🔘 Button over background
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 35.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _navigateToNextPage(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFB8FF01), // 💚 Figma color
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'استمرار',
                        style: GoogleFonts.almarai(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
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




void _navigateToNextPage(BuildContext context) {
   Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 900), // slower
      pageBuilder: (_, __, ___) => OnboardinPage3(),
      transitionsBuilder: (_, animation, __, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutCubic, // smooth entry
        );

        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(1.0, 0.0), // from right
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );
      },
    ),
  );
}

