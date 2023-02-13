import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CustomMessage {
  static snackMessage(message, status, context) {
    if (status == "success") {
      showTopSnackBar(
        Overlay.of(context)!,
        CustomSnackBar.success(
          message: message,
        ),
      );
    } else if (status == "error") {
      showTopSnackBar(
        Overlay.of(context)!,
        CustomSnackBar.error(
          message: message,
        ),
      );
    } else {
      showTopSnackBar(
        Overlay.of(context)!,
        CustomSnackBar.info(
          message: message,
        ),
      );
    }
  }
}
