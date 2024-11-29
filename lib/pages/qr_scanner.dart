import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({Key? key}) : super(key: key);

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  MobileScannerController? cameraController;
  bool isFlashOn = false;
  bool isFrontCamera = false;
  bool hasPermission = false;

  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isDisposed = false;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAnimation();
    _checkPermissionAndInitialize();
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );

    _animationController.repeat(reverse: true);
  }

  Future<void> _checkPermissionAndInitialize() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() {
        hasPermission = true;
      });
      _initializeCamera();
    } else {
      setState(() {
        hasPermission = false;
      });
    }
  }

  void _initializeCamera() {
    try {
      if (mounted) {
        cameraController?.dispose();
        cameraController = MobileScannerController(
          detectionSpeed: DetectionSpeed.normal,
          facing: isFrontCamera ? CameraFacing.front : CameraFacing.back,
          torchEnabled: isFlashOn,
        );
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;

    switch (state) {
      case AppLifecycleState.resumed:
        _initializeCamera();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        cameraController?.dispose();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!hasPermission) {
      return _buildPermissionRequest();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'QR Code Reader',
          style: GoogleFonts.figtree(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _disposeResources();
            Get.back();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFlashOn ? Icons.flash_on : Icons.flash_off,
              color: isFlashOn ? Colors.yellow : Colors.white,
            ),
            onPressed: () async {
              try {
                await cameraController?.toggleTorch();
                if (mounted) {
                  setState(() {
                    isFlashOn = !isFlashOn;
                  });
                }
              } catch (e) {
                debugPrint('Error toggling torch: $e');
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (cameraController != null)
            MobileScanner(
              controller: cameraController!,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  if (barcode.rawValue != null) {
                    _disposeResources();
                    Get.back(result: barcode.rawValue);
                  }
                }
              },
            ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.width * 0.7,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Positioned(
                        top: _animation.value *
                            MediaQuery.of(context).size.width *
                            0.7,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 2,
                          color: Colors.red,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Scanning...',
                  style: GoogleFonts.figtree(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _disposeResources() {
    if (!_isDisposed) {
      _isDisposed = true;
      if (_animationController.isAnimating) {
        _animationController.stop();
      }
      _animationController.dispose();
      cameraController?.dispose();
    }
  }

  Widget _buildPermissionRequest() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'QR Code Reader',
          style: GoogleFonts.figtree(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.camera_alt_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Camera Permission Required',
              style: GoogleFonts.figtree(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please grant camera permission to scan QR codes',
              style: GoogleFonts.figtree(
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _checkPermissionAndInitialize,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Grant Permission'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _disposeResources();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
