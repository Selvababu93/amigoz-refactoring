import 'package:client/core/database/app_database.dart';
import 'package:client/features/pos/model/product.dart';

class PosRepository {
  final AppDatabase db;

  PosRepository(this.db);

  Future<List<Product>> getProducts() async {
    final rows = await db.select(db.productsTable).get();

    return rows
        .map((e) => Product(id: e.id, name: e.name, price: e.price))
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
}
