import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picacg/rust/api/storage/config.dart';
import 'package:picacg/rust/api/storage/net_data.dart';
import 'package:picacg/rust/api/storage/user_data.dart';
import 'package:picacg/utils/path_util.dart';

Config globalConfig = Config(
  userData: UserData(token: ''),
  netData: NetData(imageServer: ''),
);

class ConfigController extends StateNotifier<Config> {
  ConfigController(super.state);

  void init(Config config) {
    state = config;
  }

  Future<void> saveConfig(Config config) async {
    final configPath = await PathUtil.getConfigPath();
    picacgSetConfig(path: configPath, config: config);
    globalConfig = config;
    state = config;
  }

  Future<void> updateUserData(UserData userData) async {
    final newConfig = Config(userData: userData, netData: state.netData);
    await saveConfig(newConfig);
  }

  Future<void> updateNetData(NetData netData) async {
    final newConfig = Config(netData: netData, userData: state.userData);
    await saveConfig(newConfig);
  }
}

final configProvider = StateNotifierProvider<ConfigController, Config>(
  (ref) => ConfigController(
    Config(userData: UserData(token: ''), netData: NetData(imageServer: '')),
  ),
);
