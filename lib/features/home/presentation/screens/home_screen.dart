import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tienda_app/common/utils/firebase_seeder.dart';
import 'package:tienda_app/features/cart/presentation/screens/cart_screen.dart';
import 'package:tienda_app/features/home/presentation/providers/home_providers.dart';
import 'package:tienda_app/features/home/presentation/widgets/bottom_navigator_bar.dart';
import 'package:tienda_app/features/products/presentation/widgets/products_section.dart';
import 'package:tienda_app/features/profile/presentation/widgets/profile_section.dart';
import 'package:tienda_app/styles/app_colors.dart';
import 'package:tienda_app/styles/text_styles.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeStateProvider);

    // Mapeo de estados para el IndexedStack
    final int currentIndex = homeState == 'home' ? 0 : (homeState == 'cart' ? 1 : 2);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: currentIndex,
              children: const [
                ProductsSection(),
                CartScreen(),
                ProfileSection(),
              ],
            ),
          ),
          const BottomNavigatorBar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundColor,
      elevation: 0,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.local_mall_outlined, size: 20, color: AppColors.primaryColor),
          ),
          const SizedBox(width: 10),
          Text(
            'BAZAR GO',
            style: AppTextStyles.textTitleStyle.copyWith(
              fontSize: 18,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        // Botón de Carga de categorias y productos (Solo para desarrollo)
        /*
        IconButton(
          icon: const Icon(Icons.cloud_upload_outlined, color: AppColors.primaryColor),
          onPressed: () => _seedDatabase(context),
        ),
        */
        // Logout
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.redAccent),
          onPressed: () => _showLogoutDialog(context),
        ),
      ],
    );
  }

  Future<void> _seedDatabase(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Subiendo productos...')),
    );
    await FirebaseSeeder.seedBazarDatabase();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🎉 ¡Catálogo actualizado!')),
      );
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que deseas salir?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseAuth.instance.signOut();
            },
            child: const Text('Salir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}