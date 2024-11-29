import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repair/controllers/home_controller.dart';

class Home1Page extends StatefulWidget {
  const Home1Page({super.key});

  @override
  State<Home1Page> createState() => _Home1PageState();
}

class _Home1PageState extends State<Home1Page> {
  final HomeController controller = Get.find<HomeController>();
  final TextEditingController codeController = TextEditingController();

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: GetBuilder<HomeController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'First Scan Report',
                  style: GoogleFonts.figtree(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildScanSection(),
                const SizedBox(height: 24),
                _buildProblemSelection(),
                const SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildScanSection() {
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
              controller.processScannedCode(result.toString());
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

  Widget _buildProblemSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Problems',
          style: GoogleFonts.figtree(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.problemList.length,
          itemBuilder: (context, index) {
            return CheckboxListTile(
              title: Text(controller.problemList[index]),
              value: controller.isSelected[index],
              onChanged: (bool? value) {
                controller.toggleProblemSelection(index);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton.icon(
      onPressed: controller.isSelected.any((selected) => selected)
          ? () {
              // Handle submission
              Get.snackbar(
                'Success',
                'First scan report submitted',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          : null,
      icon: const Icon(Icons.send),
      label: const Text('SUBMIT REPORT'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        minimumSize: const Size(double.infinity, 48),
      ),
    );
  }
}
