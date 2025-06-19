import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picacg/provider/config_provider.dart';
import 'package:picacg/rust/api/reqs/comic.dart';
import 'package:picacg/rust/api/storage/net_data.dart';

mixin MainStore {
  final PageController pageController = PageController(initialPage: 1);
  final navigationIndexProvider = StateProvider<int>((ref) => 0);

  void init(WidgetRef ref) async {
    try {
      final init = await picacgComicInit();
      final config = ref.read(configProvider.notifier);
      config.init(globalConfig);
      config.updateNetData(NetData(imageServer: init.imageServer));
    } catch (e) {
      debugPrint("Error initializing: $e");
    }
  }
}
