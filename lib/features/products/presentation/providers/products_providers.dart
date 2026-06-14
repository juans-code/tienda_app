import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:tienda_app/features/products/data/products_repository_impl.dart';
import 'package:tienda_app/features/products/domain/models/category_model.dart';
import 'package:tienda_app/features/products/domain/models/product_model.dart';
import 'package:tienda_app/features/products/domain/repositories/products_repository.dart';


final firebaseFirestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final productsRepositoryProvider = Provider<ProductsRepository>(
  (ref) => ProductsRepositoryImpl(firestore: ref.watch(firebaseFirestoreProvider)),
);

final productsProvider = FutureProvider<List<ProductModel>>((ref) async {
  ref.keepAlive(); 
  final repository = ref.watch(productsRepositoryProvider);
  return repository.getProducts();
});

final productByIdProvider = FutureProvider.family<ProductModel?, String>((ref, productId) async {
  final repository = ref.watch(productsRepositoryProvider);
  return repository.getProductById(productId);
});

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final repository = ref.watch(productsRepositoryProvider);
  return repository.getCategories();
});

final searchQueryProvider = StateProvider<String>((ref) => '');
final selectedCategoryProvider = StateProvider<String>((ref) => '');

final filteredProductsProvider = Provider<List<ProductModel>>((ref) {
  final productsAsync = ref.watch(productsProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
  final selectedCategoryId = ref.watch(selectedCategoryProvider);
  
  final products = productsAsync.value ?? [];
  
  return products.where((product) {
    final matchesCategory = selectedCategoryId.isEmpty || product.categoryId == selectedCategoryId;
    final matchesQuery = searchQuery.isEmpty || 
                         product.name.toLowerCase().contains(searchQuery) || 
                         product.description.toLowerCase().contains(searchQuery);
    
    return matchesCategory && matchesQuery;
  }).toList();
});


class CartItemModel {
  final String id;
  final ProductModel product;
  final int quantity;
  
  CartItemModel({required this.id, required this.product, required this.quantity});
  
  double get totalPrice => product.price * quantity;
  
  CartItemModel copyWith({int? quantity}) {
    return CartItemModel(
      id: id,
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartState {
  final List<CartItemModel> items;
  const CartState({this.items = const []});
  
  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  
  CartState copyWith({List<CartItemModel>? items}) => CartState(items: items ?? this.items);
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());
  
  void addItem({required ProductModel product, int quantity = 1}) {
    final index = state.items.indexWhere((item) => item.product.id == product.id);
    
    if (index != -1) {
      final updatedItems = [...state.items];
      updatedItems[index] = updatedItems[index].copyWith(
        quantity: updatedItems[index].quantity + quantity
      );
      state = state.copyWith(items: updatedItems);
    } else {
      state = state.copyWith(items: [
        ...state.items, 
        CartItemModel(id: product.id, product: product, quantity: quantity)
      ]);
    }
  }
  
  void removeItem(String productId) {
    state = state.copyWith(
      items: state.items.where((item) => item.product.id != productId).toList()
    );
  }
  
  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(productId);
      return;
    }
    
    state = state.copyWith(
      items: state.items.map((item) {
        return item.product.id == productId ? item.copyWith(quantity: newQuantity) : item;
      }).toList(),
    );
  }


  void clearCart() {
    state = const CartState(items: []);
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) => CartNotifier());


final formattedPriceProvider = Provider.family<String, double>((ref, price) => 'S/ ${price.toStringAsFixed(2)}');