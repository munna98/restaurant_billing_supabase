import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/utils/validators.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).userModel;
    _nameController.text = user?.name ?? '';
    _phoneController.text = user?.phoneNumber ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).userModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
              const SizedBox(height: 20),
              Text(
                user?.name ?? '',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                user?.email ?? '',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              Text(
                'Role: ${user?.role.toString().split('.').last ?? ''}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              CustomTextField(
                label: 'Full Name',
                controller: _nameController,
                validator: Validators.validateName,
                prefixIcon: Icons.person,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Phone Number',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: Validators.validatePhone,
                prefixIcon: Icons.phone,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Email',
                controller: TextEditingController(text: user?.email ?? ''),
                enabled: false,
                prefixIcon: Icons.email,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Role',
                controller: TextEditingController(
                  text: user?.role.toString().split('.').last ?? '',
                ),
                enabled: false,
                prefixIcon: Icons.work,
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: 'UPDATE PROFILE',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Update profile
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully'),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'CHANGE PASSWORD',
                onPressed: () {
                  // TODO: Change password
                },
                backgroundColor: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}