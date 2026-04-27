import 'dart:convert';

import 'package:client/core/database/app_database.dart';
import 'package:client/core/providers/providers.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'setup_repository.g.dart';

@riverpod
SetupRepository setupRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return SetupRepository(db);
}

class SetupRepository {
  final AppDatabase db;

  SetupRepository(this.db);

  Future<void> saveShop({
    required String name,
    required String city,
    required String state,
    required String country,
    required String mobile,
    required String currency,
  }) async {
    try {
      // 1. CALL BACKEND FIRST
      final response = await http.post(
        Uri.parse("https://selvababu.dev/api/pos/setup"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "shop_name": name,
          "city": city,
          "state": state,
          "country": country,
          "mobile": mobile,
          "currency": currency,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception("Backend setup failed: ${response.body}");
      }

      final data = jsonDecode(response.body);
      final String shopId = data["shop_id"].toString();

      // 2. SAVE LOCALLY WITH SERVER ID
      await db.into(db.shopTable).insert(
            ShopTableCompanion.insert(
              id: shopId,
              name: name,
              city: city,
              state: state,
              country: country,
              mobile: mobile,
              currency: currency,
            ),
          );
    } catch (e) {
      throw Exception("Setup failed: $e");
    }
  }
}
