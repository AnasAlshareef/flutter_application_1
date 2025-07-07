import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: appBar,
        body: body,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  // Optional customization
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;
  final Widget? icon;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.alignment = Alignment.center,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.width,
    this.height = 50,
    this.icon,
    this.backgroundColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        margin: margin,
        width: width ?? double.infinity,
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? const Color(0xFFB8FF01),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child:
              icon == null
                  ? Text(
                    text,
                    style:
                        textStyle ??
                        GoogleFonts.almarai(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                  )
                  : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      icon!,
                      const SizedBox(width: 10),
                      Text(
                        text,
                        style:
                            textStyle ??
                            GoogleFonts.almarai(
                              fontSize: 18,
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
  final TextAlign? textAlign; // New optional textAlign param

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
    this.textAlign, // optional
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

class PositionedArrowButton extends StatelessWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final VoidCallback onTap;
  final double iconSize;
  final Color color;

  const PositionedArrowButton({
    super.key,
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.onTap,
    this.iconSize = 30,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: GestureDetector(
        onTap: onTap,
        child: Icon(Icons.arrow_forward, size: iconSize, color: color),
      ),
    );
  }
}

class CustomEmailTextBox extends StatefulWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final Color boxColor;
  final Color textColor;
  final double fontSize;
  final TextEditingController controller;
  final double? width;
  final double? height;
  final TextStyle? textStyle;

  const CustomEmailTextBox({
    super.key,
    required this.controller,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.boxColor = Colors.white,
    this.textColor = Colors.black,
    this.fontSize = 16,
    this.width,
    this.height,
    this.textStyle,
  });

  @override
  State<CustomEmailTextBox> createState() => _CustomEmailTextBoxState();
}

class _CustomEmailTextBoxState extends State<CustomEmailTextBox> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    widget.controller.removeListener(_refresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top,
      bottom: widget.bottom,
      left: widget.left,
      right: widget.right,
      child: Container(
        width: widget.width,
        height: widget.height,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: widget.boxColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            // Custom hint text (only visible when input is empty)
            if (widget.controller.text.isEmpty)
              Positioned(
                right: 4,
                top: 12,
                child: Text(
                  'البريد الإلكتروني',
                  style: (widget.textStyle ?? const TextStyle()).copyWith(
                    fontSize: widget.fontSize,
                    color: Colors.grey,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
            TextField(
              controller: widget.controller,
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.left,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '',
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 0, // avoid negative padding
                ),
              ),
              style: (widget.textStyle ?? const TextStyle()).copyWith(
                fontSize: widget.fontSize,
                color: widget.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomUsernameTextBox extends StatefulWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final Color boxColor;
  final Color textColor;
  final double fontSize;
  final TextEditingController controller;
  final double? width;
  final double? height;
  final TextStyle? textStyle;

  const CustomUsernameTextBox({
    super.key,
    required this.controller,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.boxColor = Colors.white,
    this.textColor = Colors.black,
    this.fontSize = 16,
    this.width,
    this.height,
    this.textStyle,
  });

  @override
  State<CustomUsernameTextBox> createState() => _CustomUsernameTextBoxState();
}

class _CustomUsernameTextBoxState extends State<CustomUsernameTextBox> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    widget.controller.removeListener(_refresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top,
      bottom: widget.bottom,
      left: widget.left,
      right: widget.right,
      child: Container(
        width: widget.width,
        height: widget.height,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: widget.boxColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            // Custom hint text (only visible when input is empty)
            if (widget.controller.text.isEmpty)
              Positioned(
                right: 4,
                top: 12,
                child: Text(
                  'الأسم الكامل',
                  style: (widget.textStyle ?? const TextStyle()).copyWith(
                    fontSize: widget.fontSize,
                    color: Colors.grey,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
            TextField(
              controller: widget.controller,
              keyboardType: TextInputType.name,
              textAlign: TextAlign.left,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '',
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 0,
                ),
              ),
              style: (widget.textStyle ?? const TextStyle()).copyWith(
                fontSize: widget.fontSize,
                color: widget.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomNumberTextBox extends StatefulWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final Color boxColor;
  final Color textColor;
  final double fontSize;
  final TextEditingController controller;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final bool allowDecimal;
  final Color borderColor;

  const CustomNumberTextBox({
    super.key,
    required this.controller,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.boxColor = Colors.white,
    this.textColor = Colors.black,
    this.fontSize = 16,
    this.width,
    this.height,
    this.textStyle,
    this.allowDecimal = false,
    this.borderColor = Colors.transparent,
  });

  @override
  State<CustomNumberTextBox> createState() => _CustomNumberTextBoxState();
}

class _CustomNumberTextBoxState extends State<CustomNumberTextBox> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    widget.controller.removeListener(_refresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top,
      bottom: widget.bottom,
      left: widget.left,
      right: widget.right,
      child: Container(
        width: widget.width,
        height: widget.height,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: widget.boxColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: widget.borderColor,
            width: 2, // Default border width
          ),
        ),
        child: Stack(
          children: [
            if (widget.controller.text.isEmpty)
              Positioned(
                right: 2,
                top: 8,
                child: Text(
                  'رقم فقط',
                  style: (widget.textStyle ?? const TextStyle()).copyWith(
                    fontSize: widget.fontSize,
                    color: const Color.fromARGB(255, 108, 108, 108),
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
            TextField(
              controller: widget.controller,
              keyboardType:
                  widget.allowDecimal
                      ? const TextInputType.numberWithOptions(decimal: true)
                      : TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  widget.allowDecimal
                      ? RegExp(r'^\d*\.?\d{0,3}')
                      : RegExp(r'^\d+'),
                ),
              ],
              textAlign: TextAlign.left,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '',
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 0,
                ),
              ),
              style: (widget.textStyle ?? const TextStyle()).copyWith(
                fontSize: widget.fontSize,
                color: widget.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDropdownBox extends StatefulWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double? width;
  final double? height;
  final List<String> items;
  final String? selectedValue;
  final Color boxColor;
  final Color textColor;
  final double fontSize;
  final TextStyle? textStyle;
  final ValueChanged<String?> onChanged;
  final TextDirection textDirection;
  final Color borderColor;

  const CustomDropdownBox({
    super.key,
    required this.items,
    required this.onChanged,
    this.selectedValue,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.width,
    this.height,
    this.boxColor = Colors.white,
    this.textColor = Colors.black,
    this.fontSize = 16,
    this.textStyle,
    this.textDirection = TextDirection.ltr,
    this.borderColor = Colors.transparent,
  });

  @override
  State<CustomDropdownBox> createState() => _CustomDropdownBoxState();
}

class _CustomDropdownBoxState extends State<CustomDropdownBox> {
  String? currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight, // Adjust as needed
      child: Container(
        width: widget.width,
        height: widget.height,
        margin: EdgeInsets.only(
          top: widget.top ?? 0,
          bottom: widget.bottom ?? 0,
          left: widget.left ?? 0,
          right: widget.right ?? 0,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          color: widget.boxColor,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: widget.borderColor,
            width: 2,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            value: currentValue,
            dropdownDecoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(21),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            icon: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.arrow_drop_down_rounded,
                size: 40,
                color: Colors.black,
              ),
            ),
            iconEnabledColor: Colors.black,
            style: TextStyle(
              fontSize: widget.fontSize,
              color: widget.textColor,
            ),
            onChanged: (value) {
              setState(() {
                currentValue = value;
              });
              widget.onChanged(value);
            },
            items: widget.items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    item,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}












enum IconPosition { left, right }

class CustomPasswordTextBox extends StatefulWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final Color boxColor;
  final Color textColor;
  final double height;
  final double width;
  final IconData visibleIcon;
  final IconData hiddenIcon;
  final double iconSize;
  final Color iconColor;
  final TextEditingController controller;
  final VoidCallback onToggleVisibility;
  final Alignment hintAlignment;
  final EdgeInsets hintPadding;
  final TextAlign inputTextAlign;
  final EdgeInsets inputPadding;
  final TextStyle? textStyle;
  final String hintText;
  final TextDirection textDirection;
  final Color borderColor;
  final double borderWidth;
  final IconPosition iconPosition;
  final bool initialObscure;

  const CustomPasswordTextBox({
    super.key,
    required this.controller,
    required this.onToggleVisibility,
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.boxColor = Colors.white,
    this.textColor = Colors.black,
    this.height = 50,
    this.width = 300,
    this.visibleIcon = Icons.visibility,
    this.hiddenIcon = Icons.visibility_off,
    this.iconSize = 24,
    this.iconColor = Colors.grey,
    this.hintAlignment = Alignment.centerRight,
    this.hintPadding = const EdgeInsets.only(right: 36),
    this.inputTextAlign = TextAlign.left,
    this.inputPadding = const EdgeInsets.symmetric(vertical: 14, horizontal: 0),
    this.textStyle,
    this.hintText = 'كلمة المرور',
    this.textDirection = TextDirection.rtl,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0,
    this.iconPosition = IconPosition.right,
    this.initialObscure = true,
  });

  @override
  State<CustomPasswordTextBox> createState() => _CustomPasswordTextBoxState();
}

class _CustomPasswordTextBoxState extends State<CustomPasswordTextBox> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.initialObscure;
    widget.controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTextStyle =
        widget.textStyle ?? TextStyle(fontSize: 16, color: widget.textColor);

    final iconWidget = GestureDetector(
      onTap: () {
        setState(() {
          _obscureText = !_obscureText;
        });
        widget.onToggleVisibility();
      },
      child: Icon(
        _obscureText ? widget.hiddenIcon : widget.visibleIcon,
        size: widget.iconSize,
        color: widget.iconColor,
        semanticLabel: _obscureText ? 'Show password' : 'Hide password',
      ),
    );

    return Positioned(
      top: widget.top,
      bottom: widget.bottom,
      left: widget.left,
      right: widget.right,
      child: Container(
        height: widget.height,
        width: widget.width,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: widget.boxColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: widget.borderColor,
            width: widget.borderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Directionality(
          textDirection: widget.textDirection,
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              if (widget.controller.text.isEmpty)
                Positioned.fill(
                  child: Padding(
                    padding: widget.hintPadding,
                    child: Align(
                      alignment: widget.hintAlignment,
                      child: Text(
                        widget.hintText,
                        style: effectiveTextStyle.copyWith(color: Colors.grey),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ),
              Row(
                children: [
                  if (widget.iconPosition == IconPosition.left) iconWidget,
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      obscureText: _obscureText,
                      textAlign: widget.inputTextAlign,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '',
                        contentPadding: widget.inputPadding,
                      ),
                      style: effectiveTextStyle,
                      cursorColor: widget.iconColor,
                    ),
                  ),
                  if (widget.iconPosition == IconPosition.right) iconWidget,
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
