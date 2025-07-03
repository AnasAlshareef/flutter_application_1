import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    this.appBar,
    this.body,
    this.bottomNavigationBar,
    this.backgroundImagePath,
  });

  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? bottomNavigationBar;
  final String? backgroundImagePath; // New parameter

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            backgroundImagePath ?? 'assets/default_background.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar,
        body: body,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}

class RightAlignedTextBlock extends StatelessWidget {
  final String title;
  final String? subtitle; // Make subtitle optional
  final EdgeInsetsGeometry padding;

  const RightAlignedTextBlock({
    super.key,
    required this.title,
    this.subtitle, // No longer required
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              title,
              textAlign: TextAlign.right,
              style: GoogleFonts.cairo(
                fontSize: 31,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 30),
              Text(
                subtitle!,
                textAlign: TextAlign.right,
                style: GoogleFonts.almarai(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Alignment alignment;
  final EdgeInsetsGeometry padding;

  // Optional parameters
  final double? width;
  final Widget? icon;
  final Color? backgroundColor;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.alignment,
    required this.padding,
    this.width,
    this.icon,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: SizedBox(
          width: width ?? double.infinity, // Use provided width or default
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor ?? const Color(0xFFB8FF01),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: icon == null
                ? Text(
                    text,
                    style: GoogleFonts.almarai(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      icon!,                 // Icon first
                      const SizedBox(width: 10),  // Space between icon and text
                      Text(
                        text,
                        style: GoogleFonts.almarai(
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


class FlexibleTextBlock extends StatelessWidget {
  final String title;
  final String? subtitle;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final Alignment? alignment; // Optional alignment if not using Positioned
  final EdgeInsetsGeometry? padding;
  final double titleFontSize;
  final double? subtitleFontSize;
  final TextStyle Function({TextStyle? textStyle}) titleFont;
  final TextStyle Function({TextStyle? textStyle})? subtitleFont;
  final Color titleColor;
  final Color subtitleColor;
  final CrossAxisAlignment crossAxisAlignment;
  final TextAlign? textAlign;  // New optional textAlign param

  const FlexibleTextBlock({
    super.key,
    required this.title,
    this.subtitle,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.alignment,
    this.padding,
    required this.titleFontSize,
    this.subtitleFontSize,
    required this.titleFont,
    this.subtitleFont,
    this.titleColor = Colors.white,
    this.subtitleColor = Colors.white,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.textAlign,  // optional
  });

  @override
  Widget build(BuildContext context) {
    final content = Align(
      alignment: alignment ?? Alignment.topLeft,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            Text(
              title,
              style: titleFont().copyWith(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
              textAlign: textAlign ?? TextAlign.right, // Use passed or default
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 30),
              Text(
                subtitle!,
                style: (subtitleFont ?? GoogleFonts.almarai)().copyWith(
                  fontSize: subtitleFontSize ?? 18,
                  color: subtitleColor,
                ),
                textAlign: textAlign ?? TextAlign.right, // Same here
              ),
            ],
          ],
        ),
      ),
    );

    if (top != null || bottom != null || left != null || right != null) {
      return Positioned(
        top: top,
        bottom: bottom,
        left: left,
        right: right,
        child: content,
      );
    }

    return content;
  }
}




void navigateToNextPage(BuildContext context, Widget targetPage) {
  Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 900), // slower
      pageBuilder: (_, __, ___) => targetPage,
      transitionsBuilder: (_, animation, __, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutCubic, // smooth entry
        );

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0), // from right
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );
      },
    ),
  );
}

