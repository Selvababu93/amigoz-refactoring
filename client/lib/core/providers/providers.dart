import 'package:client/core/database/app_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
AppDatabase appDatabase(Ref ref) {
  return AppDatabase();
}
