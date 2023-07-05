import 'package:flutter/foundation.dart';
import 'package:engine_module/navigator_api.dart';
import 'package:flutter/services.dart';
class YCNavigator extends INavigator {

  factory YCNavigator() {
    _instance ??= YCNavigator._();
    _channel = const MethodChannel('multiple-flutters'); // 暂时先写一下， 后期迁移平台Api 进一步解耦
    return _instance!;
  }

  YCNavigator._();
  static YCNavigator? _instance;
  static MethodChannel? _channel;

  String get appInitialRoute => _appInitialRoute;
  final String _appInitialRoute = PlatformDispatcher.instance.defaultRouteName;

  // 是否嵌入到app模式
  static const bool dev = bool.fromEnvironment('ycFlutter.env.dev');

  



  @override
  void push({bool toNative = true, Map? param}) {
      if (!dev && toNative) {
        _channel?.invokeMethod<void>("push", param);
      } else {
           
      }
    
  }

  void pop({bool toNative = true, Map? param}){
        // 检测当前路由栈 是否只有一个,
       if (!dev && toNative ) {
        _channel?.invokeMethod<void>("pop", param);
      } else {
          
      }
    
      
    
  }

}