import 'package:client/core/providers/providers.dart';
import 'package:client/features/pos/view/pages/home_page.dart';
import 'package:client/features/setup/view/pages/setup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Amigoz Practice",
      home: const EntryPoint(),
      routes: {"/home": (_) => const HomePage()},
    );
  }
}

class EntryPoint extends ConsumerWidget {
  const EntryPoint({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(appDatabaseProvider);

    return FutureBuilder(
      future: db.select(db.shopTable).getSingleOrNull(),
      builder: (context, snapshot) {
        // ✅ 1. While loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ✅ 2. If error
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        }

        // ✅ 3. Data loaded (can be null!)
        final shop = snapshot.data;

        if (shop == null) {
          return const SetupPage(); // first launch
        } else {
          return const HomePage(); // normal app
        }
      },
    );
  }
}
