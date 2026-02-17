import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'core/routes/app_router.dart';

// Cubits
import 'features/auth/cubit/auth_cubit.dart';
import 'features/product/cubit/product_cubit.dart';
import 'features/cart/cubit/cart_cubit.dart';
import 'features/transaction/cubit/transaction_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const AppProvider());
}

/// Menyediakan semua BlocProvider di level tertinggi.
class AppProvider extends StatelessWidget {
  const AppProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()..checkAuthStatus()),
        BlocProvider(create: (_) => ProductCubit()),
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => TransactionCubit()),
      ],
      child: const MyApp(),
    );
  }
}

/// Root widget — menggunakan MaterialApp.router dengan GoRouter.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Yorozuya',
      theme: ThemeData(useMaterial3: true, primarySwatch: Colors.blue),
      routerConfig: appRouter,
    );
  }
}
