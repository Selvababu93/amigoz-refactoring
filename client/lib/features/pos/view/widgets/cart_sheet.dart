import 'package:client/features/pos/viewmodel/pos_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartSheet extends ConsumerWidget {
  const CartSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(posViewModelProvider);
    final vm = ref.read(posViewModelProvider.notifier);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: state.cart.length,
                  itemBuilder: (context, index) {
                    final item = state.cart[index];
                    return ListTile(
                      title: Text(item.product.name),
                      subtitle: Row(
                        children: [
                          IconButton(
                              onPressed: () => vm.decreaseQty(item),
                              icon: Icon(Icons.remove)),
                          Text("${item.quantity}"),
                          IconButton(
                              onPressed: () => vm.increaseQty(item),
                              icon: Icon(Icons.add))
                        ],
                      ),
                      trailing: Text("Rupees ${item.total.toStringAsFixed(2)}"),
                    );
                  })),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50)),
              onPressed: state.cart.isEmpty
                  ? null
                  : () {
                      vm.checkOut(context);

                      Navigator.of(context).pop();
                    },
              child: const Text('CHECKOUT'))
        ],
      ),
    );
  }
}
