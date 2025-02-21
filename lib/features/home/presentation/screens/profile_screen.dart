import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit profile screen
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 3,
                      ),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/profile.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // User Info
            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Software Engineer',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            // Profile Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                child: Column(
                  children: [
                    _buildProfileItem(
                      icon: Icons.badge,
                      title: 'ID Karyawan',
                      value: 'EMP001',
                    ),
                    const Divider(),
                    _buildProfileItem(
                      icon: Icons.email,
                      title: 'Email',
                      value: 'john.doe@company.com',
                    ),
                    const Divider(),
                    _buildProfileItem(
                      icon: Icons.phone,
                      title: 'No. Telepon',
                      value: '+62 812-3456-7890',
                    ),
                    const Divider(),
                    _buildProfileItem(
                      icon: Icons.location_on,
                      title: 'Alamat',
                      value: 'Jl. Sudirman No. 123, Jakarta',
                    ),
                    const Divider(),
                    _buildProfileItem(
                      icon: Icons.business,
                      title: 'Departemen',
                      value: 'Technology',
                    ),
                    const Divider(),
                    _buildProfileItem(
                      icon: Icons.calendar_today,
                      title: 'Tanggal Bergabung',
                      value: '1 Januari 2023',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Settings Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.lock),
                      title: const Text('Ubah Password'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // TODO: Navigate to change password screen
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.notifications),
                      title: const Text('Notifikasi'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // TODO: Navigate to notification settings
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.help),
                      title: const Text('Bantuan'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // TODO: Navigate to help center
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement logout functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Keluar'),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}