import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'engine_web_plugin_method_channel.dart';

abstract class EngineWebPluginPlatform extends PlatformInterface {
  /// Constructs a EngineWebPluginPlatform.
  EngineWebPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static EngineWebPluginPlatform _instance = MethodChannelEngineWebPlugin();

  /// The default instance of [EngineWebPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelEngineWebPlugin].
  static EngineWebPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [EngineWebPluginPlatform] when
  /// they register themselves.
  static set instance(EngineWebPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
