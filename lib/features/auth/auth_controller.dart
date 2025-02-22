import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository repository;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final errorMessage = RxString('');

  AuthController({required this.repository});

  Future<void> login() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await repository.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (response['success'] == true && response['data'] != null) {
        final token = response['data']['token'];
        final user = response['data']['user'];
        // Store token and user data securely
        final storage = GetStorage();
        await storage.write('token', token);
        await storage.write('user', user);
        Get.offAllNamed('/home');
      } else {
        errorMessage.value = 'Invalid credentials';
      }
    } catch (e) {
      errorMessage.value = 'Login failed. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}