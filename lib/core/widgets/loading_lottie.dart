import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // supaya tidak bisa ditutup sembarangan
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: Lottie.asset(
            'assets/lottie/loading.json',
            width: 120,
            height: 120,
            repeat: true,
          ),
        ),
      );
    },
  );
}
