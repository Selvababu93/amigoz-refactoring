import 'package:drift/drift.dart';

class OrdersTable extends Table {
  TextColumn get id => text()();
  RealColumn get total => real()();
  DateTimeColumn get createdAt => dateTime()();

  BoolColumn get synced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
