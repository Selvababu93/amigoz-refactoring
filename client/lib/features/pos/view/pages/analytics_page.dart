import 'package:client/features/pos/viewmodel/pos_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ReportFilter { today, week, month, lastMonth, custom }

class AnalyticsPage extends ConsumerStatefulWidget {
  const AnalyticsPage({super.key});

  @override
  ConsumerState<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends ConsumerState<AnalyticsPage> {
  ReportFilter selectedFilter = ReportFilter.today;

  DateTime? customStart;
  DateTime? customEnd;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final vm = ref.read(posViewModelProvider.notifier);

    final now = DateTime.now();

    switch (selectedFilter) {
      case ReportFilter.today:
        final start = DateTime(now.year, now.month, now.day);
        final end = start.add(const Duration(days: 1));
        await vm.loadReport(start, end);
        break;

      case ReportFilter.week:
        final start = now.subtract(Duration(days: now.weekday - 1));
        await vm.loadReport(start, now);
        break;

      case ReportFilter.month:
        final start = DateTime(now.year, now.month, 1);
        final end = (now.month == 12)
            ? DateTime(now.year + 1, 1, 1)
            : DateTime(now.year, now.month + 1, 1);
        await vm.loadReport(start, end);
        break;

      case ReportFilter.lastMonth:
        final start = DateTime(now.year, now.month - 1, 1);
        final end = DateTime(now.year, now.month, 1);
        await vm.loadReport(start, end);
        break;

      case ReportFilter.custom:
        if (customStart != null && customEnd != null) {
          await vm.loadReport(customStart!, customEnd!);
        }
        break;
    }
  }

  Future<void> _pickCustomRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      customStart = picked.start;
      customEnd = picked.end;

      setState(() {
        selectedFilter = ReportFilter.custom;
      });

      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(posViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Analytics")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔹 FILTER CHIPS
            Wrap(
              spacing: 8,
              children: [
                _chip("Today", ReportFilter.today),
                _chip("Week", ReportFilter.week),
                _chip("Month", ReportFilter.month),
                _chip("Last Month", ReportFilter.lastMonth),
                ActionChip(
                  label: const Text("Custom"),
                  onPressed: _pickCustomRange,
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// 🔹 SALES CARD
            _card(
              "Total Sales",
              "AED ${state.totalSales.toStringAsFixed(2)}",
              Icons.attach_money,
            ),

            /// 🔹 TRANSACTIONS CARD
            _card(
              "Transactions",
              state.totalTransactions.toString(),
              Icons.receipt_long,
            ),

            const SizedBox(height: 10),

            /// 🔹 EXTRA INFO
            if (selectedFilter == ReportFilter.custom &&
                customStart != null &&
                customEnd != null)
              Text(
                "From ${customStart!.toLocal().toString().split(' ')[0]} "
                "to ${customEnd!.toLocal().toString().split(' ')[0]}",
                style: const TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Filter Chip Widget
  Widget _chip(String label, ReportFilter filter) {
    final isSelected = selectedFilter == filter;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          selectedFilter = filter;
        });
        _loadData();
      },
    );
  }

  /// 🔹 Card Widget
  Widget _card(String title, String value, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
