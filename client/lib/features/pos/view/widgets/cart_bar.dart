import 'package:client/features/pos/view/widgets/cart_sheet.dart';
import 'package:client/features/pos/viewmodel/pos_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartBar extends ConsumerWidget {
  const CartBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(posViewModelProvider);

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const CartSheet());
      },
      child: Container(
        height: 60,
        color: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${state.cart.length} items",
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              "Rupees ${state.total.toStringAsFixed(2)}",
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
