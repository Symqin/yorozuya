import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yorozuya/features/auth/cubit/auth_cubit.dart';
import 'package:yorozuya/features/auth/cubit/auth_state.dart';
import 'package:yorozuya/core/utils/customtexfield.dart';
import 'package:yorozuya/core/utils/color.dart'; // Pastikan import ini ada

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _handleRegister() {
    // Validasi input kosong
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red, // Tetap merah untuk error
          content: Text("Semua kolom harus diisi"),
        ),
      );
      return;
    }

    // Validasi password tidak sama
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Password konfirmasi tidak sesuai"),
        ),
      );
      return;
    }

    context.read<AuthCubit>().register(
      _emailController.text,
      _passwordController.text,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Background Krem Hangat
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: AppColors.primary, // Hijau saat sukses
                content: Text("Registrasi Berhasil! Silahkan Login."),
              ),
            );
            Navigator.pop(context);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(state.message),
              ),
            );
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(
                    24.0,
                  ), // Padding konsisten dengan Login
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Buat Akun Baru",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // UBAH: Icon tambah orang dengan warna Primary
                        Image.asset('assets/icon/yoro.png', height: 100),

                        const SizedBox(height: 30),

                        CustomTextFormField(
                          label: "Email",
                          controller: _emailController,
                        ),
                        CustomTextFormField(
                          label: "Password",
                          controller: _passwordController,
                          isPassword: true,
                        ),
                        CustomTextFormField(
                          label: "Konfirmasi Password",
                          controller: _confirmPasswordController,
                          isPassword: true,
                        ),

                        const SizedBox(height: 10),

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
                                    // Radius disamakan dengan Login Page (12)
                                    // Kalau mau bulat pil seperti kode awalmu, ganti jadi 30
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor:
                                      AppColors.primary, // Hijau Sage
                                  elevation: 2,
                                ),
                                onPressed: _handleRegister,
                                child: const Text(
                                  "Daftar Sekarang",
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Sudah punya akun? ",
                              style: TextStyle(color: AppColors.textDark),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Text(
                                "Masuk",
                                style: TextStyle(
                                  color: AppColors.accent, // Oranye Persimmon
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
