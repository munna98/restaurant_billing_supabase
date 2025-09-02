// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _isSignUp = false;
//   final _nameController = TextEditingController();
//   String _selectedRole = 'waiter';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const FlutterLogo(size: 100),
//               const SizedBox(height: 32),
//               const Text(
//                 'Restaurant Billing App',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 32),
              
//               if (_isSignUp) ...[
//                 TextFormField(
//                   controller: _nameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Full Name',
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.person),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your name';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 DropdownButtonFormField<String>(
//                   value: _selectedRole,
//                   decoration: const InputDecoration(
//                     labelText: 'Role',
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.work),
//                   ),
//                   items: const [
//                     DropdownMenuItem(value: 'admin', child: Text('Admin')),
//                     DropdownMenuItem(value: 'cashier', child: Text('Cashier')),
//                     DropdownMenuItem(value: 'chef', child: Text('Chef')),
//                     DropdownMenuItem(value: 'waiter', child: Text('Waiter')),
//                   ],
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedRole = value!;
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 16),
//               ],
              
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.email),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your email';
//                   }
//                   if (!value.contains('@')) {
//                     return 'Please enter a valid email';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: const InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.lock),
//                 ),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your password';
//                   }
//                   if (value.length < 6) {
//                     return 'Password must be at least 6 characters';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 24),
              
//               Consumer<AuthProvider>(
//                 builder: (context, authProvider, child) {
//                   if (authProvider.error != null) {
//                     WidgetsBinding.instance.addPostFrameCallback((_) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(authProvider.error!),
//                           backgroundColor: Colors.red,
//                         ),
//                       );
//                       authProvider._error = null;
//                     });
//                   }
                  
//                   if (authProvider.isLoading) {
//                     return const CircularProgressIndicator();
//                   }
                  
//                   return Column(
//                     children: [
//                       SizedBox(
//                         width: double.infinity,
//                         height: 50,
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             if (_formKey.currentState!.validate()) {
//                               if (_isSignUp) {
//                                 final success = await authProvider.signUp(
//                                   _emailController.text,
//                                   _passwordController.text,
//                                   _nameController.text,
//                                   _selectedRole == 'admin' ? UserRole.admin :
//                                   _selectedRole == 'cashier' ? UserRole.cashier :
//                                   _selectedRole == 'chef' ? UserRole.chef :
//                                   UserRole.waiter,
//                                 );
                                
//                                 if (!success && context.mounted) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text('Sign up failed. Please try again.'),
//                                     ),
//                                   );
//                                 }
//                               } else {
//                                 final success = await authProvider.signIn(
//                                   _emailController.text,
//                                   _passwordController.text,
//                                 );
                                
//                                 if (!success && context.mounted) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text('Login failed. Please check your credentials.'),
//                                     ),
//                                   );
//                                 }
//                               }
//                             }
//                           },
//                           child: Text(_isSignUp ? 'SIGN UP' : 'LOGIN'),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       TextButton(
//                         onPressed: () {
//                           setState(() {
//                             _isSignUp = !_isSignUp;
//                           });
//                         },
//                         child: Text(_isSignUp
//                             ? 'Already have an account? Login'
//                             : 'Don\'t have an account? Sign up'),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSignUp = false;
  final _nameController = TextEditingController();
  String _selectedRole = 'waiter';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FlutterLogo(size: 100),
              const SizedBox(height: 32),
              const Text(
                'Restaurant Billing App',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              
              if (_isSignUp) ...[
                CustomTextField(
                  label: 'Full Name',
                  controller: _nameController,
                  validator: Validators.validateName,
                  prefixIcon: Icons.person,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.work),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'admin', child: Text('Admin')),
                    DropdownMenuItem(value: 'cashier', child: Text('Cashier')),
                    DropdownMenuItem(value: 'chef', child: Text('Chef')),
                    DropdownMenuItem(value: 'waiter', child: Text('Waiter')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
              ],
              
              CustomTextField(
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
                prefixIcon: Icons.email,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Password',
                controller: _passwordController,
                obscureText: true,
                validator: Validators.validatePassword,
                prefixIcon: Icons.lock,
              ),
              const SizedBox(height: 24),
              
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  if (authProvider.error != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(authProvider.error!),
                          backgroundColor: Colors.red,
                        ),
                      );
                    });
                  }
                  
                  return Column(
                    children: [
                      CustomButton(
                        text: _isSignUp ? 'SIGN UP' : 'LOGIN',
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (_isSignUp) {
                              final success = await authProvider.signUp(
                                _emailController.text,
                                _passwordController.text,
                                _nameController.text,
                                _selectedRole == 'admin' ? UserRole.admin :
                                _selectedRole == 'cashier' ? UserRole.cashier :
                                _selectedRole == 'chef' ? UserRole.chef :
                                UserRole.waiter,
                              );
                              
                              if (!success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Sign up failed. Please try again.'),
                                  ),
                                );
                              }
                            } else {
                              final success = await authProvider.signIn(
                                _emailController.text,
                                _passwordController.text,
                              );
                              
                              if (!success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Login failed. Please check your credentials.'),
                                  ),
                                );
                              }
                            }
                          }
                        },
                        isLoading: authProvider.isLoading,
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isSignUp = !_isSignUp;
                          });
                        },
                        child: Text(_isSignUp
                            ? 'Already have an account? Login'
                            : 'Don\'t have an account? Sign up'),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}