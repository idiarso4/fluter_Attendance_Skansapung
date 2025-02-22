import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../attendance/presentation/screens/attendance_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final int _selectedIndex = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _quickActions = [
    {
      'title': 'Absen Masuk',
      'icon': Icons.login,
      'color': Colors.green,
    },
    {
      'title': 'Absen Pulang',
      'icon': Icons.logout,
      'color': Colors.red,
    },
    {
      'title': 'Izin',
      'icon': Icons.note_alt,
      'color': Colors.orange,
    },
    {
      'title': 'Riwayat',
      'icon': Icons.history,
      'color': Colors.blue,
    },
  ];

  void _navigateToScreen(int index) {
    Widget targetScreen;
    switch (index) {
      case 0:
        targetScreen = const AttendanceScreen();
        break;
      default:
        targetScreen = const AttendanceScreen(); // Placeholder for other screens
    }
    Get.to(() => targetScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: FadeTransition(
          opacity: _animation,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick Actions Grid
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    children: List.generate(_quickActions.length, (index) {
                      final action = _quickActions[index];
                      return Hero(
                        tag: 'quickAction$index',
                        child: Card(
                          elevation: 2,
                          child: InkWell(
                            onTap: () => _navigateToScreen(index),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  action['icon'] as IconData,
                                  size: 40,
                                  color: action['color'] as Color,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  action['title'] as String,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}