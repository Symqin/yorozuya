import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yorozuya/core/utils/color.dart'; // Pastikan import warna
import '../cubit/navigation_cubit.dart';

// Import halaman-halaman fitur
import 'package:yorozuya/features/home/home_page.dart';
import 'package:yorozuya/features/cart/pages/cart_page.dart';
import 'package:yorozuya/features/transaction/pages/history_page.dart';
import 'package:yorozuya/features/profile//profile_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Pastikan urutan halaman sesuai urutan icon di bawah
    final List<Widget> pages = [
      const HomePage(),
      const HistoryPage(),
      const ProfilePage(),
    ];

    return BlocBuilder<NavigationCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          // Menjaga state halaman agar tidak reload saat pindah tab
          body: IndexedStack(index: currentIndex, children: pages),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) {
                context.read<NavigationCubit>().setIndex(index);
              },
              backgroundColor: Colors.white,
              // WAJIB: Agar icon tidak hilang/putih karena item > 3
              type: BottomNavigationBarType.fixed,

              selectedItemColor: AppColors.primary, // Hijau (Sesuai tema)
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: true,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled),
                  label: 'Beranda',
                ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt_long),
                  label: 'Transaksi',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profil',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
