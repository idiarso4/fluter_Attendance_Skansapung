import 'package:get/get.dart';
import 'package:absensi_app/features/auth/presentation/screens/login_screen.dart';
import 'package:absensi_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:absensi_app/features/home/presentation/screens/home_screen.dart';
import 'package:absensi_app/features/attendance/presentation/screens/attendance_screen.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.ATTENDANCE,
      page: () => const AttendanceScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}