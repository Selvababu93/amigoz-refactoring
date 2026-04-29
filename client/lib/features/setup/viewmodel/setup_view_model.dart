import 'package:amigoz/features/setup/repository/setup_repository.dart';
import 'package:amigoz/features/setup/viewmodel/setup_state.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'setup_view_model.g.dart';

@riverpod
class SetupViewModel extends _$SetupViewModel {
  @override
  SetupState build() => const SetupState();

  Future<void> submit(
      {required String name,
      required String city,
      required String state,
      required String country,
      required String mobile,
      required String currency,
      required BuildContext context}) async {
    this.state = this.state.copyWith(loading: true);
    final repo = ref.read(setupRepositoryProvider);

    try {
      await repo.saveShop(
          name: name,
          city: city,
          state: state,
          country: country,
          mobile: mobile,
          currency: currency);

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, "/home");
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    this.state = this.state.copyWith(loading: false);
  }
}
