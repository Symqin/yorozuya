import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yorozuya/features/auth/cubit/auth_cubit.dart';
import 'package:yorozuya/features/auth/cubit/auth_state.dart';
import 'package:yorozuya/core/utils/customtexfield.dart';
import 'package:yorozuya/core/utils/color.dart'; // Pastikan import ini benar

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
            Navigator.pushReplacementNamed(context, '/home');
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
                          // Validator sederhana (opsional)
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
                            if (state is AuthLoading) {
                              return const CircularProgressIndicator(
                                color: AppColors.primary,
                              );
                            }
                            return SizedBox(
                              height: 52,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor:
                                      AppColors.primary, // Tombol Hijau
                                  elevation: 2,
                                ),
                                onPressed: () {
                                  if (_emailController.text.isEmpty ||
                                      _passwordController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: AppColors
                                            .primary, // SnackBar warna Oranye
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
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 30),

                        // UBAH: Divider menggunakan warna Secondary (Kayu Muda)
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

                        // UBAH: Tombol Google jadi clean (Border Kayu, Teks Hitam)
                        ElevatedButton(
                          onPressed: () =>
                              context.read<AuthCubit>().signInWithGoogle(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor:
                                AppColors.textDark, // Efek splash saat diklik
                            elevation: 0,
                            fixedSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(
                                color: AppColors.secondary,
                              ), // Border warna kayu
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Sebaiknya pakai Image.asset('assets/google_logo.png') jika ada
                              // Tapi pakai Icon sementara tidak apa-apa
                              const Icon(
                                Icons.g_mobiledata,
                                size: 30,
                                color: AppColors.textDark,
                              ),
                              const SizedBox(width: 8),
                              const Text(
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
                              onTap: () =>
                                  Navigator.pushNamed(context, '/register'),
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                  color: AppColors
                                      .accent, // Warna Oranye agar menarik perhatian
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
