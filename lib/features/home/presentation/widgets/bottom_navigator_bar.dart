import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tienda_app/common/image_assets/image_assets.dart';
import 'package:tienda_app/features/home/presentation/providers/home_providers.dart';
import 'package:tienda_app/features/home/presentation/widgets/bottom_navigator_tab.dart';
import 'package:tienda_app/styles/app_colors.dart';

class BottomNavigatorBar extends ConsumerWidget {
  const BottomNavigatorBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final homeState = ref.watch(homeStateProvider);

    return Container(
      color: AppColors.neutralColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Expanded(
              child: BottomNavigatorTab(
                title: 'Inicio',
                iconPath: ImageAssets.home,
                isSelected: homeState == 'home',
                onTap: () {
                  ref.read(homeStateProvider.notifier).state = 'home';
                },
              ),
            ),
            Expanded(
              child: BottomNavigatorTab(
                title: 'Carrito',
                iconPath: ImageAssets.cart,
                isSelected: homeState == 'cart',
                onTap: () {
                  ref.read(homeStateProvider.notifier).state = 'cart';
                },
              ),
            ),
            Expanded(
              child: BottomNavigatorTab(
                title: 'Perfil',
                iconPath: ImageAssets.profile,
                isSelected: homeState == 'profile',
                onTap: () {
                  ref.read(homeStateProvider.notifier).state = 'profile';
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
