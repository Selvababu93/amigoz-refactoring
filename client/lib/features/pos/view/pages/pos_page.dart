import 'package:client/features/pos/view/pages/add_product_page.dart';
import 'package:client/features/pos/view/widgets/cart_bar.dart';
import 'package:client/features/pos/view/widgets/product_grid.dart';
import 'package:flutter/material.dart';

class PosPage extends StatelessWidget {
  const PosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("POS System"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const AddProductPage()));
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: const ProductGrid(),
      bottomNavigationBar: const CartBar(),
    );
  }
}
