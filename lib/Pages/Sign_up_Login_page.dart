import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Custom_Widgets.dart'; // Adjust the path to your actual location
import 'Sign_Up_page.dart';
import 'Sign_in_page.dart';

class SignUpLoginPage extends StatefulWidget {
  const SignUpLoginPage({super.key});

  @override
  _SignUpLoginPageState createState() => _SignUpLoginPageState();
}

class _SignUpLoginPageState extends State<SignUpLoginPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundImagePath: 'assets/Sign up & Log in.png',
      body: Stack(
        children: [
          // Top bar container with fixed height and solid color
          Container(
            height: 35,
            decoration: const BoxDecoration(color: Color(0xFF6026E2)),
          ),

          FlexibleTextBlock(
            title: 'أختر طريقة تسجيل دخولك',
            top: 320,
            left: 20,
            right: 20,
            titleFontSize: 28,
            titleFont: GoogleFonts.almarai,
            textAlign: TextAlign.center,
          ),

          CustomButton(
            onPressed: () {
              navigateToNextPage(context, SignInPage());
            },
            text: 'أستمر عن طريق البريد الألكتروني',
            alignment: const Alignment(0, 0.34),
            width: 310,
            height: 60,
            backgroundColor: const Color(0xFFB8FF01),
            textStyle: GoogleFonts.almarai(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),


          CustomButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'هذه الميزة غير متوفرة حاليا',
                    textAlign: TextAlign.center,
                  ),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.black87,
                ),
              );
            },
            text: 'Google',
            alignment: const Alignment(0, 0.72),
            width: 310,
            height: 60,
            icon: const FaIcon(
              FontAwesomeIcons.google,
              color: Color(0xFF4285F4),
              size: 24,
            ),
            backgroundColor: Colors.white,
            textStyle: GoogleFonts.almarai(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          // Add your bottom centered clickable text here
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: RichText(
                text: TextSpan(
                  text: 'ليس لديك حساب؟   ', // ← Added space at the end
                  style: GoogleFonts.almarai(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(
                      text: 'سجل الآن', // fixed spelling from "الأن" to "الآن"
                      style: GoogleFonts.almarai(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              navigateToNextPage(context, SignUpPage());
                            },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
