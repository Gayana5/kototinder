class AuthValidator {
  const AuthValidator();

  String? validateEmail(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty) {
      return 'Введите email';
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(trimmed)) {
      return 'Некорректный email';
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Введите пароль';
    }
    if (password.length < 6) {
      return 'Пароль должен быть не короче 6 символов';
    }
    return null;
  }
}
