import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin LoginStore {
  final tabProvider = StateProvider<int>((ref) => 0);
  final passwordObscureTextProvider = StateProvider<bool>((ref) => true);
  late TabController controller;

  void initTabController(TickerProvider vsync, WidgetRef ref) {
    controller = TabController(
      length: 2,
      vsync: vsync,
      initialIndex: ref.read(tabProvider),
    );
  }

  void onObscureTextChanged(WidgetRef ref) {
    ref.read(passwordObscureTextProvider.notifier).state =
        !ref.read(passwordObscureTextProvider);
  }

  double? getLetterSpacing(WidgetRef ref, bool obscureText) {
    if (obscureText) {
      if (ref.read(passwordObscureTextProvider)) {
        return 10;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Function()? getPasswordOnPressed(WidgetRef ref, bool obscureText) {
    if (obscureText) {
      return () {
        onObscureTextChanged(ref);
      };
    } else {
      return null;
    }
  }
}
