import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porsche_ebike_code_challenge/bike_dashboard/view/bike_dashboard_screen.dart';

import '../state/user_login_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  UserAuthenticationScreenState createState() => UserAuthenticationScreenState();
}

class UserAuthenticationScreenState extends ConsumerState<LoginScreen> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();
      ref.read(userAuthProvider.notifier).authenticateUser(username, password);
    }
  }


  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final authState = ref.watch(userAuthProvider);
    final isObscure = ref.watch(obscurePasswordProvider);

    ref.listen<AsyncValue<String?>>(
      userAuthProvider, (previous, next) {
        next.whenOrNull(data: (_) {
            _usernameController.clear();
            _passwordController.clear();
            ScaffoldMessenger.of(context).clearSnackBars();

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => BikeDashboardScreen()),
            );
          },
          error: (err, _) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(err.toString())),
            );
          },
        );
      },
    );



    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "User Authentication:",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 26),
                        // Username Field
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: "Username",
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (value) => value!.isEmpty ? "Please enter your username" : null,
                        ),
                        const SizedBox(height: 15),
                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: isObscure,
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility, color: Theme.of(context).colorScheme.primary),
                              onPressed: () {
                                ref.read(obscurePasswordProvider.notifier).state = !isObscure;
                              },
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (value) => value!.length < 6 ? "Password must be at least 6 characters" : null,
                        ),
                        const SizedBox(height: 20),
                        // Login Button
                        authState.isLoading
                            ? CircularProgressIndicator(color: Theme.of(context).colorScheme.primary)
                            : ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text("Login", style: TextStyle(fontSize: 16)),
                        ),
                        const SizedBox(height: 10),
                        // Forgot Password
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}