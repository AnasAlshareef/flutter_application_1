import 'package:flutter/material.dart';
import 'Custom_Widgets.dart'; 

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundImagePath: 'assets/Sign in - Email.png',
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