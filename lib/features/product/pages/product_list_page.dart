import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yorozuya/core/utils/color.dart';
import 'package:yorozuya/core/utils/empty_state.dart';
import 'package:yorozuya/core/utils/product_card.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';
import '../models/product_model.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().fetchProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Semua Produk",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textDark,
      ),
      body: Column(
        children: [
          // ── SEARCH BAR ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: "Cari produk...",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.primary,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = "");
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),

          // ── PRODUCT GRID ──
          Expanded(
            child: BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (state is ProductError) {
                  return EmptyStateWidget(
                    icon: Icons.error_outline,
                    title: "Gagal memuat produk",
                    subtitle: state.message,
                    actionLabel: "Coba Lagi",
                    onAction: () =>
                        context.read<ProductCubit>().fetchProducts(),
                  );
                }

                if (state is ProductLoaded) {
                  // Filter berdasarkan search
                  final filtered = state.products.where((p) {
                    final query = _searchQuery.toLowerCase();
                    return p.title.toLowerCase().contains(query);
                  }).toList();

                  if (filtered.isEmpty) {
                    return EmptyStateWidget(
                      icon: _searchQuery.isNotEmpty
                          ? Icons.search_off
                          : Icons.inventory_2_outlined,
                      title: _searchQuery.isNotEmpty
                          ? "Produk tidak ditemukan"
                          : "Belum ada produk",
                      subtitle: _searchQuery.isNotEmpty
                          ? "Coba kata kunci lain"
                          : null,
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async =>
                        context.read<ProductCubit>().fetchProducts(),
                    color: AppColors.primary,
                    child: GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.7,
                          ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final ProductModel product = filtered[index];
                        return ProductCard(
                          product: product,
                          onTap: () => context.push(
                            '/products/${product.id}',
                            extra: product,
                          ),
                        );
                      },
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
