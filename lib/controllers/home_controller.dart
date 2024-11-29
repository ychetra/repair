import 'package:get/get.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  // Text controller for the code input
  final TextEditingController codeController = TextEditingController();

  // Observable variables
  final RxString scannedCode = ''.obs;
  final RxBool isLoading = false.obs;

  // Problem list and selection state
  final List<String> problemList = [
    'Others',
    'Leak Oil',
    'Broken Needle',
    'Welding foot needle plate (auxiliary tools - pull tube, etc.)',
    'Clean',
    'Broken Hanger',
    'Leak Air',
    'Broken Chain',
    'Thread clamping/needle installation/threading/rod adjustment/density adjustment/thread rack/screw tightening',
    'Thread Detach',
    'Thread Not Attach Well',
    'Change Style Adjust Machine'
  ];

  late List<bool> isSelected;

  @override
  void onInit() {
    super.onInit();
    isSelected = List.generate(problemList.length, (index) => false);
  }

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }

  // Toggle problem selection
  void toggleProblemSelection(int index) {
    isSelected[index] = !isSelected[index];
    update();
  }

  // Process scanned QR code
  Future<void> processScannedCode(String code) async {
    try {
      isLoading.value = true;
      scannedCode.value = code;
      codeController.text = code;

      // Add your QR code processing logic here
      await Future.delayed(const Duration(seconds: 1)); // Simulated API call

      debugPrint('Processing QR code: $code');
      Get.snackbar(
        'Success',
        'QR Code processed successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      debugPrint('Error processing QR code: $e');
      Get.snackbar(
        'Error',
        'Failed to process QR code',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      update();
    }
  }

  // Get selected problems
  List<String> getSelectedProblems() {
    return List.generate(isSelected.length, (index) => index)
        .where((index) => isSelected[index])
        .map((index) => problemList[index])
        .toList();
  }

  // Submit form
  Future<void> submitForm() async {
    try {
      if (scannedCode.value.isEmpty) {
        throw 'Please scan a QR code first';
      }

      final selectedProblems = getSelectedProblems();
      if (selectedProblems.isEmpty) {
        throw 'Please select at least one problem';
      }

      isLoading.value = true;

      // Add your submission logic here
      await Future.delayed(const Duration(seconds: 1)); // Simulated API call

      debugPrint('Submitting form with:');
      debugPrint('Code: ${scannedCode.value}');
      debugPrint('Selected problems: $selectedProblems');

      Get.snackbar(
        'Success',
        'Form submitted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Reset form
      resetForm();
    } catch (e) {
      debugPrint('Error submitting form: $e');
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      update();
    }
  }

  // Reset form
  void resetForm() {
    scannedCode.value = '';
    codeController.clear();
    isSelected = List.generate(problemList.length, (index) => false);
    update();
  }
}
