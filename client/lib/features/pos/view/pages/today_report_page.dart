import 'package:client/features/pos/viewmodel/pos_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodayReportPage extends ConsumerWidget {
  const TodayReportPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(posViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: const Text("Total Products"),
                trailing: Text(state.products.length.toString()),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("Cart Value"),
                trailing: Text(state.total.toString()),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("Total Sales"),
                trailing: Text("₹ ${state.totalSales.toStringAsFixed(2)}"),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("Total Transactions"),
                trailing: Text(state.totalTransactions.toString()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
