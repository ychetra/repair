import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';

class HomeComponents {
  static PreferredSizeWidget buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {},
      ),
      title: Row(
        children: [
          Image.asset(
            'assets/images/ytm_logo.png',
            width: 32,
            height: 32,
          ),
          const SizedBox(width: 8),
          Text(
            'YTM',
            style: GoogleFonts.figtree(fontWeight: FontWeight.bold),
          ),
          Text(
            ' V1.0',
            style: GoogleFonts.figtree(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
      actions: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              const Icon(Icons.language),
              const SizedBox(width: 4),
              Text(
                'English',
                style: GoogleFonts.figtree(),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {},
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: CircleAvatar(
            radius: 15,
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.person, size: 20, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  static Widget buildScanSection(TextEditingController codeController) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: codeController,
            enabled: true,
            decoration: InputDecoration(
              hintText: 'Enter code',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () async {
            final result = await Get.toNamed('/qr-scanner');
            if (result != null) {
              codeController.text = result.toString();
            }
          },
          icon: const Icon(Icons.qr_code_scanner),
          label: const Text('SCAN'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1F2937),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
        ),
      ],
    );
  }

  static Widget buildScanSectionWithError(
    TextEditingController codeController,
    bool hasError, {
    FocusNode? focusNode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Code ',
                style: GoogleFonts.figtree(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: hasError ? Colors.red : Colors.black,
                ),
              ),
              TextSpan(
                text: '*',
                style: GoogleFonts.figtree(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: codeController,
                focusNode: focusNode,
                enabled: true,
                style: TextStyle(
                  color: codeController.text.isNotEmpty
                      ? Colors.black
                      : Colors.grey[600],
                ),
                decoration: InputDecoration(
                  hintText: 'Enter code',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: hasError ? Colors.red : Colors.grey.shade300,
                      width: hasError ? 2 : 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: hasError ? Colors.red : Colors.grey.shade300,
                      width: hasError ? 2 : 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: hasError ? Colors.red : Colors.blue,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Get.toNamed('/qr-scanner');
                if (result != null) {
                  codeController.text = result.toString();
                }
              },
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('SCAN'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1F2937),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget buildRequiredTextField(
    String label,
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
    bool enabled = true,
    bool hasError = false,
    FocusNode? focusNode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$label ',
                style: GoogleFonts.figtree(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: hasError ? Colors.red : Colors.black,
                ),
              ),
              TextSpan(
                text: '*',
                style: GoogleFonts.figtree(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                enabled: enabled,
                maxLines: maxLines,
                style: TextStyle(
                  color: controller.text.isNotEmpty
                      ? Colors.black
                      : Colors.grey[600],
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: hasError ? Colors.red : Colors.grey.shade300,
                      width: hasError ? 2 : 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: hasError ? Colors.red : Colors.grey.shade300,
                      width: hasError ? 2 : 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: hasError ? Colors.red : Colors.blue,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Get.toNamed('/qr-scanner');
                if (result != null) {
                  controller.text = result.toString();
                }
              },
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('SCAN'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1F2937),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  static Widget buildProblemDropdown(
    List<String> problemList,
    List<bool> isSelected,
    bool isDropdownOpen,
    Function(int) onProblemSelected,
    Function(bool) onDropdownStateChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Problem ',
                style: GoogleFonts.figtree(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: '*',
                style: GoogleFonts.figtree(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: PopupMenuButton<String>(
            onOpened: () => onDropdownStateChanged(true),
            onCanceled: () => onDropdownStateChanged(false),
            constraints: const BoxConstraints(
              maxHeight: 300,
              maxWidth: 300,
            ),
            position: PopupMenuPosition.under,
            offset: const Offset(0, 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      isSelected.any((selected) => selected)
                          ? problemList
                              .asMap()
                              .entries
                              .where((entry) => isSelected[entry.key])
                              .map((entry) => entry.value)
                              .join(', ')
                          : 'Problem lists',
                      style: TextStyle(
                        color: isSelected.any((selected) => selected)
                            ? Colors.black
                            : Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    isDropdownOpen
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
            itemBuilder: (context) {
              return problemList.asMap().entries.map((entry) {
                int index = entry.key;
                String problem = entry.value;
                return PopupMenuItem<String>(
                  value: problem,
                  enabled: false,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: StatefulBuilder(
                    builder: (context, setStateLocal) {
                      return InkWell(
                        onTap: () {
                          onProblemSelected(index);
                          setStateLocal(() {});
                        },
                        child: Row(
                          children: [
                            Checkbox(
                              value: isSelected[index],
                              onChanged: (bool? value) {
                                onProblemSelected(index);
                                setStateLocal(() {});
                              },
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                problem,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }).toList();
            },
            onSelected: (_) {},
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  static Widget buildProblemDropdownWithError(
    List<String> problemList,
    List<bool> isSelected,
    bool isDropdownOpen,
    Function(int) onProblemSelected,
    Function(bool) onDropdownStateChanged,
    bool hasError, {
    bool isEnabled = true,
    FocusNode? focusNode,
    String label = 'Problem',
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$label ',
                style: GoogleFonts.figtree(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: hasError ? Colors.red : Colors.black,
                ),
              ),
              if (isRequired)
                TextSpan(
                  text: '*',
                  style: GoogleFonts.figtree(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(
              color: hasError ? Colors.red : Colors.grey.shade300,
              width: hasError ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: PopupMenuButton<String>(
            enabled: isEnabled,
            onOpened: () => onDropdownStateChanged(true),
            onCanceled: () => onDropdownStateChanged(false),
            constraints: const BoxConstraints(
              maxHeight: 300,
              maxWidth: 300,
            ),
            position: PopupMenuPosition.under,
            offset: const Offset(0, 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      isSelected.any((selected) => selected)
                          ? problemList
                              .asMap()
                              .entries
                              .where((entry) => isSelected[entry.key])
                              .map((entry) => entry.value)
                              .join(', ')
                          : 'Problem lists',
                      style: TextStyle(
                        color: isSelected.any((selected) => selected)
                            ? Colors.black
                            : Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    isDropdownOpen
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
            itemBuilder: (context) {
              return problemList.asMap().entries.map((entry) {
                int index = entry.key;
                String problem = entry.value;
                return PopupMenuItem<String>(
                  value: problem,
                  enabled: false,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: StatefulBuilder(
                    builder: (context, setStateLocal) {
                      return InkWell(
                        onTap: () {
                          onProblemSelected(index);
                          setStateLocal(() {});
                        },
                        child: Row(
                          children: [
                            Checkbox(
                              value: isSelected[index],
                              onChanged: (bool? value) {
                                onProblemSelected(index);
                                setStateLocal(() {});
                              },
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                problem,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }).toList();
            },
            onSelected: (_) {},
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  static Widget buildSubmitButton(VoidCallback onPressed, String buttonText) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.flash_on),
      label: Text(buttonText),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        minimumSize: const Size(double.infinity, 48),
      ),
    );
  }

  static Widget buildRepairLogForm({
    required List<String> problemList,
    required List<bool> problemFoundSelected,
    required bool problemFoundDropdownOpen,
    required Function(int) onProblemFoundSelected,
    required Function(bool) onProblemFoundDropdownStateChanged,
    required List<XFile> selectedImages,
    required Function(List<XFile>) onImagesSelected,
    FocusNode? focusNode,
    bool isRequired = true,
  }) {
    final List<String> conditions = ['Best', 'Good', 'OK', 'Bad', 'Worse'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Repair Log',
          style: GoogleFonts.figtree(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        buildDropdownField('Oil Condition', conditions),
        buildDropdownField('Motor Condition', conditions),
        buildDropdownField('Machine Efficiency', conditions),
        buildProblemDropdownWithError(
          problemList,
          problemFoundSelected,
          problemFoundDropdownOpen,
          onProblemFoundSelected,
          onProblemFoundDropdownStateChanged,
          false,
          isEnabled: true,
          label: 'Problem Found',
          isRequired: isRequired,
          focusNode: focusNode,
        ),
        buildTextField(
          'Problem Found Description',
          'Description',
          maxLines: 4,
          enabled: true, // Make this field writable
        ),
        buildImageUploadField(
          selectedImages: selectedImages,
          onImagesSelected: onImagesSelected,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  static Widget buildDropdownField(String label, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.figtree(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: PopupMenuButton<String>(
            constraints: BoxConstraints(
              maxHeight:
                  options.length * 48.0, // Height per item * number of items
              maxWidth: 300,
            ),
            position: PopupMenuPosition.under,
            initialValue: options.first,
            itemBuilder: (context) {
              return options.map((option) {
                return PopupMenuItem<String>(
                  value: option,
                  height: 48, // Fixed height for each item
                  child: Text(
                    option,
                    style: TextStyle(
                      color: _getConditionColor(option),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    options.first,
                    style: TextStyle(
                      color: _getConditionColor(options.first),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  static Widget buildImageUploadField({
    required List<XFile> selectedImages,
    required Function(List<XFile>) onImagesSelected,
    onpress,
  }) {
    Future<void> getImages() async {
      final ImagePicker picker = ImagePicker();
      try {
        final List<XFile> images = await picker.pickMultiImage(
          imageQuality: 50,
        );
        if (images.isNotEmpty) {
          onImagesSelected(images);
        }
      } catch (e) {
        debugPrint('Error picking images: $e');
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Picture of item',
          style: GoogleFonts.figtree(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Column(
          children: [
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: getImages,
                  icon: const Icon(Icons.add_photo_alternate),
                  label: const Text('Choose Files'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F2937),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  selectedImages.isEmpty
                      ? 'No file chosen'
                      : '${selectedImages.length} files selected',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            if (selectedImages.isNotEmpty) ...[
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Stack(
                        children: [
                          Image.file(
                            File(selectedImages[index].path),
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            right: 4,
                            top: 4,
                            child: GestureDetector(
                              onTap: () {
                                List<XFile> updatedImages =
                                    List.from(selectedImages);
                                updatedImages.removeAt(index);
                                onImagesSelected(updatedImages);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  static Color _getConditionColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'best':
        return Colors.green;
      case 'good':
        return Colors.lightGreen;
      case 'ok':
        return Colors.orange;
      case 'bad':
        return Colors.deepOrange;
      case 'worse':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  static Widget buildTextField(
    String label,
    String hint, {
    int maxLines = 1,
    bool enabled = false,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.figtree(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
