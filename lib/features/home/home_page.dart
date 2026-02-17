import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yorozuya/core/utils/color.dart';
import 'package:yorozuya/core/utils/empty_state.dart';
import 'package:yorozuya/features/auth/cubit/auth_cubit.dart';
import 'package:yorozuya/features/auth/cubit/auth_state.dart';
import 'package:yorozuya/features/cart/cubit/cart_cubit.dart';
import 'package:yorozuya/features/cart/cubit/cart_state.dart';
import 'package:yorozuya/features/product/cubit/product_cubit.dart';
import 'package:yorozuya/features/product/cubit/product_state.dart';
import 'package:yorozuya/core/utils/product_card.dart';
import 'package:yorozuya/core/utils/category_item.dart';
import 'package:yorozuya/core/utils/section_title.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = "Semua";

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.grid_view_rounded, 'label': 'Semua'},
    {'icon': Icons.smartphone_rounded, 'label': 'Smartphones'},
    {'icon': Icons.laptop_mac_rounded, 'label': 'Laptops'},
    {'icon': Icons.checkroom_rounded, 'label': 'Tops'},
    {'icon': Icons.chair_outlined, 'label': 'Furniture'},
    {'icon': Icons.color_lens_outlined, 'label': 'Fragrances'},
    {'icon': Icons.shopping_bag_outlined, 'label': 'Groceries'},
  ];

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().fetchProducts();
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
              _buildSearchBar(),
              const SizedBox(height: 24),
              _buildPromoBanner(),
              const SizedBox(height: 30),
              _buildCategories(),
              const SizedBox(height: 30),
              SectionTitle(
                title: "Pilihan Yorozuya",
                actionLabel: "Lihat Semua",
                onAction: () => context.push('/products'),
              ),
              _buildProductGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  // ── HEADER ──
  Widget _buildHeader(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    String uid = "";
    String fallbackName = "Tamu";

    if (authState is AuthSuccess) {
      uid = authState.user.uid;
      if (authState.user.email != null) {
        fallbackName = authState.user.email!.split('@')[0];
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        uid.isNotEmpty
            ? StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  String name = fallbackName;
                  if (snapshot.hasData && snapshot.data!.exists) {
                    final data = snapshot.data!.data() as Map<String, dynamic>?;
                    if (data != null && data['displayName'] != null) {
                      name = data['displayName'];
                    }
                  }
                  name = name[0].toUpperCase() + name.substring(1);

                  return Column(
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
                  );
                },
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Halo, selamat belanja!",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    fallbackName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),

        // Cart badge
        BlocBuilder<CartCubit, CartState>(
          builder: (context, state) => Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.textDark,
                ),
                onPressed: () => context.push('/cart'),
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

  // ── SEARCH BAR → NAVIGASI KE LIST PRODUK ──
  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () => context.push('/products'),
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
            Icon(Icons.search, color: AppColors.primary),
            SizedBox(width: 12),
            Text("Cari barang...", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // ── PROMO BANNER ──
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

  // ── CATEGORIES (FUNGSIONAL FILTER) ──
  Widget _buildCategories() {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final label = cat['label'] as String;
          return CategoryItem(
            icon: cat['icon'] as IconData,
            label: label,
            isSelected: _selectedCategory == label,
            onTap: () => setState(() => _selectedCategory = label),
          );
        },
      ),
    );
  }

  // ── PRODUCT GRID (FILTERED BY CATEGORY) ──
  Widget _buildProductGrid(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (state is ProductLoaded) {
          var filtered = state.products;
          if (_selectedCategory != "Semua") {
            filtered = filtered
                .where(
                  (p) =>
                      p.category.toLowerCase() ==
                      _selectedCategory.toLowerCase(),
                )
                .toList();
          }

          final displayProducts = filtered.take(6).toList();

          if (displayProducts.isEmpty) {
            return const Padding(
              padding: EdgeInsets.only(top: 30),
              child: EmptyStateWidget(
                icon: Icons.inventory_2_outlined,
                title: "Tidak ada produk untuk kategori ini",
              ),
            );
          }

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
              onTap: () => context.push(
                '/products/${displayProducts[i].id}',
                extra: displayProducts[i],
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
