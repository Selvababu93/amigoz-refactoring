import 'package:client/features/pos/viewmodel/pos_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddProductPage extends ConsumerStatefulWidget {
  const AddProductPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AddProductPageState();
  }
}

class _AddProductPageState extends ConsumerState<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  bool _loading = false;

  // Future<void> _submit() async {
  //   if (!_formKey.currentState!.validate()) return;
  //   setState(() {
  //     _loading = true;
  //   });

  //   try {
  //     await ref.read(posRepositoryProvider).addProduct(
  //           _nameController.text.trim(),
  //           double.parse(_priceController.text),
  //           _stockController.text.isEmpty
  //               ? 0
  //               : int.parse(_stockController.text),
  //         );
  //     if (mounted) {
  //       Navigator.pop(context);
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Error $e')));
  //   } finally {
  //     if (mounted) setState(() => _loading = false);
  //   }
  // }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Product"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Name
                  TextFormField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    decoration:
                        const InputDecoration(labelText: "Product Name"),
                    validator: (val) =>
                        val == null || val.isEmpty ? "Enter name" : null,
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  // Price
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: "price"),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.next,
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Enter Price';
                      if (double.tryParse(val) == null) return "Invalid Number";
                      return null;
                    },
                  ),

                  const SizedBox(
                    height: 12,
                  ),
                  //  Stock
                  TextFormField(
                    controller: _stockController,
                    decoration: const InputDecoration(labelText: "Stock"),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    validator: (val) {
                      if (val == null || val.isEmpty) return "Enter Stock";
                      if (int.tryParse(val) == null) return "Invalid Number";
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),

                  // Submit Button

                  // SizedBox(
                  //   width: double.infinity,
                  //   child: ElevatedButton(
                  //       onPressed: _loading ? null : _submit,
                  //       child: _loading
                  //           ? const CircularProgressIndicator()
                  //           : const Text("Add Product")),
                  // )

                  // ElevatedButton(
                  //     onPressed: () async {}, child: Text("Add Product")),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          await ref
                              .read(posViewModelProvider.notifier)
                              .addProduct(
                                  name: _nameController.text,
                                  price: double.parse(_priceController.text),
                                  stock: int.parse(_stockController.text));
                          Navigator.of(context).pop();
                        },
                        child: _loading
                            ? const CircularProgressIndicator()
                            : const Text("Add Product")),
                  )
                ],
              )),
        ));
  }
}
