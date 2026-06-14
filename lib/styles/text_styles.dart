// styles/text_styles.dart
import 'package:flutter/material.dart';
import 'package:tienda_app/styles/app_colors.dart';

class AppTextStyles {
  // Botón primario
  static final TextStyle primaryButtonTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Títulos principales (ej: "Mi Tienda")
  static final TextStyle textTitleStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.secondaryColor,
  );

  // Títulos medianos (ej: "Categorías", "Todos los Productos", "Descripción", "Reseñas")
  static final TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.secondaryColor,
  );

  // Labels de campos de texto
  static final TextStyle textLabelStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.neutralColor,
  );

  // Hint de campos de texto
  static final TextStyle textHintStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.neutralColor,
  );

  // Estilo para texto dentro de campos
  static final TextStyle textFieldStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.secondaryColor,
  );

  // Descripciones
  static final TextStyle textDescriptionStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.secondaryColor,
  );

  // Estilo para botones de texto
  static final TextStyle textButtonStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.secondaryColor,
  );

  // Estilo para categorías
  static final TextStyle textCategoryStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.backgroundColor,
  );

  // Precio grande (para detalle de producto)
  static final TextStyle priceLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.green,
  );

  // Precio mediano (para tarjetas de producto)
  static final TextStyle priceMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.green,
  );

  // Nombre del producto (grande)
  static final TextStyle productNameLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.secondaryColor,
  );

  // Nombre del producto (mediano)
  static final TextStyle productNameMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.secondaryColor,
  );

  // Subtítulos
  static final TextStyle subtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.neutralColor,
  );

  // Texto pequeño (para reseñas, fechas, etc.)
  static final TextStyle small = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.neutralColor,
  );

  // Texto de error
  static final TextStyle error = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.red,
  );

  // Precio del carrito (total)
  static final TextStyle cartTotal = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.green,
  );

  // Contador de productos
  static final TextStyle badge = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}