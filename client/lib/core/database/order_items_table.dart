import 'package:drift/drift.dart';

@TableIndex(name: 'order_items_order_id', columns: {#orderId})
@TableIndex(name: 'order_items_product_id', columns: {#productId})
class OrderItemsTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get orderId => text()(); // FK to OrdersTable.id
  IntColumn get productId => integer()(); // FK to ProductsTable.id

  IntColumn get quantity => integer().withDefault(const Constant(1))();
  RealColumn get price => real()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {orderId, productId}
      ];
}
