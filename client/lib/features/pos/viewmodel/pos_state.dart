import 'package:client/features/pos/model/cart_item.dart';
import 'package:client/features/pos/model/product.dart';

class PosState {
  final List<Product> products;
  final List<CartItem> cart;

  const PosState({this.products = const [], this.cart = const []});

  double get total => cart.fold(0, (sum, item) => sum + item.total);

  PosState copyWith({List<Product>? products, List<CartItem>? cart}) {
    return PosState(
        products: products ?? this.products, cart: cart ?? this.cart);
  }
}
