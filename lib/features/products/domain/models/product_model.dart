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
  
 
  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ProductModel.fromMap(data, doc.id);
  }
  
 
  factory ProductModel.fromMap(Map<String, dynamic> map, String docId) {
    return ProductModel(
      id: docId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['image_url'], 
      categoryId: map['category_id'] ?? '',
      rating: (map['rating'] as num?)?.toDouble(),
      reviewCount: map['review_count'] as int?,
      isAvailable: map['is_available'] ?? map['isAvailable'] ?? true,
      stock: map['stock'] as int?,
      createdAt: map['created_at'] != null 
          ? (map['created_at'] as Timestamp).toDate() 
          : (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }
  
 
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'category_id': categoryId,
      'rating': rating,
      'review_count': reviewCount,
      'is_available': isAvailable,
      'created_at': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }
}