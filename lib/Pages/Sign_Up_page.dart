import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Custom_Widgets.dart';
import 'Sign_up_Login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
      pageBuilder: (context, animation, secondaryAnimation) {
        return const ImagePopupOverlay(
          imagePath: 'assets/Create Email.png',
          titleText: 'تم انشاء حسابك بنجاح\n يمكنك الان تسجيل الدخول',
          nextPage: SignUpLoginPage(),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundImagePath: 'assets/Sign Up - Email.png',
      body: Stack(
        children: [
          // Top bar container with fixed height and solid color
          Container(
            height: 35,
            decoration: const BoxDecoration(color: Color(0xFF6026E2)),
          ),

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

          // Username field
          CustomUsernameTextBox(
            top: 256,
            left: 20,
            right: 20,
            boxColor: Colors.white,
            height: 58,
            controller: _usernameController,
            textColor: Colors.black87,
            fontSize: 16,
            textStyle: GoogleFonts.almarai(),
          ),

          // Email field
          CustomEmailTextBox(
            top: 328,
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
            top: 401,
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

          // Create account button
          CustomButton(
            onPressed: () {
              _showSuccessPopup();
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
