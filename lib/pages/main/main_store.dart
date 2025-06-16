import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin MainStore {
  final PageController pageController = PageController(initialPage: 0);
  final navigationIndexProvider = StateProvider<int>((ref) => 0);
}
