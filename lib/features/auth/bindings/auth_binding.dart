import 'package:get/get.dart';
import '../presentation/controllers/auth_controller.dart';
import '../services/auth_service.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthService());
    Get.lazyPut(() => AuthController());
  }
}