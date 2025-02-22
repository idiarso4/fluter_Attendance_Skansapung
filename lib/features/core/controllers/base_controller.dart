import 'package:get/get.dart';

class BaseController extends GetxController {
  final _isLoading = false.obs;
  final _error = RxString('');

  bool get isLoading => _isLoading.value;
  String get error => _error.value;

  void setLoading(bool value) {
    _isLoading.value = value;
  }

  void setError(String message) {
    _error.value = message;
  }

  void clearError() {
    _error.value = '';
  }

  Future<void> handleError(dynamic error) async {
    setError(error.toString());
    await Future.delayed(const Duration(seconds: 3));
    clearError();
  }
}