import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import '../models/api_models.dart';
import 'auth_service.dart';

enum MachineStatus {
  OK,
  WAITING_REPAIR,
  UNDER_REPAIR
}

class RepairService extends GetxController {
  final String baseUrl = 'http://192.167.1.18:7000/api';
  final AuthService _authService;

  RepairService(this._authService);

  Map<String, String> get _headers => {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${_authService.token}',
  };

  Map<String, String> get _authHeaders => {
    'Accept': 'application/json',
    'Authorization': 'Bearer ${_authService.token}',
  };

  // Get machine details and status
  Future<MachineDetail> getMachineDetails(String machineCode) async {
    if (_authService.token == null) {
      throw Exception('Not authenticated');
    }

    final url = '$baseUrl/machineDetail/$machineCode';
    print('Fetching machine details from: $url');
    print('Headers: $_authHeaders');
    
    final response = await http.get(
      Uri.parse(url),
      headers: _authHeaders,
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print('Decoded JSON: $jsonResponse');
      
      // Check if the response is wrapped in a data field
      final data = jsonResponse is Map<String, dynamic> 
          ? (jsonResponse['data'] ?? jsonResponse)
          : jsonResponse;
          
      if (data != null) {
        return MachineDetail.fromJson(data);
      } else {
        throw Exception('Machine details not found in response');
      }
    } else if (response.statusCode == 401) {
      _authService.logout();
      throw Exception('Session expired. Please login again.');
    } else {
      throw Exception('Failed to get machine details: ${response.reasonPhrase}');
    }
  }

  // Stage 1: Submit initial repair report
  Future<ApiResponse> submitInitialReport(String machineCode, List<int> problems) async {
    if (_authService.token == null) {
      throw Exception('Not authenticated');
    }

    final url = '$baseUrl/repairs/$machineCode';
    final request = InitialRepairRequest(reportProblems: problems);

    final response = await http.post(
      Uri.parse(url),
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ApiResponse.fromJson(
        jsonResponse,
        (json) => json as Map<String, dynamic>,
      );
    } else if (response.statusCode == 401) {
      _authService.logout();
      throw Exception('Session expired. Please login again.');
    } else {
      throw Exception('Failed to submit initial report: ${response.reasonPhrase}');
    }
  }

  // Stage 2: Begin repair
  Future<ApiResponse> beginRepair(String machineCode, int repairTicketId) async {
    if (_authService.token == null) {
      throw Exception('Not authenticated');
    }

    final url = '$baseUrl/repairs/$machineCode';
    final request = BeginRepairRequest(repairTicketId: repairTicketId);

    final response = await http.post(
      Uri.parse(url),
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ApiResponse.fromJson(
        jsonResponse,
        (json) => json as Map<String, dynamic>,
      );
    } else if (response.statusCode == 401) {
      _authService.logout();
      throw Exception('Session expired. Please login again.');
    } else {
      throw Exception('Failed to begin repair: ${response.reasonPhrase}');
    }
  }

  // Stage 3: Submit final repair report
  Future<ApiResponse> submitFinalReport(
    String machineCode,
    FinalRepairRequest request,
    List<String> picturePaths,
  ) async {
    if (_authService.token == null) {
      throw Exception('Not authenticated');
    }

    final url = '$baseUrl/repairs/$machineCode';
    var multipartRequest = http.MultipartRequest('POST', Uri.parse(url))
      ..fields.addAll(request.toFormData());

    // Add authorization header
    multipartRequest.headers.addAll(_authHeaders);

    // Add pictures
    for (var i = 0; i < picturePaths.length; i++) {
      multipartRequest.files.add(
        await http.MultipartFile.fromPath('pictures[$i]', picturePaths[i]),
      );
    }

    final streamedResponse = await multipartRequest.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ApiResponse.fromJson(
        jsonResponse,
        (json) => json as Map<String, dynamic>,
      );
    } else if (response.statusCode == 401) {
      _authService.logout();
      throw Exception('Session expired. Please login again.');
    } else {
      throw Exception('Failed to submit final report: ${response.reasonPhrase}');
    }
  }
} 