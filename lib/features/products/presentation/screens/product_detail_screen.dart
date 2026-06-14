import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tienda_app/features/products/domain/models/category_model.dart';
import 'package:tienda_app/features/products/domain/models/product_model.dart';
import 'package:tienda_app/features/products/presentation/providers/products_providers.dart';
import 'package:tienda_app/styles/app_colors.dart';
import 'package:tienda_app/styles/text_styles.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final ProductModel product;
  
  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int quantity = 1;
  
  @override
  Widget build(BuildContext context) {
    final cartNotifier = ref.watch(cartProvider.notifier);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductImage(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProductInfo(),
                      const SizedBox(height: 24),
                      _buildQuantitySelector(),
                      const SizedBox(height: 28),
                      _buildDescription(),
                      const SizedBox(height: 28),
                      _buildReviewsSection(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildFloatingAppBar(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.backgroundColor,
        elevation: 10,
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.shopping_cart_outlined, size: 22, color: AppColors.textLight),
            label: Text(
              'Agregar al Carrito',
              style: AppTextStyles.primaryButtonTextStyle.copyWith(
                fontSize: 16, 
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
              ),
            ),
            onPressed: () {
              cartNotifier.addItem(
                product: widget.product,
                quantity: quantity,
              );
              _showAddedToCartSnackBar();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.textLight,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingAppBar() {
    final paddingTop = MediaQuery.paddingOf(context).top;

    return Positioned(
      top: paddingTop + 10,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBlurCircleButton(
            icon: Icons.arrow_back_ios_new,
            onPressed: () => Navigator.pop(context),
          ),
          _buildBlurCircleButton(
            icon: Icons.share_outlined,
            onPressed: () => _showShareDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurCircleButton({required IconData icon, required VoidCallback onPressed}) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.backgroundColor.withOpacity(0.75),
          child: IconButton(
            icon: Icon(icon, color: AppColors.secondaryColor, size: 18),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
  
  Widget _buildProductImage() {
    final double imageHeight = MediaQuery.sizeOf(context).height * 0.42;

    return Container(
      height: imageHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.secondaryColor.withOpacity(0.05),
      ),
   
      child: Hero(
        tag: 'product-image-${widget.product.id}',
        child: widget.product.imageUrl != null && widget.product.imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: widget.product.imageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                memCacheWidth: 480,  
                memCacheHeight: 640, 
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                ),
                errorWidget: (context, url, error) => _buildImagePlaceholder(Icons.image_not_supported_outlined),
              )
            : _buildImagePlaceholder(Icons.shopping_bag_outlined),
      ),
    );
  }

  Widget _buildImagePlaceholder(IconData icon) {
    return Center(
      child: Icon(
        icon,
        size: 70,
        color: AppColors.neutralColor.withOpacity(0.5),
      ),
    );
  }
  
  Widget _buildProductInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product.name,
                style: AppTextStyles.productNameLarge.copyWith(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              if (widget.product.rating != null)
                Row(
                  children: [
                    _buildRatingStars(widget.product.rating!),
                    const SizedBox(width: 6),
                    Text(
                      '${widget.product.rating} (${widget.product.reviewCount ?? 0} reseñas)',
                      style: AppTextStyles.small.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 12),
              Consumer(
                builder: (context, ref, child) {
                  final categoriesAsync = ref.watch(categoriesProvider);
                  
                  return categoriesAsync.when(
                    data: (categories) {
                      final category = categories.firstWhere(
                        (cat) => cat.id == widget.product.categoryId,
                        orElse: () => CategoryModel(id: widget.product.categoryId, name: 'Sin categoría'),
                      );
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '📁 ${category.name}',
                          style: AppTextStyles.textCategoryStyle.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      );
                    },
                    error: (_, __) => const SizedBox.shrink(),
                    loading: () => const SizedBox.shrink(),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'S/ ${widget.product.price.toStringAsFixed(2)}',
              style: AppTextStyles.priceLarge.copyWith(
                color: AppColors.priceColor,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (widget.product.stock != null)
              Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.neutralColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Stock: ${widget.product.stock}',
                  style: AppTextStyles.small.copyWith(
                    fontSize: 11, 
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        Text(
          'Cantidad',
          style: AppTextStyles.titleMedium.copyWith(
            fontSize: 16, 
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            color: AppColors.neutralColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              _buildQuantityButton(
                icon: Icons.remove,
                onPressed: () {
                  if (quantity > 1) setState(() => quantity--);
                },
              ),
              Container(
                width: 44,
                alignment: Alignment.center,
                child: Text(
                  quantity.toString(),
                  style: AppTextStyles.textFieldStyle.copyWith(
                    fontWeight: FontWeight.bold, 
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              _buildQuantityButton(
                icon: Icons.add,
                onPressed: () {
                  if (widget.product.stock == null || quantity < widget.product.stock!) {
                    setState(() => quantity++);
                  } else {
                    _showMaxStockMessage();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityButton({required IconData icon, required VoidCallback onPressed}) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: AppColors.cardBackground, 
      child: IconButton(
        icon: Icon(icon, size: 14, color: AppColors.secondaryColor),
        padding: EdgeInsets.zero,
        onPressed: onPressed,
      ),
    );
  }
  
  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descripción',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          widget.product.description,
          style: AppTextStyles.textDescriptionStyle.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
  
  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reseñas',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () => _showAllReviews(),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text(
                'Ver todas',
                style: AppTextStyles.textButtonStyle.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildReviewCard(
          userName: 'María González',
          rating: 5.0,
          comment: 'Excelente producto, muy recomendado. La calidad es increíble y el precio es justo.',
          date: 'Hace 2 días',
          userInitial: 'M',
        ),
        const SizedBox(height: 12),
        _buildReviewCard(
          userName: 'Carlos Ruiz',
          rating: 4.0,
          comment: 'Muy buen producto, cumple con lo que promete. El envío fue rápido y la atención excelente.',
          date: 'Hace 5 días',
          userInitial: 'C',
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.rate_review_outlined, size: 18, color: AppColors.primaryColor),
            label: Text(
              'Escribir una reseña',
              style: AppTextStyles.textButtonStyle.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
            ),
            onPressed: () => _showWriteReviewDialog(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: AppColors.primaryColor.withOpacity(0.4), width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildReviewCard({
    required String userName,
    required double rating,
    required String comment,
    required String date,
    required String userInitial,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor), 
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryColor.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primaryColor.withOpacity(0.08),
                child: Text(
                  userInitial,
                  style: AppTextStyles.textButtonStyle.copyWith(
                    fontSize: 13,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: AppTextStyles.productNameMedium.copyWith(
                        fontWeight: FontWeight.bold, 
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildRatingStars(rating),
                  ],
                ),
              ),
              Text(
                date,
                style: AppTextStyles.small.copyWith(
                  color: AppColors.textSecondary, 
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            comment,
            style: AppTextStyles.textDescriptionStyle.copyWith(
              color: AppColors.textPrimary.withOpacity(0.85), 
              fontSize: 13.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
  
  Widget _buildRatingStars(double rating) {
    const Color starColor = Colors.amber; 
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        if (rating >= starValue) {
          return const Icon(Icons.star_rounded, size: 16, color: starColor);
        } else if (rating >= starValue - 0.5) {
          return const Icon(Icons.star_half_rounded, size: 16, color: starColor);
        } else {
          return const Icon(Icons.star_border_rounded, size: 16, color: starColor);
        }
      }),
    );
  }

  void _showAddedToCartSnackBar() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.successColor, size: 20), 
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${widget.product.name} listo en tu carrito',
                style: AppTextStyles.primaryButtonTextStyle.copyWith(fontSize: 14, color: AppColors.textLight),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.secondaryColor, 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showMaxStockMessage() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Solo quedan ${widget.product.stock} unidades en stock.',
          style: AppTextStyles.primaryButtonTextStyle.copyWith(fontSize: 14, color: AppColors.textLight),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.warningColor, 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
  
  void _showShareDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.neutralColor, 
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Compartir producto', 
                style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                  child: const Icon(Icons.share, color: AppColors.primaryColor),
                ),
                title: Text('Compartir con otras apps', style: AppTextStyles.subtitle.copyWith(color: AppColors.textPrimary)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.neutralColor.withOpacity(0.2),
                  child: const Icon(Icons.copy, color: AppColors.secondaryColor),
                ),
                title: Text('Copiar enlace al portapapeles', style: AppTextStyles.subtitle.copyWith(color: AppColors.textPrimary)),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAllReviews() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.neutralColor, borderRadius: BorderRadius.circular(2))),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Todas las reseñas', 
                style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  _buildReviewCard(userName: 'María González', rating: 5.0, comment: 'Excelente producto, muy recomendado.', date: 'Hace 2 días', userInitial: 'M'),
                  const SizedBox(height: 12),
                  _buildReviewCard(userName: 'Carlos Ruiz', rating: 4.0, comment: 'Muy buen producto, cumple con lo que promete.', date: 'Hace 5 días', userInitial: 'C'),
                  const SizedBox(height: 12),
                  _buildReviewCard(userName: 'Ana López', rating: 4.5, comment: 'Producto de calidad, el empaque llegó impecable.', date: 'Hace 1 semana', userInitial: 'A'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWriteReviewDialog() {
    final TextEditingController reviewController = TextEditingController();
    double rating = 5.0;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.backgroundColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                'Escribir reseña', 
                style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text('Calificación: ', style: AppTextStyles.subtitle.copyWith(color: AppColors.textPrimary)),
                      const SizedBox(width: 4),
                      Row(
                        children: List.generate(5, (index) {
                          return IconButton(
                            icon: Icon(
                              index < rating ? Icons.star_rounded : Icons.star_border_rounded,
                              color: Colors.amber,
                              size: 28,
                            ),
                            onPressed: () => setState(() => rating = index + 1.0),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: reviewController,
                    style: AppTextStyles.textFieldStyle.copyWith(color: AppColors.textPrimary),
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Cuéntanos tu experiencia...',
                      hintStyle: AppTextStyles.small.copyWith(color: AppColors.textHint), 
                      filled: true,
                      fillColor: AppColors.surfaceColor, 
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.borderColor), 
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancelar', 
                    style: AppTextStyles.textButtonStyle.copyWith(color: AppColors.textSecondary)
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Enviar', 
                    style: AppTextStyles.primaryButtonTextStyle.copyWith(fontSize: 14, color: AppColors.textLight)
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}