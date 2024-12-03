import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeEvents {
  static void handleSubmitReport({
    required TextEditingController codeController,
    required List<bool> isSelected,
    required VoidCallback onSuccess,
    required Function(bool) setCodeError,
    required Function(bool) setProblemError,
    required int currentIndex,
  }) {
    // If a snackbar is already showing, don't show another one
    if (Get.isSnackbarOpen) {
      return;
    }

    bool hasError = false;
    bool codeEmpty = codeController.text.isEmpty;
    bool problemEmpty = !isSelected.any((selected) => selected);

    // Reset error states first if fields are valid
    if (!codeEmpty) {
      setCodeError(false);
    }
    if (!problemEmpty) {
      setProblemError(false);
    }

    // In first index, check both fields and show combined error if both are empty
    if (currentIndex == 1 && codeEmpty && problemEmpty) {
      setCodeError(true);
      setProblemError(true);
      Get.snackbar(
        'Error',
        'Please scan a code and select at least one problem',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // Always validate code for both stages
    if (codeEmpty) {
      setCodeError(true);
      hasError = true;
      Get.snackbar(
        'Error',
        'Please scan or enter a code',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // Only validate problem selection in first stage
    if (currentIndex == 1 && problemEmpty) {
      setProblemError(true);
      hasError = true;
      Get.snackbar(
        'Error',
        'Please select at least one problem',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (hasError) {
      return;
    }

    // Show success message
    Get.snackbar(
      'Success',
      'Report submitted successfully',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );

    // Call success callback
    onSuccess();
  }

  // Add new method for handling repair stage
  static void handleRepairStage({
    required TextEditingController codeController,
    required Function(bool) setCodeError,
    required VoidCallback onSuccess,
  }) {
    // If a snackbar is already showing, don't show another one
    if (Get.isSnackbarOpen) {
      return;
    }

    // Validate code
    if (codeController.text.isEmpty) {
      setCodeError(true);
      Get.snackbar(
        'Error',
        'Please scan or enter a code',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // Show success message
    Get.snackbar(
      'Success',
      'Moving to repair log',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );

    // Call success callback
    onSuccess();
  }

  // Add new method for handling confirm fixed stage
  static void handleConfirmFixed({
    required List<bool> problemFoundSelected,
    required TextEditingController codeController,
    required Function(bool) setCodeError,
    required Function onSuccess,
  }) {
    bool hasError = false;
    final bool codeEmpty = codeController.text.trim().isEmpty;

    // Validate code
    if (codeEmpty) {
      setCodeError(true);
      hasError = true;
      Get.snackbar(
        'Error',
        'Please scan or enter a code',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // Rest of the existing validation logic...
    if (!problemFoundSelected.contains(true)) {
      hasError = true;
      Get.snackbar(
        'Error',
        'Please select at least one problem found',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (!hasError) {
      // Add success message before calling onSuccess
      Get.snackbar(
        'Success',
        'Repair confirmed successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      
      onSuccess();
    }
  }
}
