import 'package:client/features/pos/view/pages/barcode_scanner_page.dart';
import 'package:client/features/pos/view/widgets/cart_bar.dart';
import 'package:client/features/pos/view/widgets/product_grid.dart';
import 'package:client/features/pos/viewmodel/pos_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PosPage extends ConsumerWidget {
  const PosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(posViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("POS System"),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () async {
              final barcode = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => const BarcodeScannerPage()));

              if (barcode != null && context.mounted) {
                final cleanBarcode = barcode.trim();

                // ✅ Read FRESH notifier here, not from build
                final success = await ref
                    .read(posViewModelProvider.notifier)
                    .scanAndAddProduct(cleanBarcode);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text(success ? "Product added" : "Product not found"),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: const ProductGrid(),
      bottomNavigationBar: const CartBar(),
    );
  }
}
