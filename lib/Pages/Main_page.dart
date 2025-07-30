import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Auth/Auth_Cudit.dart';
import '../Auth/Auth_State.dart';
import 'Custom_Widgets.dart';
import 'PieChart.dart';

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
          appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
          backgroundImagePath: 'assets/home.jpg',
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 70),
                  Row(
                    children: [
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            if (state is AuthSuccess) {
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
                                currentBalance:
                                    state
                                        .user
                                        .balance, // safe because of the check
                              );
                            } else {
                              // Optionally show message if user is not authenticated or loading
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'لم يتم تحميل بيانات المستخدم بعد',
                                    textAlign: TextAlign.center,
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: 159,
                            height: 100,
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 10,
                              bottom: 20,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: const AssetImage('assets/Red Box.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '         إضافة\nالمصروفات',
                                  style: GoogleFonts.cairo(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'اضف ما صرفته\n                    اليوم',
                                  style: GoogleFonts.almarai(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Flexible(
                        child: InkWell(
                          onTap:
                              () => showImagePopup(
                                context,
                                ['المرتب الشهري', 'استثمارات'],
                                const Color(0xFF00AB06),
                                const Color.fromARGB(255, 0, 204, 7),
                                'assets/income.png',
                                'income',
                              ),
                          child: Container(
                            width: 500,
                            height: 100,
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 10,
                              bottom: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: const AssetImage('assets/Green Box.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '    إضافة\nالإيرادات',
                                  style: GoogleFonts.cairo(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'اضف ما اكتسبته \n                        اليوم',
                                  style: GoogleFonts.almarai(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  if (state is AuthSuccess)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: FlexibleTextBlock(
                              title: 'قيمة حسابك ',
                              subtitle: "دل ${state.user.balance}",
                              titleFontSize: 17,
                              titleFont: GoogleFonts.cairo,
                              subtitleFontSize: 15,
                              subtitleFont: GoogleFonts.almarai,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              textAlign: TextAlign.center,
                              titleColor: const Color(0xFF6026E2),
                              subtitleColor: const Color(0xFF6026E2),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                              'assets/wallet-money 1.png',
                              height: 60,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const Text('لم يتم تحميل الرصيد'),

                  const SizedBox(height: 20),
                  if (state is AuthSuccess)
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF6026E2),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            "مخطط المصروفات",
                            style: GoogleFonts.cairo(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ExpensePieChart(
                            period:
                                'daily', // Change to 'weekly', 'monthly', or 'yearly'
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                ],
              ),
            ),
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
  String type, {
  double? currentBalance, // optional parameter
}) {
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
        onContinue: (selectedCategory, amountText) async {
          final amount = parseToDouble(amountText);

          if (amount == 0.0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'القيمة يجب أن تكون أكبر من صفر',
                  textAlign: TextAlign.center,
                ),
                duration: Duration(seconds: 2),
              ),
            );
            return;
          }

          // Check for expense type and balance
          if (type == 'expense') {
            if (currentBalance == null || currentBalance <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'الرصيد الحالي صفر ولا يمكنك إضافة مصروفات',
                    textAlign: TextAlign.center,
                  ),
                  duration: Duration(seconds: 2),
                ),
              );
              return;
            }

            if (amount > currentBalance) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'المصروف لا يمكن أن يكون أكبر من الرصيد الحالي ($currentBalance)',
                    textAlign: TextAlign.center,
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
              return;
            }
          }

          final authCubit = context.read<AuthCubit>();
          await authCubit.addTransaction(
            categoryName: selectedCategory,
            amount: amount,
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
                  if (numberController.text.trim().isEmpty ||
                      selectedOption.isEmpty) {
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
