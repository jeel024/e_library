import 'package:flutter/material.dart';
import 'package:get/get.dart';

errorSnackbar(String description) {
  Get.snackbar(
    "Oops! something went wrong",
    description,
    shouldIconPulse: true,
    colorText: Colors.white,
    backgroundColor: Colors.red,
    icon: const Icon(
      Icons.error,
      color: Colors.white,
    ),
  );
}

successSnackbar(String description) {
  Get.snackbar(
    "Successful!",
    description,
    shouldIconPulse: true,
    colorText: Colors.white,
    backgroundColor: Colors.green,
    icon: const Icon(
      Icons.check,
      color: Colors.white,
    ),
  );
}
