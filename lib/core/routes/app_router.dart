import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Pages
import 'package:yorozuya/features/auth/pages/login_page.dart';
import 'package:yorozuya/features/auth/pages/register_page.dart';
import 'package:yorozuya/features/navigation/pages/main_page.dart';
import 'package:yorozuya/features/product/pages/product_list_page.dart';
import 'package:yorozuya/features/product/pages/product_detail_page.dart';
import 'package:yorozuya/features/product/models/product_model.dart';
import 'package:yorozuya/features/cart/pages/cart_page.dart';

/// Konfigurasi GoRouter terpusat untuk seluruh aplikasi.
///
/// Auth redirect: jika belum login → ke /login,
/// jika sudah login tapi buka /login atau /register → ke /
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,

  // Redirect logic untuk auth
  redirect: (BuildContext context, GoRouterState state) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final isAuthRoute =
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/register';

    // Belum login & bukan di halaman auth → paksa ke login
    if (!isLoggedIn && !isAuthRoute) {
      return '/login';
    }

    // Sudah login & masih di halaman login → arahkan ke home
    if (isLoggedIn && state.matchedLocation == '/login') {
      return '/';
    }

    return null; // Tidak ada redirect
  },

  routes: [
    // ── Auth ──
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),

    // ── Main (Bottom Navigation) ──
    GoRoute(path: '/', builder: (context, state) => const MainPage()),

    // ── Product ──
    GoRoute(
      path: '/products',
      builder: (context, state) => const ProductListPage(),
    ),
    GoRoute(
      path: '/products/:id',
      builder: (context, state) {
        // Product dikirim via extra
        final product = state.extra as ProductModel;
        return ProductDetailPage(product: product);
      },
    ),

    // ── Cart ──
    GoRoute(path: '/cart', builder: (context, state) => const CartPage()),
  ],
);
