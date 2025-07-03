import 'package:flutter/material.dart';
import 'Custom_Widgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
        ],
      ),
    );
  }
}
