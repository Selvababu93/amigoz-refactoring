import 'package:drift/drift.dart';

@TableIndex(name: 'order_items_order_id', columns: {#orderId})
@TableIndex(name: 'order_items_product_id', columns: {#productId})
class OrderItemsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get orderId => text()();
  TextColumn get productId => text()();
  IntColumn get quantity => integer()();
  RealColumn get price => real()();
}
