import 'package:client/core/database/app_database.dart';
import 'package:client/core/providers/providers.dart';
import 'package:client/core/utils/date_range.dart';
import 'package:client/core/utils/report_filters.dart';
import 'package:client/features/pos/model/product.dart';
import 'package:client/features/pos/model/sales_report.dart';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pos_repository.g.dart';

@riverpod
PosRepository posRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return PosRepository(db);
}

class PosRepository {
  final AppDatabase db;

  PosRepository(this.db);

  Stream<List<Product>> watchProducts() {
    return db.select(db.productsTable).watch().map((rows) => rows
        .map((e) =>
            Product(id: e.id, name: e.name, price: e.price, stock: e.stock))
        .toList());
  }

  Future<List<Product>> getProducts() async {
    final rows = await db.select(db.productsTable).get();
    return rows
        .map((e) =>
            Product(id: e.id, name: e.name, price: e.price, stock: e.stock))
        .toList();
  }

  Future<void> createOrder(
    String id,
    double total,
    List<OrderItemsTableCompanion> items,
  ) async {
    await db.transaction(() async {
      await db.into(db.ordersTable).insert(OrdersTableCompanion.insert(
          id: id, total: total, createdAt: DateTime.now()));
      await db.batch((b) => b.insertAll(db.orderItemsTable, items));
    });
  }

  Future<void> addProduct(
      {required String name, required double price, required int stock}) async {
    await db.into(db.productsTable).insert(ProductsTableCompanion.insert(
        name: name, price: price, stock: Value(stock)));
  }

  Future<void> deleteProduct(int id) async {
    await (db.delete(db.productsTable)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> updateStock(int productId, int qty) async {
    final product = await (db.select(db.productsTable)
          ..where((t) => t.id.equals(productId)))
        .getSingle();

    await (db.update(db.productsTable)..where((t) => t.id.equals(productId)))
        .write(ProductsTableCompanion(stock: Value(product.stock - qty)));
  }

  Future<double> getTotalSales() async {
    final query = db.selectOnly(db.ordersTable)
      ..addColumns([db.ordersTable.total]);

    final rows = await query.get();

    return rows.fold<double>(0.0, (double sum, row) {
      final value = row.read(db.ordersTable.total) ?? 0.0;
      return sum + value;
    });
  }

  Future<int> getTotalTransactions() async {
    final query = db.select(db.ordersTable);
    final rows = await query.get();
    return rows.length;
  }

  Future<double> getSalesBetween(DateTime start, DateTime end) async {
    final rows = await (db.select(db.ordersTable)
          ..where((t) => t.createdAt.isBetweenValues(start, end)))
        .get();

    return rows.fold<double>(
      0.0,
      (sum, row) => sum + (row.total ?? 0.0),
    );
  }

  Future<int> getTransactionsBetween(DateTime start, DateTime end) async {
    final rows = await (db.select(db.ordersTable)
          ..where((t) => t.createdAt.isBetweenValues(start, end)))
        .get();

    return rows.length;
  }

  Future<SalesReport> getReport(DateTime start, DateTime end) async {
    final sales = await getSalesBetween(start, end);
    final tx = await getTransactionsBetween(start, end);

    return SalesReport(totalSales: sales, transactions: tx);
  }

  (DateTime, DateTime) getRange(ReportFilter filter) {
    final now = DateTime.now();

    switch (filter) {
      case ReportFilter.today:
        final start = DateRanges.startOfDay(now);
        return (start, start.add(const Duration(days: 1)));

      case ReportFilter.yesterday:
        final y = now.subtract(const Duration(days: 1));
        final start = DateRanges.startOfDay(y);
        return (start, start.add(const Duration(days: 1)));

      case ReportFilter.thisWeek:
        final start = DateRanges.startOfWeek(now);
        return (start, now);

      case ReportFilter.thisMonth:
        final start = DateRanges.startOfMonth(now);
        final end = DateRanges.startOfNextMonth(now);
        return (start, end);

      case ReportFilter.lastMonth:
        final start = DateTime(now.year, now.month - 1, 1);
        final end = DateRanges.startOfMonth(now);
        return (start, end);

      case ReportFilter.custom:
        throw Exception("Use manual date picker");
    }
  }
}
