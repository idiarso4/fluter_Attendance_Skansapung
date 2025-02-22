import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:absensi_app/config/app_pages.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildActionCard(
          context,
          icon: Icons.camera_alt_rounded,
          title: 'Take Attendance',
          color: Colors.blue,
          onTap: () {
            Get.toNamed(Routes.attendance);
          },
        ),
        _buildActionCard(
          context,
          icon: Icons.history_rounded,
          title: 'History',
          color: Colors.green,
          onTap: () {
            Get.toNamed(Routes.history);
          },
        ),
        _buildActionCard(
          context,
          icon: Icons.settings_rounded,
          title: 'Settings',
          color: Colors.purple,
          onTap: () {
            Get.toNamed(Routes.settings);
          },
        ),
        _buildActionCard(
          context,
          icon: Icons.help_outline_rounded,
          title: 'Help',
          color: Colors.orange,
          onTap: () {
            Get.toNamed(Routes.help);
          },
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withAlpha(204), // 0.8 opacity
                color.withAlpha(153), // 0.6 opacity
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}