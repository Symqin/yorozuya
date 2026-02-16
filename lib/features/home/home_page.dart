import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yorozuya/core/utils/color.dart';
import 'package:yorozuya/features/auth/cubit/auth_cubit.dart';
import 'package:yorozuya/features/auth/cubit/auth_state.dart';
import 'package:yorozuya/features/cart/cubit/cart_cubit.dart';
import 'package:yorozuya/features/cart/cubit/cart_state.dart';
import 'package:yorozuya/features/product/cubit/product_cubit.dart';
import 'package:yorozuya/features/product/cubit/product_state.dart';
import 'package:yorozuya/features/product/pages/product_detail_page.dart';
import 'package:yorozuya/core/utils/product_card.dart';
import 'package:yorozuya/core/utils/category_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().fetchProducts();
    // Load keranjang buat update badge
    final user = context.read<AuthCubit>().state;
    if (user is AuthSuccess) context.read<CartCubit>().loadCart(user.user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => context.read<ProductCubit>().fetchProducts(),
          color: AppColors.primary,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildSearchBar(
                context,
              ), // Tambahkan context untuk navigasi/snackbar
              const SizedBox(height: 24),
              _buildPromoBanner(),
              const SizedBox(height: 30),
              _buildCategories(context), // Tambahkan context
              const SizedBox(height: 30),
              _buildSectionTitle(
                context,
                "Pilihan Yorozuya",
              ), // Tambahkan context
              const SizedBox(height: 16),
              _buildProductGrid(),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET PECAHAN BIAR RAPI ---

  Widget _buildHeader(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    String name = (authState is AuthSuccess)
        ? authState.user.email!.split('@')[0]
        : 'Tamu';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Halo, selamat belanja!",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Text(
              name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        // Tombol Keranjang dengan Badge
        BlocBuilder<CartCubit, CartState>(
          builder: (context, state) => Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.textDark,
                ),
                onPressed: () => Navigator.pushNamed(context, '/cart'),
              ),
              if (state.items.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${state.items.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 8),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return GestureDetector(
      // Biar search bar bisa dipencet
      onTap: () {
        // TODO: Arahkan ke halaman Search beneran nanti
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Fitur pencarian segera hadir!")),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 12),
            Text("Cari barang...", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF81C784)],
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
      child: const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Diskon 50%",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "Khusus pengguna baru.",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(Icons.local_offer_outlined, color: Colors.white, size: 36),
        ],
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    // Data kategori simpel aja
    final categories = [
      {'icon': Icons.grid_view_rounded, 'label': 'Semua'},
      {'icon': Icons.smartphone_rounded, 'label': 'Gadget'},
      {'icon': Icons.checkroom_rounded, 'label': 'Fashion'},
      {'icon': Icons.laptop_mac_rounded, 'label': 'Laptop'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories
          .map(
            (cat) => CategoryItem(
              icon: cat['icon'] as IconData,
              label: cat['label'] as String,
              onTap: () {
                // Contoh: Navigasi ke halaman produk (atau filter kategori nanti)
                Navigator.pushNamed(context, '/products');

                // Atau tampilkan snackbar feedback
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Kategori: ${cat['label']}")));
              },
            ),
          )
          .toList(),
    );
  }

  Widget _buildProductGrid() {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading)
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        if (state is ProductLoaded) {
          // Batasi 4 produk aja di home biar ga kepanjangan
          final displayProducts = state.products.take(4).toList();

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.72,
            ),
            itemCount: displayProducts.length,
            itemBuilder: (ctx, i) => ProductCard(
              product: displayProducts[i],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ProductDetailPage(product: displayProducts[i]),
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        // Tombol Lihat Semua
        InkWell(
          onTap: () {
            // Arahkan ke halaman semua produk
            Navigator.pushNamed(context, '/products');
          },
          child: const Padding(
            // Padding biar area sentuh lebih luas
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Lihat Semua",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
