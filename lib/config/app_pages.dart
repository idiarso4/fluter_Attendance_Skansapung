import 'package:get/get.dart';
import 'package:absensi_app/features/auth/presentation/screens/login_screen.dart';
import 'package:absensi_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:absensi_app/features/home/presentation/screens/home_screen.dart';
import 'package:absensi_app/features/attendance/presentation/screens/attendance_screen.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.attendance,
      page: () => const AttendanceScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.history,
      page: () => const AttendanceScreen(), // Temporary placeholder
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.settings,
      page: () => const AttendanceScreen(), // Temporary placeholder
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.help,
      page: () => const AttendanceScreen(), // Temporary placeholder
      transition: Transition.rightToLeft,
    ),
  ];
}