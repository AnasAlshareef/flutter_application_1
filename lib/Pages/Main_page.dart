import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Auth/Auth_Cudit.dart';
import '../Auth/Auth_State.dart';
import '../Auth/Credentials_Storge.dart';
import '../DataBase/DataBase_Helper.dart';
import 'Custom_Widgets.dart';
import 'Sign_up_Login_page.dart';

class MainPageWrapper extends StatelessWidget {
  const MainPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainPage();
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return CustomScaffold(
          backgroundImagePath: 'assets/Home screen.png',
          body: Stack(
            children: [
              
              Container(height: 35, color: const Color(0xFF6026E2)),

              // Balance display using BlocBuilder
              if (state is AuthSuccess)
                FlexibleTextBlock(
                  title: 'قيمة حسابك ',
                  subtitle: state.user.balance.toString(),
                  padding: const EdgeInsets.only(
                    right: 17.0,
                    top: 270.0,
                    left: 2.0,
                  ),
                  titleFontSize: 10,
                  titleFont: GoogleFonts.cairo,
                  subtitleFontSize: 10,
                  subtitleFont: GoogleFonts.almarai,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  textAlign: TextAlign.center,
                  titleColor: Colors.black54,
                  subtitleColor: Colors.black54,
                )
              else
                const Text('لم يتم تحميل الرصيد'),

              // Income Button
              CustomButton(
                onPressed: () {
                  showImagePopup(
                    context,
                    ['المرتب الشهري', 'اسثمارات'],
                    const Color(0xFF00AB06),
                    const Color.fromARGB(255, 0, 204, 7),
                    'assets/income.png',
                    'income',
                  );
                },
                text: 'اضافة الايرادات',
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(bottom: 290, left: 20),
                width: 156,
                height: 60,
                backgroundColor: const Color.fromARGB(255, 113, 244, 118),
              ),

              // Expense Button
              CustomButton(
                onPressed: () {
                  showImagePopup(
                    context,
                    [
                      'الطعام والشراب',
                      'الإيجار أو السكن',
                      'المواصلات',
                      'الصحة',
                      'التسوق والملابس',
                      'أخرى',
                    ],
                    const Color(0xFFCF0000),
                    const Color.fromARGB(255, 255, 0, 0),
                    'assets/expense.png',
                    'expense',
                  );
                },
                text: 'اضافة المصروفات',
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.only(bottom: 290, right: 20),
                width: 159,
                height: 60,
                backgroundColor: const Color.fromARGB(255, 247, 104, 94),
              ),
            ],
          ),
        );
      },
    );
  }
}

void showImagePopup(
  BuildContext context,
  List<String> dropdownOptions,
  Color dropdownBorderColor,
  Color buttonColor,
  String imagePath,
  String type,
) {
  showDialog(
    context: context,
    barrierColor: Colors.black54,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return ImagePopupOverlay(
        imagePath: imagePath,
        titleText: '',
        BorderColor: dropdownBorderColor,
        dropdownOptions: dropdownOptions,
        buttonColor: buttonColor,
        onContinue: (selectedCategory, amount) async {
          final authCubit = context.read<AuthCubit>();
          await authCubit.addTransaction(
            categoryName: selectedCategory,
            amount: parseToDouble(amount),
            type: type,
            date: DateTime.now().toIso8601String().split('T').first,
          );
          await authCubit.refreshUser();
        },
      );
    },
  );
}

double parseToDouble(String input) {
  try {
    return double.parse(input);
  } catch (e) {
    return 0.0;
  }
}

class ImagePopupOverlay extends StatefulWidget {
  final String imagePath;
  final String titleText;
  final List<String> dropdownOptions;
  final Function(String selectedOption, String numberValue) onContinue;
  final double width;
  final double height;
  final Color BorderColor;
  final Color buttonColor;

  const ImagePopupOverlay({
    super.key,
    required this.imagePath,
    required this.titleText,
    required this.dropdownOptions,
    required this.onContinue,
    this.width = 330,
    this.height = 340,
    required this.BorderColor,
    required this.buttonColor,
  });

  @override
  State<ImagePopupOverlay> createState() => _ImagePopupOverlayState();
}

class _ImagePopupOverlayState extends State<ImagePopupOverlay> {
  final TextEditingController numberController = TextEditingController();
  late String selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.dropdownOptions.first;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(widget.imagePath),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              FlexibleTextBlock(
                title: widget.titleText,
                titleFontSize: 17,
                titleFont: GoogleFonts.almarai,
                titleColor: Colors.black87,
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(top: 140, right: 9),
              ),
              CustomNumberTextBox(
                controller: numberController,
                top: 102,
                left: 20,
                right: 20,
                height: 45,
                allowDecimal: true,
                borderColor: widget.BorderColor,
                boxColor: const Color.fromARGB(255, 234, 234, 234),
              ),
              CustomDropdownBox(
                top: 190,
                left: 20,
                right: 20,
                height: 45,
                items: widget.dropdownOptions,
                selectedValue: selectedOption,
                onChanged: (value) {
                  setState(() {
                    selectedOption = value ?? widget.dropdownOptions.first;
                  });
                },
                boxColor: const Color.fromARGB(255, 234, 234, 234),
                borderColor: widget.BorderColor,
                textDirection: TextDirection.ltr,
              ),
              CustomButton(
                onPressed: () {
                  if (numberController.text.trim().isEmpty || selectedOption.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'يرجى تعبئة كلا الحقلين قبل المتابعة',
                          textAlign: TextAlign.center,
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    return;
                  }
                  widget.onContinue(selectedOption, numberController.text);
                  Navigator.of(context).pop();
                },
                text: 'اضافة',
                alignment: const Alignment(0, 0.9),
                width: 282,
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                backgroundColor: widget.buttonColor,
                textStyle: GoogleFonts.almarai(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}