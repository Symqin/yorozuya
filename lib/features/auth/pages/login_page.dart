import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yorozuya/features/auth/cubit/auth_cubit.dart';
import 'package:yorozuya/features/auth/cubit/auth_state.dart';
import 'package:yorozuya/core/utils/customtexfield.dart';
import 'package:yorozuya/core/utils/color.dart';
import 'package:yorozuya/core/utils/primary_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // GoRouter redirect otomatis menangani navigasi ke home
            context.go('/');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },

        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // JUDUL
                        const Text(
                          "Yorozuya",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // LOGO
                        Image.asset('assets/icon/yoro.png', height: 100),

                        const SizedBox(height: 30),

                        CustomTextFormField(
                          label: 'Email',
                          controller: _emailController,
                          validator: (value) => value!.isEmpty
                              ? "Email tidak boleh kosong"
                              : null,
                        ),
                        CustomTextFormField(
                          label: 'Password',
                          controller: _passwordController,
                          isPassword: true,
                          validator: (value) => value!.isEmpty
                              ? "Password tidak boleh kosong"
                              : null,
                        ),
                        const SizedBox(height: 20),

                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            return PrimaryButton(
                              label: "Login",
                              isLoading: state is AuthLoading,
                              onPressed: () {
                                if (_emailController.text.isEmpty ||
                                    _passwordController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: AppColors.primary,
                                      content: Text(
                                        "Email & password wajib diisi",
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                context.read<AuthCubit>().login(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 30),

                        const Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: AppColors.secondary,
                                thickness: 1.5,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                "Atau daftar menggunakan",
                                style: TextStyle(
                                  color: AppColors.textDark,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: AppColors.secondary,
                                thickness: 1.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        ElevatedButton(
                          onPressed: () =>
                              context.read<AuthCubit>().signInWithGoogle(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.textDark,
                            elevation: 0,
                            fixedSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.g_mobiledata,
                                size: 30,
                                color: AppColors.textDark,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Google",
                                style: TextStyle(
                                  color: AppColors.textDark,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Belum punya akun? ",
                              style: TextStyle(color: AppColors.textDark),
                            ),
                            GestureDetector(
                              onTap: () => context.push('/register'),
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
