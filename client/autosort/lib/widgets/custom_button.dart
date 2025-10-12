import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double elevation;
  final bool disableBorder;
  final Color hoverColor;
  final bool enableFlex;
  final Color borderColor;
  final IconData? icon; // <-- Optional icon
  final double iconSize; // <-- Icon size
  final double spacing; // <-- Space between icon and text

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
    this.elevation = 0,
    this.disableBorder = false,
    this.hoverColor = const Color.fromARGB(0, 0, 0, 0),
    this.enableFlex = false,
    this.borderColor = Colors.grey,
    this.icon, // optional
    this.iconSize = 20,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.hovered)) {
            return hoverColor;
          }
          return backgroundColor;
        }),
        foregroundColor: WidgetStateProperty.all<Color>(textColor),
        elevation: WidgetStateProperty.all<double>(elevation),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: disableBorder
                ? BorderSide.none
                : BorderSide(color: borderColor, width: 1),
          ),
        ),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(padding),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: iconSize, color: textColor),
            SizedBox(width: spacing),
          ],
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );

    return enableFlex ? SizedBox(width: double.infinity, child: button) : button;
  }
}
