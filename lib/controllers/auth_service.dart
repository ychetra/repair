import 'package:get/get.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();
  
  final _isLoggedIn = false.obs;
  final _token = RxString('');
  
  bool get isLoggedIn => _isLoggedIn.value;
  String get token => _token.value;

  Future<bool> login(String username, String password) async {
    try {
      // TODO: Implement actual API login
      // For now, just accept any login
      const mockToken = 'mock_token';
      _token.value = mockToken;
      _isLoggedIn.value = true;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    _token.value = '';
    _isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }
}