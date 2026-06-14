import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tienda_app/common/widgets/screens/loading_screen.dart';
import 'package:tienda_app/common/widgets/text_fields/primary_text_field.dart';
import 'package:tienda_app/features/products/domain/models/product_model.dart';
import 'package:tienda_app/features/products/presentation/providers/products_providers.dart';
import 'package:tienda_app/features/products/presentation/screens/product_detail_screen.dart';
import 'package:tienda_app/features/products/presentation/widgets/category_item_tab.dart';
import 'package:tienda_app/features/products/presentation/widgets/product_card.dart';
import 'package:tienda_app/styles/text_styles.dart';

class ProductsSection extends ConsumerStatefulWidget {
  const ProductsSection({super.key});

  @override
  ConsumerState<ProductsSection> createState() => _ProductsSectionState();
}

class _ProductsSectionState extends ConsumerState<ProductsSection> {
  late final TextEditingController searchProductController;

  @override
  void initState() {
    super.initState();
    searchProductController = TextEditingController();
    searchProductController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    ref.read(searchQueryProvider.notifier).state = searchProductController.text;
  }

  @override
  void dispose() {
    searchProductController.removeListener(_onSearchChanged);
    searchProductController.dispose();
    super.dispose();
  }

  // Método auxiliar para el refresco
  Future<void> _handleRefresh() async {
    ref.invalidate(productsProvider);
    ref.invalidate(categoriesProvider);
    await ref.read(productsProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsyncValue = ref.watch(categoriesProvider);
    final productsAsyncValue = ref.watch(productsProvider);
    final filteredProducts = ref.watch(filteredProductsProvider);
    final selectedCategoryId = ref.watch(selectedCategoryProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: PrimaryTextField(
            suffixIcon: Icons.search,
            hintText: 'Buscar producto',
            labelText: 'Buscar producto',
            controller: searchProductController,
          ),
        ),
        _buildCategoriesSection(categoriesAsyncValue, selectedCategoryId),
        const SizedBox(height: 16),
        Expanded(
          child: _buildProductsSection(productsAsyncValue, filteredProducts),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection(AsyncValue categoriesAsyncValue, String selectedCategoryId) {
    return categoriesAsyncValue.when(
      data: (categoriesList) {
        if (categoriesList.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Categorías', style: AppTextStyles.titleMedium),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.builder(
                key: const PageStorageKey('categorias_horizontal_scroll'),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                scrollDirection: Axis.horizontal,
                itemCount: categoriesList.length,
                itemBuilder: (context, index) {
                  final category = categoriesList[index];
                  final isSelected = selectedCategoryId == category.id;
                  return CategoryItemTab(
                    category: category,
                    isSelected: isSelected,
                    onTap: () {
                      ref.read(selectedCategoryProvider.notifier).state = isSelected ? '' : category.id;
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
      error: (error, _) => const SizedBox.shrink(),
      loading: () => const Padding(
        padding: EdgeInsets.all(16.0),
        child: LinearProgressIndicator(),
      ),
    );
  }

  Widget _buildProductsSection(AsyncValue productsAsyncValue, List<ProductModel> filteredProducts) {
    return productsAsyncValue.when(
      data: (allProducts) {
        final hasActiveFilters = ref.watch(searchQueryProvider).trim().isNotEmpty ||
            ref.watch(selectedCategoryProvider).trim().isNotEmpty;

        // ESTADO VACÍO CON REFRESH INDICATOR
        if (filteredProducts.isEmpty) {
          return RefreshIndicator(
            onRefresh: _handleRefresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(hasActiveFilters ? Icons.search_off : Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(hasActiveFilters ? 'No se encontraron productos' : 'No hay productos disponibles', style: AppTextStyles.subtitle),
                        if (hasActiveFilters) ...[
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.clear),
                            label: const Text('Limpiar filtros'),
                            onPressed: () {
                              ref.read(selectedCategoryProvider.notifier).state = '';
                              ref.read(searchQueryProvider.notifier).state = '';
                              searchProductController.clear();
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // ESTADO CON DATOS CON REFRESH INDICATOR
        return RefreshIndicator(
          onRefresh: _handleRefresh,
          child: CustomScrollView(
            key: const PageStorageKey('productos_principal_grid'),
            cacheExtent: 400,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Todos los Productos', style: AppTextStyles.titleMedium),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(12.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = filteredProducts[index];
                      return ProductCard(
                        product: product,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product))),
                      );
                    },
                    childCount: filteredProducts.length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      error: (error, _) => Center(child: Text('Error: $error')),
      loading: () => const LoadingScreen(),
    );
  }
}