import 'product.dart';

class CartItem {
  final Product product;
  final int quantity;
  final double price;

  const CartItem(
      {required this.product, this.quantity = 1, required this.price});

  double get total => quantity * price;

  CartItem copyWith({Product? product, int? quantity, double? price}) {
    return CartItem(
        product: product ?? this.product,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity);
  }
}
