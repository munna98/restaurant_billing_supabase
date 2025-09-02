import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).userModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${user?.name ?? ''}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Role: ${user?.role.toString().split('.').last ?? ''}',
              style: const TextStyle(fontSize: 16, color: AppColors.grey),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                ),
                children: [
                  // POS System
                  if (user?.role == UserRole.admin || 
                      user?.role == UserRole.cashier ||
                      user?.role == UserRole.waiter)
                    _buildFeatureCard(
                      context,
                      title: 'POS System',
                      icon: Icons.point_of_sale,
                      color: AppColors.primary,
                      onTap: () {
                        Navigator.pushNamed(context, '/pos');
                      },
                    ),
                  
                  // Kitchen Display
                  if (user?.role == UserRole.admin || 
                      user?.role == UserRole.chef)
                    _buildFeatureCard(
                      context,
                      title: 'Kitchen Display',
                      icon: Icons.kitchen,
                      color: AppColors.secondary,
                      onTap: () {
                        Navigator.pushNamed(context, '/kds');
                      },
                    ),
                  
                  // Menu Management
                  if (user?.role == UserRole.admin)
                    _buildFeatureCard(
                      context,
                      title: 'Menu Management',
                      icon: Icons.restaurant_menu,
                      color: AppColors.accent,
                      onTap: () {
                        Navigator.pushNamed(context, '/menu-management');
                      },
                    ),
                  
                  // Reports
                  if (user?.role == UserRole.admin)
                    _buildFeatureCard(
                      context,
                      title: 'Reports',
                      icon: Icons.analytics,
                      color: AppColors.info,
                      onTap: () {
                        Navigator.pushNamed(context, '/reports');
                      },
                    ),
                  
                  // User Management
                  if (user?.role == UserRole.admin)
                    _buildFeatureCard(
                      context,
                      title: 'User Management',
                      icon: Icons.people,
                      color: AppColors.warning,
                      onTap: () {
                        Navigator.pushNamed(context, '/user-management');
                      },
                    ),
                  
                  // Audit Trail
                  if (user?.role == UserRole.admin)
                    _buildFeatureCard(
                      context,
                      title: 'Audit Trail',
                      icon: Icons.history,
                      color: AppColors.darkGrey,
                      onTap: () {
                        Navigator.pushNamed(context, '/audit-trail');
                      },
                    ),
                  
                  // Profile
                  _buildFeatureCard(
                    context,
                    title: 'Profile',
                    icon: Icons.person,
                    color: AppColors.success,
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
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