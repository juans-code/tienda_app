import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tienda_app/common/widgets/screens/splash_screen.dart'; 
import 'package:tienda_app/features/auth/presentation/screens/login_screen.dart';
import 'package:tienda_app/features/home/presentation/screens/home_screen.dart';
import 'package:tienda_app/features/auth/presentation/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'Tienda App',
      debugShowCheckedModeBanner: false,
      home: authState.when(
        data: (user) {
          if (user != null) {
            return const HomeScreen(); 
          }
          return const LoginScreen(); 
        },
        error: (error, stackTrace) => Scaffold(
          body: Center(child: Text('Error de conexión: $error')),
        ),
        loading: () => const SplashScreen(), 
      ),
    );
  }
}