
import 'dart:ffi';
import 'package:flutter/foundation.dart';
import 'package:engine_module/navigator_api.dart';
class YCNavigator extends  INavigator {

  factory YCNavigator() {
    _instance ??= YCNavigator._();
    return _instance!;
  }

  YCNavigator._();

  String get appInitialRoute => _appInitialRoute;
  final String _appInitialRoute = PlatformDispatcher.instance.defaultRouteName;

  // 是否嵌入到app模式
  static const bool dev = bool.fromEnvironment('guangflutter.env.dev');

  static YCNavigator? _instance;



  @override
  void push(Bool toNative) {

    

    
  }

  void pop(){
    
  }

}