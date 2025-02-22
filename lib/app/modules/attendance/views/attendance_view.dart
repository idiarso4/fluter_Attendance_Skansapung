import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/attendance_controller.dart';
import 'package:intl/intl.dart';

class AttendanceView extends GetView<AttendanceController> {
  const AttendanceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Absensi'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status Card
              _buildStatusCard(context),
              const SizedBox(height: 24),

              // Camera Preview or Selected Image
              _buildImageSection(),
              const SizedBox(height: 16),

              // Notes TextField
              TextField(
                decoration: InputDecoration(
                  labelText: 'Catatan (opsional)',
                  hintText: 'Tambahkan catatan...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
                onChanged: (value) => controller.notes.value = value,
              ),
              const SizedBox(height: 24),

              // Submit Buttons
              _buildSubmitButtons(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status Absensi Hari Ini',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildAttendanceStatus(
              'Check In',
              controller.checkIn.value,
              context,
            ),
            const Divider(height: 24),
            _buildAttendanceStatus(
              'Check Out',
              controller.checkOut.value,
              context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceStatus(
    String type,
    dynamic attendance,
    BuildContext context,
  ) {
    final hasAttendance = attendance != null;
    final timeFormat = DateFormat('HH:mm');

    return Row(
      children: [
        Icon(
          hasAttendance ? Icons.check_circle : Icons.schedule,
          color: hasAttendance ? Colors.green : Colors.grey,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              if (hasAttendance)
                Text(
                  timeFormat.format(attendance.timestamp),
                  style: const TextStyle(color: Colors.grey),
                )
              else
                const Text(
                  'Belum absen',
                  style: TextStyle(color: Colors.grey),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: controller.selectedImage.value != null
              ? Image.file(
                  controller.selectedImage.value!,
                  fit: BoxFit.cover,
                )
              : InkWell(
                  onTap: controller.takePhoto,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.camera_alt,
                        size: 48,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Ambil Foto',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildSubmitButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: controller.checkIn.value != null
                ? null
                : () => controller.submitAttendance('check-in'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Check In'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: controller.checkOut.value != null ||
                    controller.checkIn.value == null
                ? null
                : () => controller.submitAttendance('check-out'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Check Out'),
          ),
        ),
      ],
    );
  }
}
