import 'package:flutter/material.dart';
import 'Custom_Widgets.dart'; 

class CreateEmail extends StatefulWidget {
  const CreateEmail({super.key});

  @override
  State<CreateEmail> createState() => _CreateEmailState();
}

class _CreateEmailState extends State<CreateEmail> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundImagePath: 'assets/Create Email.png',
      body: Stack(

      ),
    );
  }
}
