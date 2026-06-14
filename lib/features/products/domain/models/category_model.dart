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
  
  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return CategoryModel.fromMap(data, doc.id);
  }
  
  factory CategoryModel.fromMap(Map<String, dynamic> map, String docId) {
    return CategoryModel(
      id: docId,
      name: map['name'] ?? '',
      imageUrl: map['image_url'] ?? map['imageUrl'],
    );
  }
  
 
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image_url': imageUrl,
    };
  }
}