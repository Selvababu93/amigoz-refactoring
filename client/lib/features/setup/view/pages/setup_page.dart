import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodel/setup_view_model.dart';

class SetupPage extends ConsumerStatefulWidget {
  const SetupPage({super.key});

  @override
  ConsumerState<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends ConsumerState<SetupPage> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final countryCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();

  String currency = "AED";

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(setupViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Setup Your Shop")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Shop Name"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: cityCtrl,
                decoration: const InputDecoration(labelText: "City"),
              ),
              TextFormField(
                controller: stateCtrl,
                decoration: const InputDecoration(labelText: "State"),
              ),
              TextFormField(
                controller: countryCtrl,
                decoration: const InputDecoration(labelText: "Country"),
              ),
              TextFormField(
                controller: mobileCtrl,
                decoration: const InputDecoration(labelText: "Mobile"),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: currency,
                items: ["AED", "INR", "USD"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => currency = v!),
                decoration: const InputDecoration(labelText: "Currency"),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: vm.loading
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;

                        await ref.read(setupViewModelProvider.notifier).submit(
                              name: nameCtrl.text,
                              city: cityCtrl.text,
                              state: stateCtrl.text,
                              country: countryCtrl.text,
                              mobile: mobileCtrl.text,
                              currency: currency,
                              context: context,
                            );
                      },
                child: vm.loading
                    ? const CircularProgressIndicator()
                    : const Text("Continue"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
