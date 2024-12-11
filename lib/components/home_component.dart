import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeComponents {
  static Widget buildTextField(String label, String hint, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  static Widget buildRequiredTextField(
    String label,
    String hint,
    TextEditingController controller, {
    FocusNode? focusNode,
    bool hasError = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          labelText: '$label *',
          hintText: hint,
          border: const OutlineInputBorder(),
          errorText: hasError ? 'This field is required' : null,
        ),
      ),
    );
  }

  static Widget buildProblemDropdownWithError(
    List<String> items,
    List<bool> selectedItems,
    bool isOpen,
    Function(int) onItemSelected,
    Function(bool) onDropdownStateChanged,
    bool hasError,
    {
    bool isEnabled = true,
    FocusNode? focusNode,
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: isEnabled
                ? () {
                    onDropdownStateChanged(!isOpen);
                  }
                : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: hasError ? Colors.red : Colors.grey,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Problems${isRequired ? ' *' : ''}',
                    style: TextStyle(
                      color: isEnabled ? Colors.black : Colors.grey,
                    ),
                  ),
                  Icon(
                    isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: isEnabled ? Colors.black : Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          if (hasError)
            const Padding(
              padding: EdgeInsets.only(top: 4.0, left: 12.0),
              child: Text(
                'Please select at least one problem',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
          if (isOpen)
            Container(
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(items[index]),
                    value: selectedItems[index],
                    onChanged: isEnabled
                        ? (bool? value) {
                            onItemSelected(index);
                          }
                        : null,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  static Widget buildRepairLogForm({
    required List<String> problemList,
    required List<bool> problemFoundSelected,
    required bool problemFoundDropdownOpen,
    required Function(int) onProblemFoundSelected,
    required Function(bool) onProblemFoundDropdownStateChanged,
    required FocusNode focusNode,
    required List<XFile> selectedImages,
    required Function(List<XFile>) onImagesSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildProblemDropdownWithError(
          problemList,
          problemFoundSelected,
          problemFoundDropdownOpen,
          onProblemFoundSelected,
          onProblemFoundDropdownStateChanged,
          false,
          focusNode: focusNode,
        ),
        buildTextField('Description', 'Enter repair description', maxLines: 4),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () async {
            final ImagePicker picker = ImagePicker();
            final List<XFile> images = await picker.pickMultiImage();
            if (images.isNotEmpty) {
              onImagesSelected([...selectedImages, ...images]);
            }
          },
          icon: const Icon(Icons.photo_camera),
          label: Text('Add Pictures (${selectedImages.length} selected)'),
        ),
      ],
    );
  }

  static Widget buildSubmitButton(VoidCallback onPressed, String label) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(label),
      ),
    );
  }

  static buildAppBar() {}
}
