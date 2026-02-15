import 'package:flutter/material.dart';
import 'color.dart'; // Pastikan import ini benar

class CustomTextFormField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscureText : false,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        cursorColor: AppColors.primary, // Kursor warna Hijau
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.textDark, // Teks input warna Abu Gelap
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: widget.label,
          // Warna label saat tidak fokus
          labelStyle: const TextStyle(color: AppColors.textDark),
          // Warna label saat fokus (jadi Hijau)
          floatingLabelStyle: const TextStyle(color: AppColors.primary),
          floatingLabelBehavior: FloatingLabelBehavior.auto,

          filled: true, // Mengaktifkan warna background kolom
          fillColor: Colors
              .white, // Background kolom putih bersih agar kontras dengan BG aplikasi
          // Icon password
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.textDark, // Warna icon mata
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),

          // Border Default (saat error/netral)
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.secondary),
          ),

          // Border saat tidak diklik (Enabled) - Warna Kayu Muda
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.secondary),
          ),

          // Border saat diklik (Focused) - Warna Hijau Sage
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
          ),

          // Border saat Error - Merah (atau bisa pakai AppColors.accent jika mau oranye)
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
