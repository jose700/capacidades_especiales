import "package:capacidades_especiales/app/utils/resources/app_colors.dart";
import "package:flutter/material.dart";

class IconBottomBar extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool selected;
  final Function() onPressed;
  const IconBottomBar({
    super.key,
    required this.text,
    required this.icon,
    this.selected = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              size: 30,
              color: selected ? AppColors.mantis : AppColors.midnightGreen,
            )),
        Text(
          text,
          style: TextStyle(
              fontSize: 12,
              height: 0.1,
              color: selected ? Colors.transparent : Colors.transparent),
        )
      ],
    );
  }
}
