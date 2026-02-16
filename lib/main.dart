import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

// AUTH
import 'features/auth/cubit/auth_cubit.dart';
import 'features/auth/cubit/auth_state.dart';
import 'features/auth/pages/login_page.dart';
import 'features/auth/pages/register_page.dart';

// NAVIGATION
import 'features/navigation/cubit/navigation_cubit.dart';
import 'features/navigation/pages/main_page.dart';

// FEATURES
import 'features/product/cubit/product_cubit.dart';
import 'features/cart/cubit/cart_cubit.dart';
import 'features/transaction/cubit/transaction_cubit.dart';
import 'features/home/home_page.dart';
import 'features/product/pages/product_list_page.dart';
import 'features/cart/pages/cart_page.dart';
import 'features/transaction/pages/history_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const AppProvider());
}

/// =======================
/// APP PROVIDER
/// =======================
class AppProvider extends StatelessWidget {
  const AppProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // 🔥 Auth dicek sejak app start
        BlocProvider(create: (_) => AuthCubit()..checkAuthStatus()),

        // Navigation
        BlocProvider(create: (_) => NavigationCubit()),

        // Features
        BlocProvider(create: (_) => ProductCubit()),
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => TransactionCubit()),
      ],
      child: const MyApp(),
    );
  }
}

/// =======================
/// ROOT APP
/// =======================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yorozuya',
      theme: ThemeData(useMaterial3: true, primarySwatch: Colors.blue),

      // 🔥 LOGIN → HOME LOGIC (STATE-BASED)
      home: const AuthWrapper(),

      // 🔥 ROUTES TETAP ADA (JANGAN DIHAPUS)
      routes: {
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),

        // Routes di bawah dipakai oleh button / deep navigation,
        // BUKAN untuk flow login utama
        '/home': (_) => const HomePage(),
        '/products': (_) => const ProductListPage(),
        '/cart': (_) => const CartPage(),
        '/history': (_) => const HistoryPage(),
      },
    );
  }
}

/// =======================
/// AUTH WRAPPER
/// =======================
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        // Optional loading
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ✅ SUDAH LOGIN → MASUK MAIN PAGE (BOTTOM NAV)
        if (state is AuthSuccess) {
          return const MainPage();
        }

        // ❌ BELUM LOGIN
        return const LoginPage();
      },
    );
  }
}
