import 'package:flutter/material.dart';
import 'package:flutter_application_1/Auth/Auth_State.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Custom_Widgets.dart';
import 'Sign_up_Login_page.dart';
import 'Main_page.dart';
import '../Auth/Auth_Cudit.dart'; // Make sure to import DatabaseHelper

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تسجيل الدخول بنجاح'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1),
            ),
          );
          // Delay navigation by 2 seconds (optional)
          Future.delayed(const Duration(seconds: 1), () {
            navigateToNextPage(context, const MainPage());
          });
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: CustomScaffold(
        backgroundImagePath: 'assets/Sign Up - Email.png',
        body: Stack(
          children: [
            Container(height: 35, color: const Color(0xFF6026E2)),

            // Title and subtitle
            FlexibleTextBlock(
              title: 'انشاء حساب',
              subtitle: 'يرجى ادخال بياناتك لانشاء حساب جديد',
              padding: const EdgeInsets.only(right: 0.0, top: 94.0, left: 23.0),
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
            // UI elements remain same...
            CustomUsernameTextBox(
              top: 256,
              left: 20,
              right: 20,
              controller: _usernameController,
              boxColor: Colors.white,
              height: 58,
              textColor: Colors.black87,
              fontSize: 16,
              textStyle: GoogleFonts.almarai(),
            ),
            CustomEmailTextBox(
              top: 328,
              left: 20,
              right: 20,
              controller: _emailController,
              boxColor: Colors.white,
              height: 58,
              textColor: Colors.black87,
              fontSize: 16,
              textStyle: GoogleFonts.almarai(),
            ),
            CustomPasswordTextBox(
              top: 401,
              left: 20,
              controller: _passwordController,
              initialObscure: _obscurePassword,
              onToggleVisibility: _togglePasswordVisibility,
              width: 320,
              height: 58,
              boxColor: Colors.white,
              iconPosition: IconPosition.left,
              iconColor: Colors.deepPurple,
              textStyle: GoogleFonts.almarai(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            // Google button stays dummy
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
              icon: const FaIcon(
                FontAwesomeIcons.google,
                color: Color(0xFF4285F4),
                size: 24,
              ),
              alignment: const Alignment(0, 0.67),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 60,
              width: 310,
              backgroundColor: Colors.white,
              textStyle: GoogleFonts.almarai(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            // Register button using AuthCubit
            CustomButton(
              onPressed: () {
                final cubit = context.read<AuthCubit>();
                cubit.registerUser(
                  username: _usernameController.text.trim(),
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                );
              },
              text: 'إنشاء حساب',
              alignment: const Alignment(0, 0.36), // Vertical positioning
              height: 55,
              width: 310, // You can adjust or remove for full width
              backgroundColor: const Color(0xFFB8FF01),
              textStyle: GoogleFonts.almarai(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
