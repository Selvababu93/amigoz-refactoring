import 'package:drift/drift.dart';

class ShopTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get city => text()();
  TextColumn get state => text()();
  TextColumn get country => text()();
  TextColumn get mobile => text()();
  TextColumn get currency => text()();
}
