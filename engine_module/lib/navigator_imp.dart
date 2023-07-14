import 'package:flutter/foundation.dart';
import 'package:engine_module/navigator_api.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'ycNavigatorKey');

  String get appInitialRoute => _appInitialRoute;
  final String _appInitialRoute = PlatformDispatcher.instance.defaultRouteName;

  // 是否嵌入到app模式
  static const bool dev = bool.fromEnvironment('ycFlutter.env.dev');

  



  @override
  void push(String route, {bool toNative = true, Map<String, dynamic>? param}) {
      if (!dev && toNative) {
        _channel?.invokeMethod<void>("push", {"route": route, ...param ?? {}});
      } else {
          BuildContext? state = navigatorKey.currentState?.overlay?.context;
          BuildContext? context = navigatorKey.currentContext;
          if (kDebugMode) {
            print("stae: $state, context: $context");
          }
         state!.push(route,);
        //  state.pushNamed(route);
        //  state.goNamed(route);
        //  state.go(route);
         // Navigator.push(state!, MaterialPageRoute(builder: (context) => const Scaffold(body: Center(child: Text('test')))));
      }
    
  }

  @override
  void pop({bool toNative = true, Map? param}){
        // 检测当前路由栈 是否只有一个,
        BuildContext? state = navigatorKey.currentState?.overlay?.context;
      //  if (!dev && toNative) {
      //   _channel?.invokeMethod<void>("pop", param);
      // } else {
        if (state!.canPop()) {
          state.pop();
        } else {
          _channel?.invokeMethod<void>("pop", param);
        }

      //}
  }

}