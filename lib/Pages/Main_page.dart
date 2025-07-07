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
    return BlocProvider(
      create:
          (_) => AuthCubit(
            DatabaseHelper(),
            SaveCredentials(),
            DeleteCredentials(),
            SaveUserName(),
          ),
      child: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  void showImagePopup(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ImagePopupOverlay(
          imagePath: 'assets/income.png',
          nextPage: const MainPage(),
          titleText: '',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is AuthSuccess) {
          // Optionally update UI, show dialog, or refresh data
          print("Logged in user: ${state.user.username}");
        } else if (state is RegistrationSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('تم التسجيل بنجاح')));
        }
      },
      child: CustomScaffold(
        backgroundImagePath: 'assets/Home screen.png',
        body: Stack(
          children: [
            Container(height: 35, color: const Color(0xFF6026E2)),

            CustomButton(
              onPressed: () {
                showImagePopup(context);
              },
              text: 'اضافة الايرادات',
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(bottom: 290, left: 20),
              width: 156,
              height: 60,
              backgroundColor: const Color.fromARGB(255, 113, 244, 118),
            ),

            CustomButton(
              onPressed: () {},
              text: 'اضافة المصروفات',
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(bottom: 290, right: 20),
              width: 159,
              height: 60,
              backgroundColor: const Color.fromARGB(255, 247, 104, 94),
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

  // Add controllers to manage the inputs
  final TextEditingController numberController = TextEditingController();

  ImagePopupOverlay({
    super.key,
    required this.imagePath,
    required this.titleText,
    required this.nextPage,
    this.width = 330,
    this.height = 340, // increased to fit new widgets
  });

  @override
  Widget build(BuildContext context) {
    String selectedOption = 'الخيار الأول'; // default value
    List<String> options = ['الخيار الأول', 'الخيار الثاني', 'الخيار الثالث'];

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
              // Title
              FlexibleTextBlock(
                title: titleText,
                titleFontSize: 17,
                titleFont: GoogleFonts.almarai,
                titleColor: Colors.black87,
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(top: 140, right: 9),
              ),

              // Custom number input (positioned)
              CustomNumberTextBox(
                controller: numberController,
                top: 102,
                left: 20,
                right: 20,
                height: 45,
                allowDecimal: true,
                borderColor: Color(0xFF00AB06),
                boxColor: const Color.fromARGB(255, 234, 234, 234),
              ),

              // Custom dropdown input (positioned)
              CustomDropdownBox(
                top: 190,
                left: 20,
                right: 20,
                height: 45,
                items: options,
                selectedValue: selectedOption,
                onChanged: (value) {
                  selectedOption = value ?? options.first;
                },
                boxColor: const Color.fromARGB(255, 234, 234, 234),
                borderColor: Color(0xFF00AB06),
                textDirection: TextDirection.ltr,
              ),

              // Continue Button
              CustomButton(
                onPressed: () {
                  navigateToNextPage(context, nextPage);
                },
                text: 'الاستمرار',
                alignment: const Alignment(0, 0.9),
                width: 282,
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                backgroundColor: const Color.fromARGB(255, 0, 204, 7),
                textStyle: GoogleFonts.almarai(
                  fontSize: 16,
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
