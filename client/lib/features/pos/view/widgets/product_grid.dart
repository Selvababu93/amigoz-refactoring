import 'dart:io' as d;

import 'package:amigoz/features/pos/viewmodel/pos_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductGrid extends ConsumerWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(posViewModelProvider);
    final vm = ref.read(posViewModelProvider.notifier);

    final products = vm.filteredProducts; // ✅ IMPORTANT

    if (products.isEmpty) {
      return const Center(child: Text("No Products found"));
    }

    return Column(
      children: [
        /// 🔹 CATEGORY FILTER
        SizedBox(
          height: 60,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ChoiceChip(
                  label: const Text("All"),
                  selected: state.selectedCategoryId == null,
                  onSelected: (_) => vm.selectCategory(null),
                ),
              ),
              ...state.categories.map((c) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ChoiceChip(
                      label: Text(c.name),
                      selected: state.selectedCategoryId == c.id,
                      onSelected: (_) => vm.selectCategory(c.id),
                    ),
                  ))
            ],
          ),
        ),

        /// 🔹 PRODUCT GRID
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              final isLowStock = product.stock <= 5;

              return InkWell(
                onTap: () {
                  vm.addToCart(product);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${product.name} added"),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          /// 🔹 IMAGE
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: product.imagePath != null
                                  ? Image.file(
                                      d.File(product.imagePath!),
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      color: Colors.grey[200],
                                      child:
                                          const Icon(Icons.inventory, size: 40),
                                    ),
                            ),
                          ),

                          /// 🔹 DETAILS
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: Column(
                              children: [
                                Text(
                                  product.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text("₹ ${product.price.toStringAsFixed(2)}"),
                              ],
                            ),
                          )
                        ],
                      ),

                      /// 🔹 LOW STOCK BADGE
                      if (isLowStock)
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              "LOW",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        ),

                      /// 🔹 STOCK COUNT
                      Positioned(
                        bottom: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "Stock: ${product.stock}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
