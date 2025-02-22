import 'package:get/get.dart';
import '../modules/login/views/login_view.dart';
import '../modules/login/controllers/login_controller.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/dashboard/controllers/dashboard_controller.dart';
import '../modules/attendance/views/attendance_view.dart';
import '../modules/attendance/controllers/attendance_controller.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<LoginController>(() => LoginController());
      }),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<DashboardController>(() => DashboardController());
      }),
    ),
    GetPage(
      name: _Paths.ATTENDANCE,
      page: () => const AttendanceView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AttendanceController>(() => AttendanceController());
      }),
    ),
  ];
}
