import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'engine_web_plugin_platform_interface.dart';

/// An implementation of [EngineWebPluginPlatform] that uses method channels.
class MethodChannelEngineWebPlugin extends EngineWebPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('engine_web_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
