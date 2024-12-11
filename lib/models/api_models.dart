import 'dart:convert';

// Auth Models
class LoginRequest {
  final String username;
  final String password;

  LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };
}

class LoginResponse {
  final String token;

  LoginResponse({required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        token: json['token'] ?? '',
      );
}

// Repair Models
enum MachineStatus {
  OK,
  WAITING_REPAIR,
  UNDER_REPAIR,
}

class MachineDetail {
  final int id;
  final String khmerName;
  final String chineseName;
  final String englishName;
  final String brand;
  final String serialNumber;
  final String machineCode;
  final String location;
  final MachineStatus status;
  final int? repairTicketId;
  final List<int> machineIssues;

  MachineDetail({
    required this.id,
    required this.khmerName,
    required this.chineseName,
    required this.englishName,
    required this.brand,
    required this.serialNumber,
    required this.machineCode,
    required this.location,
    required this.status,
    this.repairTicketId,
    required this.machineIssues,
  });

  factory MachineDetail.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing MachineDetail from JSON: $json');
      
      // Handle status
      String statusStr = json['machineStatus']?.toString().toUpperCase() ?? 'OK';
      print('Status string: $statusStr');
      
      // Handle machine issues
      List<int> issues = [];
      if (json['machineIssue'] != null) {
        if (json['machineIssue'] is List) {
          issues = (json['machineIssue'] as List)
              .map((e) => int.parse(e.toString()))
              .toList();
        }
      }
      print('Machine issues: $issues');

      return MachineDetail(
        id: int.parse(json['id']?.toString() ?? '0'),
        khmerName: json['khName']?.toString() ?? '',
        chineseName: json['chnName']?.toString() ?? '',
        englishName: json['engName']?.toString() ?? '',
        brand: json['brand']?.toString() ?? '',
        serialNumber: json['serialNo']?.toString() ?? '',
        machineCode: json['machineCode']?.toString() ?? '',
        location: json['currentLocation']?.toString() ?? '',
        status: MachineStatus.values.firstWhere(
          (e) => e.toString().split('.').last == statusStr,
          orElse: () => MachineStatus.OK,
        ),
        repairTicketId: json['repairTicketId'] != null 
            ? int.parse(json['repairTicketId'].toString())
            : null,
        machineIssues: issues,
      );
    } catch (e, stackTrace) {
      print('Error parsing MachineDetail: $e');
      print('Stack trace: $stackTrace');
      print('JSON data: $json');
      rethrow;
    }
  }

  @override
  String toString() {
    return 'MachineDetail(id: $id, machineCode: $machineCode, status: $status, repairTicketId: $repairTicketId)';
  }
}

// Repair Report Models
class InitialRepairRequest {
  final List<int> reportProblems;
  final String? reportDescription;

  InitialRepairRequest({
    required this.reportProblems,
    this.reportDescription,
  });

  Map<String, dynamic> toJson() => {
        'reportProblems': reportProblems,
        if (reportDescription != null) 'reportDescription': reportDescription,
      };
}

class BeginRepairRequest {
  final int repairTicketId;

  BeginRepairRequest({required this.repairTicketId});

  Map<String, dynamic> toJson() => {
        'repairTicketId': repairTicketId,
      };
}

class FinalRepairRequest {
  final int repairTicketId;
  final String oilCondition;
  final String motorCondition;
  final String machineEfficiency;
  final List<int> problemsFound;
  final String? problemsFoundDescription;
  final List<String> pictures;

  FinalRepairRequest({
    required this.repairTicketId,
    required this.oilCondition,
    required this.motorCondition,
    required this.machineEfficiency,
    required this.problemsFound,
    this.problemsFoundDescription,
    required this.pictures,
  });

  Map<String, String> toFormData() {
    final map = {
      'repairTicketId': repairTicketId.toString(),
      'oilCondition': oilCondition,
      'motorCondition': motorCondition,
      'machineEfficiency': machineEfficiency,
    };

    if (problemsFoundDescription != null) {
      map['problemsFoundDescription'] = problemsFoundDescription!;
    }

    // Add problems found array
    for (var i = 0; i < problemsFound.length; i++) {
      map['problemsFound[$i]'] = problemsFound[i].toString();
    }

    return map;
  }
}

// Common Response Models
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) =>
      ApiResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] != null ? fromJson(json['data']) : null,
      );
}
