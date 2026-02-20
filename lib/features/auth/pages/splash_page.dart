import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yorozuya/core/utils/color.dart';
import 'package:yorozuya/core/utils/primary_button.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Logo
              Image.asset('assets/icon/yoro.png', height: 140),
              const SizedBox(height: 32),

              // App Name
              const Text(
                'Yorozuya',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),

              // Tagline
              const Text(
                'Everything you need,\nin one place.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textDark,
                  height: 1.5,
                ),
              ),

              const Spacer(flex: 3),

              // Get Started Button
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  label: 'Get Started',
                  onPressed: () => context.go('/login'),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
