import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/repair_controller.dart';
import '../controllers/repair_service.dart';

class RepairScreen extends GetView<RepairController> {
  const RepairScreen({Key? key}) : super(key: key);

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    
    if (images.isNotEmpty) {
      controller.addPictures(images.map((image) => image.path).toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repair Machine'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Machine Code Input
                  TextField(
                    onChanged: controller.setMachineCode,
                    decoration: const InputDecoration(
                      labelText: 'Enter Machine Code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.fetchMachineDetails,
                    child: const Text('Check Machine'),
                  ),
                  const SizedBox(height: 24),
                  // Machine Details
                  GetX<RepairController>(
                    builder: (_) {
                      final machine = controller.machineDetail.value;
                      if (machine != null) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Machine Details',
                                        style: Theme.of(context).textTheme.titleLarge),
                                    const SizedBox(height: 8),
                                    Text('Chinese Name: ${machine.chineseName}'),
                                    Text('English Name: ${machine.englishName}'),
                                    Text('Brand: ${machine.brand}'),
                                    Text('Serial Number: ${machine.serialNumber}'),
                                    Text('Location: ${machine.location}'),
                                    const SizedBox(height: 8),
                                    Text('Status: ${machine.status}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: machine.status.toString().contains('REPAIR')
                                              ? Colors.orange
                                              : Colors.green,
                                        )),
                                    if (machine.repairTicketId != null)
                                      Text('Repair Ticket: ${machine.repairTicketId}'),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Form fields based on status
                            if (machine.status == MachineStatus.OK) ...[
                              TextField(
                                onChanged: (value) => controller.problemsText.value = value,
                                decoration: const InputDecoration(
                                  labelText: 'Problem IDs (comma-separated)',
                                  border: OutlineInputBorder(),
                                  hintText: 'Example: 14,16',
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: controller.submitInitialReport,
                                child: const Text('Submit Report'),
                              ),
                            ] else if (machine.status == MachineStatus.WAITING_REPAIR) ...[
                              Text('Repair Ticket ID: ${machine.repairTicketId}',
                                  style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: controller.beginRepair,
                                child: const Text('Begin Repair'),
                              ),
                            ] else if (machine.status == MachineStatus.UNDER_REPAIR) ...[
                              Text('Repair Ticket ID: ${machine.repairTicketId}',
                                  style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 16),
                              TextField(
                                onChanged: (value) => controller.oilCondition.value = value,
                                decoration: const InputDecoration(
                                  labelText: 'Oil Condition',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                onChanged: (value) => controller.motorCondition.value = value,
                                decoration: const InputDecoration(
                                  labelText: 'Motor Condition',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                onChanged: (value) => controller.machineEfficiency.value = value,
                                decoration: const InputDecoration(
                                  labelText: 'Machine Efficiency',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                onChanged: (value) => controller.problemsText.value = value,
                                decoration: const InputDecoration(
                                  labelText: 'Problems Found (comma-separated)',
                                  border: OutlineInputBorder(),
                                  hintText: 'Example: 14,16',
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                onChanged: (value) => controller.description.value = value,
                                decoration: const InputDecoration(
                                  labelText: 'Description',
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: 3,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: _pickImages,
                                icon: const Icon(Icons.photo_camera),
                                label: Text('Add Pictures (${controller.selectedPicturePaths.length} selected)'),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: controller.submitFinalReport,
                                child: const Text('Submit Final Report'),
                              ),
                            ],
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
          // Loading indicator
          GetX<RepairController>(
            builder: (_) => controller.isLoading.value
              ? Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
