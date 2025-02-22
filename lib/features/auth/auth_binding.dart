import 'package:get/get.dart';
import 'auth_controller.dart';
import 'auth_repository.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthRepository());
    Get.lazyPut(() => AuthController(repository: Get.find<AuthRepository>()));
  }
}