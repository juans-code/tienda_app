import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tienda_app/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:tienda_app/features/home/presentation/providers/home_providers.dart';
import 'package:tienda_app/features/products/presentation/providers/products_providers.dart';
import 'package:tienda_app/styles/app_colors.dart';
import 'package:tienda_app/styles/text_styles.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: cartState.items.isEmpty
          ? _buildEmptyState(context, ref)
          : Stack(
              children: [
                _buildCartList(context, cartState, cartNotifier),
                Align(
                  alignment: Alignment.bottomCenter,
                  // Pasamos el ref aquí abajo
                  child: _buildCheckoutBar(context, ref, cartState),
                ),
              ],
            ),
    );
  }

  Widget _buildCartList(
    BuildContext context,
    CartState cartState,
    CartNotifier cartNotifier,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bolsa de Compra',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                  Text(
                    '${cartState.totalQuantity} artículos',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => _showClearCartDialog(context, cartNotifier),
                icon: const Icon(
                  Icons.delete_sweep_outlined,
                  color: AppColors.errorColor,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
            itemCount: cartState.items.length,
            itemBuilder: (context, index) {
              final item = cartState.items[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CartItemCard(
                  item: item,
                  onQuantityChanged: (qty) =>
                      cartNotifier.updateQuantity(item.product.id, qty),
                  onRemove: () => cartNotifier.removeItem(item.product.id),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Ahora recibe ref como argumento
  Widget _buildCheckoutBar(
    BuildContext context,
    WidgetRef ref,
    CartState cartState,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryColor.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'TOTAL ESTIMADO',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'S/ ${cartState.subtotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.priceColor,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 46,
            child: ElevatedButton(
              onPressed: () =>
                  _showCheckoutDialog(context, ref, cartState.subtotal),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryColor,
                foregroundColor: AppColors.textLight,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                children: [
                  Text('Pagar', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, CartNotifier notifier) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Vaciar bolsa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              notifier.clearCart();
              Navigator.pop(ctx);
            },
            child: const Text('Vaciar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Ahora recibe ref como argumento
  void _showCheckoutDialog(BuildContext context, WidgetRef ref, double total) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('¡Pedido Confirmado!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 50,
            ),
            const SizedBox(height: 16),
            Text('Total pagado: S/ ${total.toStringAsFixed(2)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(cartProvider.notifier).clearCart();
              Navigator.of(ctx).pop();
              ref.read(homeStateProvider.notifier).state = 'home';
            },
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 80,
              color: AppColors.primaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text('Tu bolsa está vacía', style: AppTextStyles.titleMedium),
            const SizedBox(height: 8),
            const Text(
              'Parece que aún no has añadido nada. ¡Explora nuestros productos y encuentra lo que buscas!',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
            // Botón mejorado en lugar de TextButton
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () =>
                    ref.read(homeStateProvider.notifier).state = 'home',
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Ver productos',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
