// features/products/presentation/widgets/category_item_tab.dart
import 'package:flutter/material.dart';
import 'package:tienda_app/features/products/domain/models/category_model.dart';
import 'package:tienda_app/styles/app_colors.dart';

class CategoryItemTab extends StatelessWidget {
  final CategoryModel category;
  final bool isSelected;
  final VoidCallback? onTap;
  
  const CategoryItemTab({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 60,
          width: 164,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected 
                ? AppColors.primaryColor 
                : AppColors.secondaryColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              spacing: 8,
              children: [
                // Imagen
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: category.imageUrl != null && category.imageUrl!.isNotEmpty
                      ? Image.network(
                          category.imageUrl!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 40,
                              height: 40,
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.category_outlined,
                                size: 24,
                                color: Colors.grey[400],
                              ),
                            );
                          },
                        )
                      : Container(
                          width: 40,
                          height: 40,
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.category_outlined,
                            size: 24,
                            color: Colors.grey[400],
                          ),
                        ),
                ),
                
                // ✅ Nombre de la categoría - CON COLORES CORREGIDOS
                Expanded(
                  child: Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected 
                          ? Colors.white  // ✅ Cuando está seleccionado: texto blanco
                          : Colors.white, // ✅ Cuando NO está seleccionado: también blanco
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}