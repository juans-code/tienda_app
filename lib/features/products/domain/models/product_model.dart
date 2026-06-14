// domain/models/product_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final String categoryId;
  double? rating;
  int? reviewCount;
  bool isAvailable;
  int? stock;
  DateTime? createdAt;
  
  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.categoryId,
    this.rating,
    this.reviewCount,
    this.isAvailable = true,
    this.stock,
    this.createdAt,
  });
  
  // 📁 Factory para crear desde un DocumentSnapshot directo de Firestore
  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ProductModel.fromMap(data, doc.id);
  }
  
  // 🔄 Factory principal que mapea de snake_case (Firebase) a camelCase (Dart)
  factory ProductModel.fromMap(Map<String, dynamic> map, String docId) {
    return ProductModel(
      id: docId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      // Blinda el precio si viene como entero (ej. 24) o flotante (ej. 24.9)
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['image_url'], // 🔌 Mapeado desde snake_case
      categoryId: map['category_id'] ?? '', // 🔌 Mapeado desde snake_case
      rating: (map['rating'] as num?)?.toDouble(),
      reviewCount: map['review_count'] as int?, // 🔌 CORREGIDO: cambiado a snake_case
      isAvailable: map['is_available'] ?? map['isAvailable'] ?? true, // 🔌 Soporta ambos por seguridad
      stock: map['stock'] as int?,
      createdAt: map['created_at'] != null 
          ? (map['created_at'] as Timestamp).toDate() 
          : (map['createdAt'] as Timestamp?)?.toDate(), // 🔌 Soporta ambas variantes de fecha
    );
  }
  
  // 📤 Convierte el modelo a un Map limpio listo para subirse a Firestore en snake_case
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,      // 🔌 Se guarda como snake_case
      'category_id': categoryId,  // 🔌 Se guarda como snake_case
      'rating': rating,
      'review_count': reviewCount, // 🔌 CORREGIDO a snake_case
      'is_available': isAvailable, // 🔌 CORREGIDO a snake_case
      'created_at': createdAt != null ? Timestamp.fromDate(createdAt!) : null, // 🔌 CORREGIDO a snake_case
    };
  }
}