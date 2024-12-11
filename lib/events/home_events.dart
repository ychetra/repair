import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeEvents {
  static void handleSubmitReport({
    required TextEditingController codeController,
    required List<bool> isSelected,
    required Function(bool) setCodeError,
    required Function(bool) setProblemError,
    required int currentIndex,
    required VoidCallback onSuccess,
  }) async {
    if (codeController.text.isEmpty) {
      setCodeError(true);
      return;
    }
    setCodeError(false);

    if (!isSelected.any((selected) => selected)) {
      setProblemError(true);
      return;
    }
    setProblemError(false);

    // TODO: Integrate with API service
    await Future.delayed(const Duration(seconds: 1));
    onSuccess();
  }

  static void handleRepairStage({
    required TextEditingController codeController,
    required Function(bool) setCodeError,
    required VoidCallback onSuccess,
  }) async {
    if (codeController.text.isEmpty) {
      setCodeError(true);
      return;
    }
    setCodeError(false);

    // TODO: Integrate with API service
    await Future.delayed(const Duration(seconds: 1));
    onSuccess();
  }

  static void handleConfirmFixed({
    required List<bool> problemFoundSelected,
    required TextEditingController codeController,
    required Function(bool) setCodeError,
    required VoidCallback onSuccess,
  }) async {
    if (codeController.text.isEmpty) {
      setCodeError(true);
      return;
    }
    setCodeError(false);

    // TODO: Integrate with API service
    await Future.delayed(const Duration(seconds: 1));
    onSuccess();
  }
}
