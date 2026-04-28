import 'package:client/core/database/app_database.dart';
import 'package:client/features/pos/model/cart_item.dart';
import 'package:client/features/pos/model/product.dart';

class PosState {
  final List<Product> products;
  final List<CartItem> cart;
  final bool loading;
  final double totalSales;
  final int totalTransactions;
  final List<CategoriesTableData> categories;
  final int? selectedCategoryId;

  const PosState(
      {this.products = const [],
      this.cart = const [],
      this.loading = true,
      this.totalSales = 0,
      this.totalTransactions = 0,
      this.categories = const [],
      this.selectedCategoryId});

  double get total => cart.fold(0, (sum, item) => sum + item.total);

  PosState copyWith(
      {List<Product>? products,
      List<CartItem>? cart,
      bool? loading,
      double? totalSales,
      int? totalTransactions,
      List<CategoriesTableData>? categories,
      int? selectedCategoryId}) {
    return PosState(
        products: products ?? this.products,
        cart: cart ?? this.cart,
        loading: loading ?? this.loading,
        totalSales: totalSales ?? this.totalSales,
        totalTransactions: totalTransactions ?? this.totalTransactions,
        categories: categories ?? this.categories,
        selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId);
  }
}
