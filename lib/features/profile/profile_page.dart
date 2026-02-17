import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yorozuya/core/utils/color.dart';
import 'package:yorozuya/core/utils/menu_tile.dart';
import 'package:yorozuya/core/utils/section_title.dart';
import 'package:yorozuya/features/auth/cubit/auth_cubit.dart';
import 'package:yorozuya/features/auth/cubit/auth_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    String uid = "";
    String email = "Pengunjung";

    if (authState is AuthSuccess && authState.user.email != null) {
      uid = authState.user.uid;
      email = authState.user.email!;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Profil Saya",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textDark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<DocumentSnapshot>(
          stream: uid.isNotEmpty
              ? FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .snapshots()
              : null,
          builder: (context, snapshot) {
            // Ambil nama dari Firestore, fallback ke email prefix
            String displayName = email.split('@')[0];
            if (snapshot.hasData && snapshot.data!.exists) {
              final data = snapshot.data!.data() as Map<String, dynamic>?;
              if (data != null && data['displayName'] != null) {
                displayName = data['displayName'];
              }
            }
            final name =
                displayName[0].toUpperCase() + displayName.substring(1);

            return Column(
              children: [
                // ── HEADER PROFILE ──
                Center(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(
                            "https://i.pravatar.cc/300",
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(email, style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── MEMBERSHIP CARD ──
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFF81C784)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Yorozuya Member",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Gold Tier",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.star, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ── MENU AKUN ──
                const SectionTitle(title: "Akun"),
                MenuTile(
                  icon: Icons.person_outline,
                  title: "Edit Nama",
                  onTap: () => _showEditNameDialog(context, displayName),
                ),

                const SizedBox(height: 20),

                // ── TENTANG APLIKASI ──
                const SectionTitle(title: "Tentang"),
                MenuTile(
                  icon: Icons.info_outline,
                  title: "Tentang Aplikasi",
                  onTap: () => _showAboutAppSheet(context),
                ),

                const SizedBox(height: 30),

                // ── LOGOUT ──
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[50],
                      foregroundColor: Colors.red,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.red.withOpacity(0.2)),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text("Logout"),
                          content: const Text(
                            "Yakin ingin keluar dari aplikasi?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: const Text(
                                "Batal",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(dialogContext);
                                await context.read<AuthCubit>().logout();
                                if (context.mounted) {
                                  context.go('/login');
                                }
                              },
                              child: const Text(
                                "Ya, Keluar",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text("Keluar Aplikasi"),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Versi Aplikasi 1.0.0",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ── EDIT NAMA DIALOG ──
  void _showEditNameDialog(BuildContext context, String currentName) {
    final controller = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Edit Nama",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: "Nama",
            labelStyle: const TextStyle(color: AppColors.textDark),
            floatingLabelStyle: const TextStyle(color: AppColors.primary),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isEmpty) return;
              Navigator.pop(dialogContext);
              await context.read<AuthCubit>().updateDisplayName(newName);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: AppColors.primary,
                    content: Text("Nama berhasil diperbarui!"),
                  ),
                );
              }
            },
            child: const Text(
              "Simpan",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── TENTANG APLIKASI BOTTOM SHEET ──
  void _showAboutAppSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // App icon & nama
            Image.asset('assets/icon/yoro.png', height: 60),
            const SizedBox(height: 12),
            const Text(
              "Yorozuya",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Versi 1.0.0",
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
            const SizedBox(height: 16),
            Text(
              "Aplikasi e-commerce sederhana yang dibuat dengan Flutter dan Firebase. "
              "Proyek ini dibuat untuk belajar dan eksplorasi teknologi mobile development.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Hubungi Developer",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Social links
            _SocialLinkTile(
              icon: Icons.code,
              label: "GitHub",
              subtitle: "Symqin",
              url: "https://github.com/Symqin",
            ),
            _SocialLinkTile(
              icon: Icons.camera_alt_outlined,
              label: "Instagram",
              subtitle: "@symqin_",
              url: "https://www.instagram.com/symqin_/",
            ),
            _SocialLinkTile(
              icon: Icons.work_outline,
              label: "LinkedIn",
              subtitle: "Syahril Mutaqin",
              url: "https://www.linkedin.com/in/syahril-mutaqin/",
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/// Widget link sosial media dengan ikon dan subtitle.
class _SocialLinkTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final String url;

  const _SocialLinkTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.url,
  });

  Future<void> _openUrl() async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: _openUrl,
        dense: true,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
        trailing: Icon(Icons.open_in_new, color: Colors.grey[400], size: 16),
      ),
    );
  }
}
