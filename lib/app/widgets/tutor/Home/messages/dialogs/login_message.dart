import 'package:capacidades_especiales/app/utils/resources/app_colors.dart';
import 'package:flutter/material.dart';

class Dialogs {
  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.contentColorBlue.withOpacity(.8),
        behavior: SnackBarBehavior.floating));
  }

  static void showSnackbarError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.contentColorRed.withOpacity(.8),
        behavior: SnackBarBehavior.floating));
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => const Center(child: CircularProgressIndicator()));
  }

  static void confirmationDialog(
      BuildContext context, String s, String t, Null Function() param3) {}
}
