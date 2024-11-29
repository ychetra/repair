import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _problemList = [
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
  List<bool> _isSelected = [];

  final TextEditingController codeController = TextEditingController();

  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _isSelected = List.generate(_problemList.length, (index) => false);
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Repair',
              style: GoogleFonts.figtree(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
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
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      filled: true,
                      fillColor: Colors.grey[
                          100], // Changed fill color to match problem lists
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Get.toNamed('/qr-scanner');
                    if (result != null) {
                      setState(() {
                        codeController.text = result.toString();
                      });
                    }
                  },
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('SCAN'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F2937),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildTextField('Khmer Name', 'ឈ្មោះជាភាសាខ្មែរ'),
            _buildTextField('Chinese Name', '中文名'),
            _buildTextField('English Name', 'English name'),
            Row(
              children: [
                Expanded(child: _buildTextField('Brand', 'Brand')),
                const SizedBox(width: 16),
                Expanded(
                    child: _buildTextField('Serial Number', 'Serial Number')),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: _buildTextField('Current Location', 'Location')),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
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
                                color:
                                    Colors.black, // Default color for "Problem"
                              ),
                            ),
                            TextSpan(
                              text: '*',
                              style: GoogleFonts.figtree(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.red, // Red color for the asterisk
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
                          onOpened: () {
                            setState(() {
                              _isDropdownOpen = true;
                            });
                          },
                          onCanceled: () {
                            setState(() {
                              _isDropdownOpen = false;
                            });
                          },
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.4,
                            maxWidth: MediaQuery.of(context).size.width * 0.4,
                          ),
                          position: PopupMenuPosition.under,
                          offset: const Offset(0, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _isSelected.any((selected) => selected)
                                        ? _problemList
                                            .asMap()
                                            .entries
                                            .where((entry) =>
                                                _isSelected[entry.key])
                                            .map((entry) => entry.value)
                                            .join(', ')
                                        : 'Problem lists',
                                    style: TextStyle(
                                      color: _isSelected
                                              .any((selected) => selected)
                                          ? Colors.black
                                          : Colors.grey[600],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  _isDropdownOpen
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                  color: Colors.grey[600],
                                ),
                              ],
                            ),
                          ),
                          itemBuilder: (context) {
                            return _problemList.asMap().entries.map((entry) {
                              int index = entry.key;
                              String problem = entry.value;
                              return PopupMenuItem<String>(
                                value: problem,
                                enabled: false,
                                height: 40,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: StatefulBuilder(
                                  builder: (context, setStateLocal) {
                                    return InkWell(
                                      onTap: () {
                                        setStateLocal(() {
                                          _isSelected[index] =
                                              !_isSelected[index];
                                        });
                                        setState(() {});
                                      },
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: _isSelected[index],
                                            onChanged: (bool? value) {
                                              setStateLocal(() {
                                                _isSelected[index] = value!;
                                              });
                                              setState(() {});
                                            },
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              problem,
                                              style: const TextStyle(
                                                  color: Colors.black),
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
                  ),
                ),
              ],
            ),
            _buildTextField('Report Description', 'Description', maxLines: 4),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.flash_on),
              label: const Text('REPORT'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, {int maxLines = 1}) {
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
          enabled: false,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: true,
            fillColor: Colors.grey[100],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }
}
