// data/products_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tienda_app/features/products/domain/models/category_model.dart';
import 'package:tienda_app/features/products/domain/models/product_model.dart';
import 'package:tienda_app/features/products/domain/repositories/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final FirebaseFirestore _firestore;
  
  ProductsRepositoryImpl({required FirebaseFirestore firestore}) 
      : _firestore = firestore;
  
  // ==================== CATEGORÍAS ====================
  
  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      print('🔄 Cargando categorías desde Firestore...');
      final snapshot = await _firestore.collection('categories').get();
      print('✅ Categorías encontradas: ${snapshot.docs.length}');
      
      final categories = snapshot.docs.map((doc) {
        final data = doc.data();
        print('  📁 ${doc.id}: ${data['name']}');
        return CategoryModel.fromFirestore(doc);
      }).toList();
      
      return categories;
    } catch (e) {
      print('❌ Error al cargar categorías: $e');
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
  
  // ==================== PRODUCTOS ====================
  
  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      print('🔄 Cargando productos desde Firestore...');
      final snapshot = await _firestore.collection('products').get();
      print('✅ Productos encontrados: ${snapshot.docs.length}');
      
      final products = snapshot.docs.map((doc) {
        final data = doc.data();
        print('  📦 ${doc.id}: ${data['name']} - S/ ${data['price']} - Categoría: ${data['category_id']}');
        return ProductModel.fromFirestore(doc);
      }).toList();
      
      return products;
    } catch (e) {
      print('❌ Error al cargar productos: $e');
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
      print('🔄 Cargando productos para categoría: $categoryId');
      final snapshot = await _firestore
          .collection('products')
          .where('category_id', isEqualTo: categoryId)
          .get();
      print('✅ Productos encontrados para categoría $categoryId: ${snapshot.docs.length}');
      
      return snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
    } catch (e) {
      print('❌ Error al cargar productos por categoría: $e');
      throw Exception('Error al cargar productos por categoría: $e');
    }
  }
}