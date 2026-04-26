import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'order_items_table.dart';
import 'orders_table.dart';
import 'products_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [ProductsTable, OrdersTable, OrderItemsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, "amigoz.db"));
    return NativeDatabase(file);
  });
}
