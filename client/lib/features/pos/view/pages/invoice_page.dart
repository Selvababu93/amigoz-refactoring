import 'package:amigoz/features/pos/model/invoice_model.dart';
import 'package:flutter/material.dart';

class InvoicePage extends StatelessWidget {
  final InvoiceModel invoice;

  const InvoicePage({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Imvoice"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Order id : ${invoice.orderId}"),
            Text("Date : ${invoice.date}"),
            const Divider(),
            ...invoice.items.map((item) {
              return ListTile(
                title: Text(item.name),
                subtitle: Text("${item.qty} x ₹${item.price}"),
              );
            }),
            const Divider(),
            Text(
              "Total: ₹${invoice.total}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
