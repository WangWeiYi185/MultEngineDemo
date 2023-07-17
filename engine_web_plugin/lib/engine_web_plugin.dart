
import 'engine_web_plugin_platform_interface.dart';

class EngineWebPlugin {
  Future<String?> getPlatformVersion() {
    return EngineWebPluginPlatform.instance.getPlatformVersion();
  }
}
