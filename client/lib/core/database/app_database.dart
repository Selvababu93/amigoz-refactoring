import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'order_items_table.dart';
import 'orders_table.dart';
import 'products_table.dart';
import 'shop_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [ProductsTable, OrdersTable, OrderItemsTable, ShopTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // Since SQLite doesn't support easy column type changes,
            // it's often easiest to drop and recreate for dev,
            // or use m.alterTable if you're just adding columns.
            await m.deleteTable(shopTable.actualTableName);
            await m.createTable(shopTable);
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, "amigoz.db"));
    return NativeDatabase(file);
  });
}
