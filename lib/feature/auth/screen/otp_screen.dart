import 'package:flutter/material.dart';

import '../../../core/enums/user_role.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button_widget.dart';
import '../../driver/driver_registration_screen.dart';
import '../../home/client_shell.dart';
import '../../home/driver_shell.dart';
import '../widget/otp_box_widgets.dart';

class OtpScreen extends StatefulWidget {
  final UserRole role;
  final String phone;
  final bool isRegister;

  const OtpScreen({
    super.key,
    required this.role,
    required this.phone,
    required this.isRegister,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const _len = 6;
  final List<TextEditingController> _controllers =
  List.generate(_len, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(_len, (_) => FocusNode());

  String get _code => _controllers.map((c) => c.text).join();
  bool get _complete => _code.length == _len;

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _onChanged(int i, String value) {
    if (value.isNotEmpty && i < _len - 1) {
      _nodes[i + 1].requestFocus();
    } else if (value.isEmpty && i > 0) {
      _nodes[i - 1].requestFocus();
    }
    setState(() {});
  }

  void _verify() {
    final Widget next;
    if (widget.role.isDriver) {
      next = widget.isRegister
          ? const DriverRegistrationScreen()
          : const DriverShell();
    } else {
      next = const ClientShell();
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => next),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Подтверждение')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  color: AppColors.whatsapp.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/icons/whatsapp.png', // Локальный ассет вместо системной иконки
                    width: 32,
                    height: 32,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Введите код из WhatsApp', style: AppTextStyles.h1),
              const SizedBox(height: 8),
              Text(
                'Мы отправили 6-значный код на номер\n${widget.phone}',
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_len, (i) => OtpBoxWidget(
                  controller: _controllers[i],
                  node: _nodes[i],
                  onChanged: (v) => _onChanged(i, v),
                )),
              ),
              const SizedBox(height: 28),
              AppButton(
                label: 'Подтвердить',
                onPressed: _complete ? _verify : null,
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary, // Фирменный цвет
                  ),
                  child: const Text('Отправить код повторно'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
