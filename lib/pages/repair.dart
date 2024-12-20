import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:repair/pages/notifcation.dart';
import 'package:repair/components/home_component.dart';
import 'package:repair/events/home_events.dart';

class Repair extends StatefulWidget {
  const Repair({super.key});

  @override
  State<Repair> createState() => _RepairState();
}

class _RepairState extends State<Repair> {
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
  List<bool> _problemFoundSelected = [];
  bool _problemFoundDropdownOpen = false;
  final TextEditingController codeController = TextEditingController();
  bool _isDropdownOpen = false;
  bool _codeError = false;
  bool _problemError = false;
  int currentIndex = 1;
  final FocusNode _codeFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final bool _ignoreFocus = false;
  final FocusNode _dropdownFocusNode = FocusNode();
  List<XFile> _selectedImages = [];
  bool _anyDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _isSelected = List.generate(_problemList.length, (index) => false);
    _problemFoundSelected = List.generate(_problemList.length, (index) => false);
  }

  void _handleProblemSelection(int index) {
    setState(() {
      _isSelected[index] = !_isSelected[index];
    });
  }

  void _handleProblemFoundSelection(int index) {
    setState(() {
      _problemFoundSelected[index] = !_problemFoundSelected[index];
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repair'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Get.to(() => const NotificationPage());
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          if (!_anyDropdownOpen) {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentIndex == 1
                    ? 'First Scan Report'
                    : currentIndex == 2
                        ? 'Second Scan Repair'
                        : 'Repair Log',
                style: GoogleFonts.figtree(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              HomeComponents.buildRequiredTextField(
                'Code',
                'Enter code',
                codeController,
                focusNode: _codeFocusNode,
                hasError: _codeError,
              ),
              const SizedBox(height: 24),
              HomeComponents.buildTextField('Khmer Name', 'ឈ្មោះជាភាសាខ្មែរ'),
              HomeComponents.buildTextField('Chinese Name', '中文名'),
              HomeComponents.buildTextField('English Name', 'English name'),
              Row(
                children: [
                  Expanded(
                    child: HomeComponents.buildTextField('Brand', 'Brand'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: HomeComponents.buildTextField(
                      'Serial Number',
                      'Serial Number',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: HomeComponents.buildTextField(
                      'Current Location',
                      'Location',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: HomeComponents.buildProblemDropdownWithError(
                      _problemList,
                      _isSelected,
                      _isDropdownOpen,
                      currentIndex == 1 ? _handleProblemSelection : (_) {},
                      (isOpen) {
                        if (mounted) {
                          setState(() {
                            _isDropdownOpen = isOpen;
                            _anyDropdownOpen = isOpen;
                            if (isOpen) {
                              _codeFocusNode.unfocus();
                              FocusScope.of(context).unfocus();
                            } else {
                              FocusScope.of(context).unfocus();
                              FocusManager.instance.primaryFocus?.unfocus();
                            }
                          });
                        }
                      },
                      _problemError,
                      isEnabled: currentIndex == 1,
                      focusNode: _dropdownFocusNode,
                      isRequired: currentIndex == 1,
                    ),
                  ),
                ],
              ),
              HomeComponents.buildTextField(
                'Report Description',
                'Description',
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              if (currentIndex == 3)
                HomeComponents.buildRepairLogForm(
                  problemList: _problemList,
                  problemFoundSelected: _problemFoundSelected,
                  problemFoundDropdownOpen: _problemFoundDropdownOpen,
                  onProblemFoundSelected: _handleProblemFoundSelection,
                  onProblemFoundDropdownStateChanged: (isOpen) {
                    if (mounted) {
                      setState(() {
                        _problemFoundDropdownOpen = isOpen;
                        _anyDropdownOpen = isOpen;
                        if (isOpen) {
                          _codeFocusNode.unfocus();
                          FocusScope.of(context).unfocus();
                        } else {
                          FocusScope.of(context).unfocus();
                          FocusManager.instance.primaryFocus?.unfocus();
                        }
                      });
                    }
                  },
                  focusNode: _dropdownFocusNode,
                  selectedImages: _selectedImages,
                  onImagesSelected: (images) {
                    setState(() {
                      _selectedImages = images;
                    });
                  },
                ),
              const SizedBox(height: 24),
              HomeComponents.buildSubmitButton(
                () {
                  if (currentIndex == 2) {
                    HomeEvents.handleRepairStage(
                      codeController: codeController,
                      setCodeError: (value) =>
                          setState(() => _codeError = value),
                      onSuccess: () {
                        setState(() {
                          currentIndex = 3;
                          codeController.clear();
                          _codeError = false;
                        });
                        _scrollToTop();
                      },
                    );
                  } else if (currentIndex == 3) {
                    HomeEvents.handleConfirmFixed(
                      problemFoundSelected: _problemFoundSelected,
                      codeController: codeController,
                      setCodeError: (value) =>
                          setState(() => _codeError = value),
                      onSuccess: () {
                        setState(() {
                          currentIndex = 1;
                          codeController.clear();
                          _isSelected = List.generate(
                              _problemList.length, (index) => false);
                          _problemFoundSelected = List.generate(
                              _problemList.length, (index) => false);
                          _codeError = false;
                          _problemError = false;
                          _selectedImages = [];
                        });

                        Future.delayed(const Duration(milliseconds: 100), () {
                          if (mounted) {
                            _scrollController.animateTo(
                              0,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          }
                        });
                      },
                    );
                  } else {
                    HomeEvents.handleSubmitReport(
                      codeController: codeController,
                      isSelected: _isSelected,
                      setCodeError: (value) =>
                          setState(() => _codeError = value),
                      setProblemError: (value) =>
                          setState(() => _problemError = value),
                      currentIndex: currentIndex,
                      onSuccess: () {
                        setState(() {
                          codeController.clear();
                          _isSelected = List.generate(
                              _problemList.length, (index) => false);
                          _problemFoundSelected = List.generate(
                              _problemList.length, (index) => false);
                          _codeError = false;
                          _problemError = false;
                          currentIndex = 2;
                        });
                        _scrollToTop();
                      },
                    );
                  }
                },
                currentIndex == 1
                    ? 'REPORT'
                    : currentIndex == 2
                        ? 'REPAIR'
                        : 'CONFIRM FIXED',
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    codeController.dispose();
    _codeFocusNode.dispose();
    _dropdownFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
