import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Custom_Widgets.dart';
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.43),
            FlexibleTextBlock(
              title: 'أختر طريقة \nتسجيل دخولك',
              titleFontSize: 28,
              titleFont: GoogleFonts.almarai,
              alignment: Alignment.center,
              textAlign: TextAlign.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
            const SizedBox(height: 27),
            CustomButton(
              onPressed: () {
                navigateToNextPage(context, SignInPage());
              },
              text: 'أستمر عن طريق البريد الألكتروني',
              width: double.infinity,
              height: 60,
              backgroundColor: const Color(0xFFB8FF01),
              textStyle: GoogleFonts.almarai(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.white,
                    thickness: 1,
                    endIndent: 8.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'أو باستخدام',
                    style: GoogleFonts.almarai(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.white,
                    thickness: 1,
                    endIndent: 8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
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
                width: double.infinity,
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
            ),
            const SizedBox(height: 30),

            Center(
              child: RichText(
                text: TextSpan(
                  text: 'ليس لديك حساب؟   ',
                  style: GoogleFonts.almarai(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(
                      text: 'سجل الآن',
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
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
