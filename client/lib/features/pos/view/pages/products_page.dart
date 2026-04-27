import 'package:client/features/pos/view/pages/add_product_page.dart';
import 'package:client/features/pos/viewmodel/pos_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsPage extends ConsumerWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(posViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const AddProductPage()));
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
                hintText: "Search Products", prefixIcon: Icon(Icons.search)),
            onChanged: (value) {
              ref.read(posViewModelProvider.notifier).search(value);
            },
          ),
          Expanded(
            child: ListView.builder(
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return ListTile(
                    title: Text(product.name),
                    subtitle:
                        Text("₹ ${product.price} | Stock: ${product.stock}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              // next step edit page
                            },
                            icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              ref
                                  .read(posViewModelProvider.notifier)
                                  .deleteProduct(product.id);
                            },
                            icon: Icon(Icons.delete))
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
