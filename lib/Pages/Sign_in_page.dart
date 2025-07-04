import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Custom_Widgets.dart';
import 'Sign_up_Login_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundImagePath: 'assets/Sign in - Email.png',
      body: Stack(
        children: [
          // Top bar
          Container(
            height: 35,
            decoration: const BoxDecoration(color: Color(0xFF6026E2)),
          ),

          // Title and subtitle
          FlexibleTextBlock(
            title: 'تسجيل الدخول',
            subtitle: 'الرجاء ادخال البريد الالكتروني ورمز المرور الخاص بك',
            padding: const EdgeInsets.only(right: 20.0, top: 90.0, left: 8.0),
            titleFontSize: 31,
            titleFont: GoogleFonts.almarai,
            subtitleFontSize: 18,
            subtitleFont: GoogleFonts.almarai,
            crossAxisAlignment: CrossAxisAlignment.end,
            textAlign: TextAlign.right,
            titleColor: const Color(0xFF6026E2),
            subtitleColor: const Color(0xFF6026E2),
          ),

          // Back arrow
          PositionedArrowButton(
            top: 47,
            right: 17,
            onTap: () {
              navigateToNextPage(context, const SignUpLoginPage());
            },
            iconSize: 30,
            color: const Color(0xFF6026E2),
          ),

          // Email field
          CustomEmailTextBox(
            top: 290,
            left: 20,
            right: 20,
            boxColor: Colors.white,
            height: 58,
            controller: _emailController,
            textColor: Colors.black87,
            fontSize: 16,
            textStyle: GoogleFonts.almarai(),
          ),

          // Password field
          CustomPasswordTextBox(
            top: 370,
            left: 20,
            controller: _passwordController,
            initialObscure: _obscurePassword,
            iconPosition: IconPosition.left,
            onToggleVisibility: _togglePasswordVisibility,
            width: 320,
            height: 58,
            boxColor: Colors.white,
            iconColor: Colors.deepPurple,
            textStyle: GoogleFonts.almarai(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            hintAlignment: Alignment.topRight,
            hintPadding: const EdgeInsets.only(right: 32, top: 14),
            inputTextAlign: TextAlign.left,
            inputPadding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 0,
            ),
          ),
        

          
          CustomButton(
            onPressed: () {
              navigateToNextPage(context, SignInPage());
            },
            text: 'تسجيل الدخول',
            alignment: const Alignment(0, 0.34),
            padding: const EdgeInsets.symmetric(
              horizontal: 21.0,
              vertical: 0.0,
            ),
          ),



          
        ],
      ),
    );
  }
}
