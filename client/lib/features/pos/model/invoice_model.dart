import 'invoice_item.dart';

class InvoiceModel {
  final String orderId;
  final DateTime date;
  final List<InvoiceItem> items;
  final double total;

  InvoiceModel(
      {required this.orderId,
      required this.date,
      required this.items,
      required this.total});
}
