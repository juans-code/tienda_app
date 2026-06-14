// domain/models/category_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String name;
  final String? imageUrl;
  
  CategoryModel({
    required this.id,
    required this.name,
    this.imageUrl,
  });
  
  // 📁 Factory para crear desde un DocumentSnapshot directo de Firestore
  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return CategoryModel.fromMap(data, doc.id);
  }
  
  // 🔄 Factory principal que mapea de snake_case (Firebase) a camelCase (Dart)
  factory CategoryModel.fromMap(Map<String, dynamic> map, String docId) {
    return CategoryModel(
      id: docId,
      name: map['name'] ?? '',
      imageUrl: map['image_url'] ?? map['imageUrl'], // 🔌 Soporta ambas nomenclaturas por seguridad en la migración
    );
  }
  
  // 📤 Convierte el modelo a un Map limpio listo para subirse a Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image_url': imageUrl, // 🔌 Se guarda estrictamente como snake_case
    };
  }
}