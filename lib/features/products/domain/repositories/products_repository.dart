import 'package:tienda_app/features/products/domain/models/category_model.dart';
import 'package:tienda_app/features/products/domain/models/product_model.dart';

abstract class ProductsRepository {
  // Categories
  Future<List<CategoryModel>> getCategories();
  Future<CategoryModel?> getCategoryById(String categoryId);
  
  // Products
  Future<List<ProductModel>> getProducts();
  Future<ProductModel?> getProductById(String productId);
  Future<List<ProductModel>> getProductsByCategory(String categoryId);
}