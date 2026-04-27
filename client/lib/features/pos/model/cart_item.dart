import 'product.dart';

class CartItem {
  final Product product;
  final int quantity;
  final double price;
  final int productId;

  const CartItem(
      {required this.product,
      this.quantity = 1,
      required this.price,
      required this.productId});

  double get total => quantity * price;

  CartItem copyWith({Product? product, int? quantity, double? price}) {
    return CartItem(
        product: product ?? this.product,
        productId: product!.id ?? this.productId,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity);
  }
}
