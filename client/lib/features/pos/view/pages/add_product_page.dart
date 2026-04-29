import 'dart:io';

import 'package:amigoz/features/pos/view/pages/barcode_scanner_page.dart';
import 'package:amigoz/features/pos/viewmodel/pos_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends ConsumerStatefulWidget {
  const AddProductPage({super.key});

  @override
  ConsumerState<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage> {
  final nameCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final stockCtrl = TextEditingController();
  final barcodeCtrl = TextEditingController();

  int? selectedCategoryId;
  File? imageFile;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    priceCtrl.dispose();
    stockCtrl.dispose();
    barcodeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(posViewModelProvider);
    final vm = ref.read(posViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Add Product")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            /// 🔹 IMAGE PICKER
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 120,
                color: Colors.grey[200],
                child: imageFile == null
                    ? const Icon(Icons.camera_alt)
                    : Image.file(imageFile!, fit: BoxFit.cover),
              ),
            ),

            const SizedBox(height: 16),

            /// 🔹 NAME
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Product Name"),
            ),

            const SizedBox(height: 12),

            /// 🔹 PRICE
            TextField(
              controller: priceCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Price"),
            ),

            const SizedBox(height: 12),

            /// 🔹 STOCK
            TextField(
              controller: stockCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Stock"),
            ),

            const SizedBox(height: 12),

            /// 🔹 CATEGORY DROPDOWN
            DropdownButtonFormField<int>(
              value: selectedCategoryId,
              hint: const Text("Select Category"),
              items: state.categories
                  .map((c) => DropdownMenuItem(
                        value: c.id,
                        child: Text(c.name),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategoryId = value;
                });
              },
            ),

            const SizedBox(height: 20),

            /// Barcode
            TextField(
              controller: barcodeCtrl,
              decoration: InputDecoration(
                labelText: "Barcode",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BarcodeScannerPage(),
                      ),
                    );

                    if (result != null) {
                      setState(() {
                        barcodeCtrl.text = result;
                      });
                    }
                  },
                ),
              ),
            ),

            /// 🔹 SAVE BUTTON
            ElevatedButton(
              onPressed: () async {
                final name = nameCtrl.text.trim();
                final price = double.tryParse(priceCtrl.text) ?? 0;
                final stock = int.tryParse(stockCtrl.text) ?? 0;

                if (name.isEmpty) return;

                await vm.addProduct(
                    name: name,
                    price: price,
                    stock: stock,
                    categoryId: selectedCategoryId,
                    imagePath: imageFile?.path,
                    barcode: barcodeCtrl.text.trim().isEmpty
                        ? null
                        : barcodeCtrl.text.trim());

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text("Save Product"),
            )
          ],
        ),
      ),
    );
  }
}
