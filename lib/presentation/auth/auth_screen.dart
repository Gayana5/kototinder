import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/di/app_dependencies.dart';
import 'auth_controller.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.onAuthSuccess, this.controller});

  final Future<void> Function() onAuthSuccess;
  final AuthController? controller;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late final AuthController _controller;
  late final bool _ownsController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? _buildController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _loadSavedEmail();
  }

  AuthController _buildController() {
    final dependencies = context.read<AppDependencies>();
    return AuthController(
      signIn: dependencies.signIn,
      signUp: dependencies.signUp,
      authRepository: dependencies.authRepository,
    );
  }

  Future<void> _loadSavedEmail() async {
    await _controller.loadSavedEmail();
    if (_emailController.text.isEmpty && _controller.email.isNotEmpty) {
      _emailController.text = _controller.email;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: _AuthView(
        onAuthSuccess: widget.onAuthSuccess,
        emailController: _emailController,
        passwordController: _passwordController,
      ),
    );
  }
}

class _AuthView extends StatelessWidget {
  const _AuthView({
    required this.onAuthSuccess,
    required this.emailController,
    required this.passwordController,
  });

  final Future<void> Function() onAuthSuccess;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AuthController>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Добро пожаловать',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Войдите или создайте аккаунт, чтобы продолжить.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black54,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _ModeSwitcher(
                  mode: controller.mode,
                  onChanged: controller.setMode,
                ),
                const SizedBox(height: 24),
                TextField(
                  key: const ValueKey('auth.email'),
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.mail_outline),
                  ),
                  onChanged: controller.updateEmail,
                ),
                const SizedBox(height: 16),
                TextField(
                  key: const ValueKey('auth.password'),
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Пароль',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  onChanged: controller.updatePassword,
                ),
                const SizedBox(height: 16),
                if (controller.error != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      controller.error ?? '',
                      style: const TextStyle(color: Colors.redAccent),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  key: const ValueKey('auth.submit'),
                  onPressed: controller.isLoading
                      ? null
                      : () async {
                          final success = await controller.submit();
                          if (!context.mounted) {
                            return;
                          }
                          if (success) {
                            await onAuthSuccess();
                          }
                        },
                  child: controller.isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(controller.mode == AuthMode.signIn ? 'Войти' : 'Зарегистрироваться'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeSwitcher extends StatelessWidget {
  const _ModeSwitcher({required this.mode, required this.onChanged});

  final AuthMode mode;
  final ValueChanged<AuthMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<AuthMode>(
      segments: const [
        ButtonSegment(value: AuthMode.signIn, label: Text('Вход')),
        ButtonSegment(value: AuthMode.signUp, label: Text('Регистрация')),
      ],
      selected: {mode},
      onSelectionChanged: (value) => onChanged(value.first),
    );
  }
}
