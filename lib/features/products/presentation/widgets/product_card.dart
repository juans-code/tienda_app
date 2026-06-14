// features/products/presentation/widgets/product_card.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tienda_app/features/products/domain/models/product_model.dart';
import 'package:tienda_app/styles/text_styles.dart';

/// [ProductCard] optimizado como StatelessWidget.
/// Al usar imágenes ligeras desde el servidor, ya no requiere conservar el estado
/// en caché de manera forzada, permitiendo un scroll nativo a máximos FPS.
class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                // Animación Hero limpia vinculada al ID único del producto
                child: Hero(
                  tag: 'product-image-${product.id}',
                  child: _buildProductImage(context),
                ),
              ),
            ),
            
            // Información del producto
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Nombre del producto
                    Text(
                      product.name,
                      style: AppTextStyles.productNameMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    
                    // Precio y botón de agregar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'S/ ${product.price.toStringAsFixed(2)}',
                          style: AppTextStyles.priceMedium,
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart_outlined,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    if (product.imageUrl != null && product.imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: product.imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        
        // ✅ MANTENER: Limita la decodificación de píxeles en memoria RAM.
        // Valores ideales para tarjetas dispuestas en grillas de 2 columnas.
        memCacheWidth: 280,  
        memCacheHeight: 380, 
        
        // Placeholder plano y ligero para no entorpecer la fluidez de la GPU
        placeholder: (context, url) => Container(
          color: Colors.grey[200],
        ),
        
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported,
                size: 28,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 4),
              Text(
                'Sin imagen',
                style: AppTextStyles.small,
              ),
            ],
          ),
        ),
      );
    }
    
    // Contenedor alternativo en caso de que la propiedad imageUrl sea nula o vacía
    return Container(
      color: Colors.grey[200],
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 28,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 4),
          Text(
            'Sin imagen',
            style: AppTextStyles.small,
          ),
        ],
      ),
    );
  }
}