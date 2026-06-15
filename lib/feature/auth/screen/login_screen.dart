import 'package:flutter/material.dart';
import 'package:taxi_app/feature/auth/screen/register_screen.dart';

import '../../../core/enums/user_role.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button_widget.dart';
import '../widget/auth_promt_widgets.dart';
import '../widget/or_divider_widgets.dart';
import '../widget/phone_field_widget.dart';
import '../widget/social_button_widget.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  final UserRole role;
  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phone = TextEditingController();

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  void _continue() {
    if (_phone.text.trim().isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OtpScreen(
          role: widget.role,
          phone: '+7 940 ${_phone.text}',
          isRegister: false,
        ),
      ),
    );
  }

  void _toRegister() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => RegisterScreen(role: widget.role)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Вход · ${widget.role.titleRu}')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text('С возвращением 👋', style: AppTextStyles.h1),
              const SizedBox(height: 8),
              Text(
                'Введите номер телефона — пришлём код подтверждения в WhatsApp.',
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: 28),
              Text('Номер телефона', style: AppTextStyles.bodySecondary),
              const SizedBox(height: 8),
              PhoneField(controller: _phone),
              const SizedBox(height: 24),
              AppButton(
                label: 'Получить код',
                icon: Icons.chat_rounded,
                onPressed: _continue,
              ),
              const SizedBox(height: 24),
              const OrDivider(),
              const SizedBox(height: 24),
              SocialButton(
                label: 'Продолжить с Google',
                icon: Image.asset(
                  'assets/icons/google.png', // Локальный ассет логотипа
                  width: 24,
                  height: 24,
                ),
                onPressed: () {},
              ),
              const SizedBox(height: 12),
              SocialButton(
                label: 'Продолжить с Apple',
                icon: Image.asset(
                  'assets/icons/apple.png', // Локальный ассет логотипа
                  width: 24,
                  height: 24,
                ),
                onPressed: () {},
              ),
              const SizedBox(height: 24),
              Center(
                child: AuthPromptWidget(
                  text: 'Нет аккаунта?',
                  actionText: 'Регистрация',
                  onActionPressed: _toRegister,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
