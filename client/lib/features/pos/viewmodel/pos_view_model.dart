import 'package:client/core/database/app_database.dart';
import 'package:client/features/pos/model/cart_item.dart';
import 'package:client/features/pos/model/invoice_item.dart';
import 'package:client/features/pos/model/invoice_model.dart';
import 'package:client/features/pos/model/product.dart';
import 'package:client/features/pos/repository/pos_repository.dart';
import 'package:client/features/pos/viewmodel/pos_state.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pos_view_model.g.dart';

@riverpod
class PosViewModel extends _$PosViewModel {
  bool _initDone = false;
  String _query = '';

  @override
  PosState build() {
    _init();
    return const PosState();
  }

  Future<void> _init() async {
    if (_initDone) return;
    _initDone = true;
    final repo = ref.read(posRepositoryProvider);

    // implement sync products later
    // testing
    // await repo.addCategory("Grocerries");
    // await repo.addCategory("Snacks");
    // await repo.addCategory("Drinks");
    // print("Cat Added");
    final products = await repo.getProducts();
    final sales = await repo.getTotalSales();
    final tx = await repo.getTotalTransactions();
    final categories = await repo.getCategories();
    state = state.copyWith(
        products: products,
        loading: false,
        totalSales: sales,
        totalTransactions: tx,
        selectedCategoryId: null,
        categories: categories);
  }

  void selectCategory(int? id) {
    state = state.copyWith(selectedCategoryId: id);
  }

  List<Product> get filteredProducts {
    if (state.selectedCategoryId == null) return state.products;

    return state.products
        .where((p) => p.categoryId == state.selectedCategoryId)
        .toList();
  }

// old version
  // Future<void> addProduct(
  //     {required String name, required double price, required int stock}) async {
  //   final repo = ref.read(posRepositoryProvider);
  //   await repo.addProduct(name: name, price: price, stock: stock);
  //   // refresh list
  //   final products = await repo.getProducts();
  //   state = state.copyWith(products: products);
  // }
  Future<void> addProduct(
      {required String name,
      required double price,
      required int stock,
      int? categoryId,
      String? imagePath,
      String? barcode}) async {
    final repo = ref.read(posRepositoryProvider);

    await repo.addProduct(
        name: name,
        price: price,
        stock: stock,
        categoryId: categoryId,
        imagePath: imagePath,
        barcode: barcode);

    // reload products
    final products = await repo.getProducts();

    state = state.copyWith(products: products);
  }

  Future<void> deleteProduct(int id) async {
    final repo = ref.read(posRepositoryProvider);
    await repo.deleteProduct(id);

    final products = await repo.getProducts();
    state = state.copyWith(products: products);
  }

  void addToCart(Product product) {
    final cart = [...state.cart];
    final i = cart.indexWhere((e) => e.product.id == product.id);

    if (i != -1) {
      cart[i] = cart[i].copyWith(quantity: cart[i].quantity + 1);
    } else {
      cart.add(CartItem(
          product: product, price: product.price, productId: product.id));
    }

    state = state.copyWith(cart: cart);
  }

  Future<void> checkOut(BuildContext context) async {
    if (state.cart.isEmpty) return;

    final repo = ref.read(posRepositoryProvider);
    final id = DateTime.now().microsecondsSinceEpoch.toString();

    final List<OrderItemsTableCompanion> items = state.cart.map((e) {
      return OrderItemsTableCompanion.insert(
          orderId: id,
          productId: e.productId,
          quantity: e.quantity,
          price: e.price);
    }).toList();
    for (final item in state.cart) {
      await repo.updateStock(item.productId, item.quantity);
    }
    final products = await repo.getProducts();

    await loadAnalytics();
    await repo.createOrder(id, state.total, items);
    final invoice = generateInVoice(id);
    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (_) => InvoicePage(invoice: invoice)));
    state = state.copyWith(cart: [], products: products);
  }

  void increaseQty(CartItem item) {
    final cart = [...state.cart];
    final index = cart.indexOf(item);

    if (index != -1) {
      cart[index] = CartItem(
          product: item.product,
          price: item.price,
          productId: item.productId,
          quantity: item.quantity + 1);
      state = state.copyWith(cart: cart);
    }
  }

  void decreaseQty(CartItem item) {
    final cart = [...state.cart];
    final index = cart.indexOf(item);
    if (index == -1) return;
    if (item.quantity > 1) {
      cart[index] = CartItem(
          product: item.product,
          price: item.price,
          productId: item.productId,
          quantity: item.quantity - 1);
    } else {
      cart.removeAt(index);
    }
    state = state.copyWith(cart: cart);
  }

  void search(String q) async {
    _query = q;
    final repo = ref.read(posRepositoryProvider);
    final all = await repo.getProducts();

    final filtered = all
        .where((p) => p.name.toLowerCase().contains(q.toLowerCase()))
        .toList();

    state = state.copyWith(products: filtered);
  }

  bool _isAdding = false;

  Future<void> scanAndAddProduct(String barcode) async {
    if (_isAdding) return;

    _isAdding = true;

    try {
      final repo = ref.read(posRepositoryProvider);

      final product = await repo.getProductByBarcode(barcode);

      if (product != null) {
        addToCart(product);
      } else {
        print("PRODUCT NOT FOUND: $barcode");
      }
    } finally {
      _isAdding = false;
    }
  }

  Future<void> loadAnalytics() async {
    final repo = ref.read(posRepositoryProvider);
    final sales = await repo.getTotalSales();
    final tx = await repo.getTotalTransactions();

    state = state.copyWith(totalSales: sales, totalTransactions: tx);
  }

  InvoiceModel generateInVoice(String orderId) {
    return InvoiceModel(
        orderId: orderId,
        date: DateTime.now(),
        items: state.cart.map((e) {
          return InvoiceItem(
              name: e.product.name, qty: e.quantity, price: e.price);
        }).toList(),
        total: state.total);
  }

  Future<void> loadReport(DateTime start, DateTime end) async {
    final repo = ref.read(posRepositoryProvider);

    final report = await repo.getReport(start, end);

    state = state.copyWith(
      totalSales: report.totalSales,
      totalTransactions: report.transactions,
    );
  }
}
