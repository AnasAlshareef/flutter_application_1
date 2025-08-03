import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/Sign_up_Login_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Custom_Widgets.dart';
import 'Main_page.dart';
import '../Auth/Auth_Cudit.dart'; // Make sure to import DatabaseHelper
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/Auth/Auth_State.dart';

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
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          navigateToNextPage(context, const MainPage()); // or HomePage
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: CustomScaffold(
        backgroundImagePath: 'assets/Sign in - Email.png',
        appBar: AppBar(
          backgroundColor: const Color(0xFFB8FF01),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_forward, color: Color(0xFF6026E2)),
              onPressed: () {
                navigateToNextPage(context, const SignUpLoginPage());
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 30),
                FlexibleTextBlock(
                  title: 'تسجيل الدخول',
                  subtitle:
                      'الرجاء ادخال البريد الالكتروني ورمز المرور الخاص بك',
                  titleFontSize: 24,
                  titleFont: GoogleFonts.almarai,
                  subtitleFontSize: 14,
                  subtitleFont: GoogleFonts.almarai,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  titleColor: const Color(0xFF6026E2),
                  subtitleColor: const Color(0xFF6026E2),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.13),

                CustomEmailTextBox(
                  boxColor: Colors.white,
                  height: 58,
                  controller: _emailController,
                  textColor: Colors.black87,
                  fontSize: 16,
                  textStyle: GoogleFonts.almarai(),
                ),

                SizedBox(height: 20),

                CustomPasswordTextBox(
                  controller: _passwordController,
                  initialObscure: _obscurePassword,
                  iconPosition: IconPosition.left,
                  height: 58,
                  onToggleVisibility: _togglePasswordVisibility,
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

                const SizedBox(height: 20),

                CustomButton(
                  onPressed: () {
                    final email = _emailController.text.trim();
                    final password = _passwordController.text;

                    final authCubit = context.read<AuthCubit>();
                    authCubit.loginUser(email: email, password: password);
                  },
                  text: 'تسجيل الدخول',
                  alignment: const Alignment(
                    0,
                    0.34,
                  ), // Controls button vertical placement
                  height: 60,
                  backgroundColor: const Color(0xFFB8FF01),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(right: 8.0),
                        height: 1,
                        color: Colors.white,
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
                    Expanded(child: Container(height: 1, color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 20),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
