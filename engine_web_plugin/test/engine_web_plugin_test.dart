import 'package:flutter_test/flutter_test.dart';
import 'package:engine_web_plugin/engine_web_plugin.dart';
import 'package:engine_web_plugin/engine_web_plugin_platform_interface.dart';
import 'package:engine_web_plugin/engine_web_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockEngineWebPluginPlatform
    with MockPlatformInterfaceMixin
    implements EngineWebPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final EngineWebPluginPlatform initialPlatform = EngineWebPluginPlatform.instance;

  test('$MethodChannelEngineWebPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelEngineWebPlugin>());
  });

  test('getPlatformVersion', () async {
    EngineWebPlugin engineWebPlugin = EngineWebPlugin();
    MockEngineWebPluginPlatform fakePlatform = MockEngineWebPluginPlatform();
    EngineWebPluginPlatform.instance = fakePlatform;

    expect(await engineWebPlugin.getPlatformVersion(), '42');
  });
}
