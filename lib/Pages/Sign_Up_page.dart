import 'package:flutter/material.dart';
import 'package:flutter_application_1/Auth/Auth_State.dart';
import 'package:flutter_application_1/Auth/Credentials_Storge.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Custom_Widgets.dart';
import 'Sign_up_Login_page.dart';
import '../DataBase/DataBase_Helper.dart'; // Make sure to import your Cubit
import '../Auth/Auth_Cudit.dart'; // Make sure to import DatabaseHelper

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class SignUpPageWrapper extends StatelessWidget {
  const SignUpPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => AuthCubit(
            DatabaseHelper(),
            SaveCredentials(),
            DeleteCredentials(),
            SaveUserName(),
          ),
      child: const SignUpPage(),
    );
  }
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

  void _showSuccessPopup() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'ImagePopup',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return const ImagePopupOverlay(
          imagePath: 'assets/Create Email.png',
          titleText: 'تم انشاء حسابك بنجاح\n يمكنك الان تسجيل الدخول',
          nextPage: SignUpLoginPage(),
        );
      },
      transitionBuilder:
          (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          _showSuccessPopup();
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is RegistrationSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('تم التسجيل بنجاح')));
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
              alignment: const Alignment(0, 0.67),
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
                vertical: 0.0,
              ),
              icon: const FaIcon(
                FontAwesomeIcons.google,
                color: Color(0xFF4285F4),
                size: 24,
              ),
              backgroundColor: Colors.white,
            ),

            // Register button using AuthCubit
            CustomButton(
              onPressed: () {
                final cubit = context.read<AuthCubit>();
                cubit.registerUser(
                  username: _usernameController.text,
                  email: _emailController.text,
                  password: _passwordController.text,
                );
              },
              text: 'انشاء حساب',
              alignment: const Alignment(0, 0.36),
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
                vertical: 0.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImagePopupOverlay extends StatelessWidget {
  final String imagePath;
  final String titleText;
  final Widget nextPage;
  final double width;
  final double height;

  const ImagePopupOverlay({
    super.key,
    required this.imagePath,
    required this.titleText,
    required this.nextPage,
    this.width = 280,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              FlexibleTextBlock(
                title: titleText,
                titleFontSize: 17,
                titleFont: GoogleFonts.almarai,
                titleColor: Colors.black87,
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(top: 150, right: 9),
              ),
              CustomButton(
                onPressed: () {
                  navigateToNextPage(context, SignUpLoginPage());
                },
                text: 'الاستمرار',
                alignment: const Alignment(0, 0.91),
                padding: const EdgeInsets.symmetric(
                  horizontal: 26.0,
                  vertical: 0.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
