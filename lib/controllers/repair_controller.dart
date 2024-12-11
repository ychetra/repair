import 'package:get/get.dart';
import '../models/api_models.dart' hide MachineStatus;
import '../controllers/repair_service.dart';

class RepairController extends GetxController {
  final RepairService repairService;

  RepairController({required this.repairService});

  final machineCode = ''.obs;
  final isLoading = false.obs;
  final currentIndex = 0.obs;
  final machineDetail = Rxn<MachineDetail>();
  final repairTicketId = Rxn<String>();
  final selectedPicturePaths = <String>[].obs;

  // Form fields
  final problemsText = ''.obs;
  final oilCondition = 'ok'.obs;
  final motorCondition = 'ok'.obs;
  final machineEfficiency = 'ok'.obs;
  final description = ''.obs;

  void setMachineCode(String code) {
    machineCode.value = code;
  }

  Future<void> fetchMachineDetails() async {
    if (machineCode.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a machine code',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      final details = await repairService.getMachineDetails(machineCode.value);
      print('Fetched machine details: $details'); // Debug print
      machineDetail.value = details;
      
      // Set the appropriate index based on machine status
      if (details.status == MachineStatus.OK) {
        currentIndex.value = 1;
      } else if (details.status == MachineStatus.WAITING_REPAIR) {
        currentIndex.value = 2;
        repairTicketId.value = details.repairTicketId?.toString();
      } else if (details.status == MachineStatus.UNDER_REPAIR) {
        currentIndex.value = 3;
        repairTicketId.value = details.repairTicketId?.toString();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to get machine details: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitInitialReport() async {
    if (problemsText.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter problem IDs',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      final problems = problemsText.value
          .split(',')
          .map((e) => int.parse(e.trim()))
          .toList();
      
      await repairService.submitInitialReport(
        machineCode.value,
        problems,
      );
      
      fetchMachineDetails(); // Refresh status
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit report: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading.value = false;
    }
  }

  Future<void> beginRepair() async {
    if (repairTicketId.value == null) {
      Get.snackbar(
        'Error',
        'No repair ticket ID available',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    isLoading.value = true;
    try {
      await repairService.beginRepair(
        machineCode.value,
        int.parse(repairTicketId.value!),
      );
      
      fetchMachineDetails(); // Refresh status
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to begin repair: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading.value = false;
    }
  }

  Future<void> submitFinalReport() async {
    if (repairTicketId.value == null) {
      Get.snackbar(
        'Error',
        'No repair ticket ID available',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (problemsText.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter problems found',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (selectedPicturePaths.isEmpty) {
      Get.snackbar(
        'Error',
        'Please add at least one picture',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    isLoading.value = true;
    try {
      final request = FinalRepairRequest(
        repairTicketId: int.parse(repairTicketId.value!),
        oilCondition: oilCondition.value,
        motorCondition: motorCondition.value,
        machineEfficiency: machineEfficiency.value,
        problemsFound: problemsText.value
            .split(',')
            .map((e) => int.parse(e.trim()))
            .toList(),
        problemsFoundDescription: description.value,
        pictures: selectedPicturePaths,
      );

      await repairService.submitFinalReport(
        machineCode.value,
        request,
        selectedPicturePaths,
      );
      
      fetchMachineDetails(); // Refresh status
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit final report: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading.value = false;
    }
  }

  void addPictures(List<String> paths) {
    selectedPicturePaths.value = paths;
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }
}
