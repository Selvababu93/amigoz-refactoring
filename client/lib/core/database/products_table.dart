import 'package:drift/drift.dart';

class ProductsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get price => real()();

  IntColumn get stock => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
