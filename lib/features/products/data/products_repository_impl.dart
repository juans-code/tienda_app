// data/products_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tienda_app/features/products/domain/models/category_model.dart';
import 'package:tienda_app/features/products/domain/models/product_model.dart';
import 'package:tienda_app/features/products/domain/repositories/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final FirebaseFirestore _firestore;
  
  ProductsRepositoryImpl({required FirebaseFirestore firestore}) 
      : _firestore = firestore;
  
  @override
  Future<List<CategoryModel>> getCategories() async {
    try {

      final snapshot = await _firestore.collection('categories').get();
      final categories = snapshot.docs.map((doc) {
        return CategoryModel.fromFirestore(doc);
      }).toList();
      
      return categories;
    } catch (e) {
      throw Exception('Error al cargar categorías: $e');
    }
  }
  
  @override
  Future<CategoryModel?> getCategoryById(String categoryId) async {
    try {
      final doc = await _firestore.collection('categories').doc(categoryId).get();
      if (doc.exists) {
        return CategoryModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Error al cargar la categoría: $e');
    }
  }
  
  
  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final snapshot = await _firestore.collection('products').get();
  
      final products = snapshot.docs.map((doc) {
        return ProductModel.fromFirestore(doc);
      }).toList();
      
      return products;
    } catch (e) {
      throw Exception('Error al cargar productos: $e');
    }
  }
  
  @override
  Future<ProductModel?> getProductById(String productId) async {
    try {
      final doc = await _firestore.collection('products').doc(productId).get();
      if (doc.exists) {
        return ProductModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Error al cargar el producto: $e');
    }
  }
  
  @override
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('category_id', isEqualTo: categoryId)
          .get();
      
      return snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Error al cargar productos por categoría: $e');
    }
  }
}