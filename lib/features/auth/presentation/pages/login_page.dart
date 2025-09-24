import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/auth_repository.dart';
import '../providers/auth_repository_provider.dart'; // 👈 new provider
import '../../presentation/providers/current_user_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final authRepo = ref.read(authRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading
                  ? null
                  : () async {
                      setState(() => _loading = true);

                      try {
                        final authRepo = ref.read(authRepositoryProvider);
                        final user = await authRepo.login(
                          _emailController.text,
                          _passwordController.text,
                        );

                        // ✅ Store the user globally → triggers redirect
                        ref.read(currentUserProvider.notifier).state = user;
                      } catch (e) {
                        setState(() => _error = 'Login failed: $e');
                      } finally {
                        setState(() => _loading = false);
                      }
                    },
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
