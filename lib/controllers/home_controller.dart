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

  // Add index control
  final RxInt currentIndex = 1.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint('HomeController initialized');
    isSelected = List.generate(problemList.length, (index) => false);
    currentIndex.value = 1; // Ensure we start at index 1
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

  // Method to handle index progression
  void progressIndex() {
    if (currentIndex.value >= 3) {
      currentIndex.value = 1;
    } else {
      currentIndex.value++;
    }
    // Reset selections when moving to next step
    resetForm();
  }

  // Modify existing submitForm to handle progression
  Future<void> submitForm() async {
    try {
      if (scannedCode.value.isEmpty) {
        throw 'Please scan a QR code first';
      }

      if (currentIndex.value == 1 && getSelectedProblems().isEmpty) {
        throw 'Please select at least one problem';
      }

      isLoading.value = true;

      // Add your submission logic here
      await Future.delayed(const Duration(seconds: 1)); // Simulated API call

      debugPrint('Submitting form with:');
      debugPrint('Code: ${scannedCode.value}');
      debugPrint('Selected problems: ${getSelectedProblems()}');
      debugPrint('Current index: ${currentIndex.value}');

      Get.snackbar(
        'Success',
        'Form submitted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Progress to next step
      progressIndex();
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

  // Add this method to handle the bottom button click
  void handleBottomButtonClick() {
    debugPrint('Button clicked! Current index before: ${currentIndex.value}');

    if (currentIndex.value >= 3) {
      currentIndex.value = 1;
    } else {
      currentIndex.value++;
    }

    debugPrint('New index after click: ${currentIndex.value}');

    // Reset form when moving to next step
    resetForm();

    // Force UI update
    update();
  }
}
