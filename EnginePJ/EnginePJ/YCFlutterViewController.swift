//
//  YCFlutterViewController.swift
//  EnginePJ
//
//  Created by 王维一 on 2023/7/4.
//
import Flutter
import FlutterPluginRegistrant
import Foundation

/// A FlutterViewController intended for the MyApp widget in the Flutter module.
///
/// This view controller maintains a connection to the Flutter instance and syncs it with the
/// datamodel.  In practice you should override the other init methods or switch to composition
/// instead of inheritence.
class SingleFlutterViewController: FlutterViewController, DataModelObserver {
  private var channel: FlutterMethodChannel?

    init(withEntrypoint entryPoint: String?, _ initRouter: String?) {
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let newEngine = appDelegate.engines.makeEngine(withEntrypoint: entryPoint, libraryURI: nil, initialRoute: initRouter)
    GeneratedPluginRegistrant.register(with: newEngine)
    super.init(engine: newEngine, nibName: nil, bundle: nil)
    DataModel.shared.addObserver(observer: self)
  }

  deinit {
    DataModel.shared.removeObserver(observer: self)
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func onCountUpdate(newCount: Int64) {
    if let channel = channel {
      channel.invokeMethod("setCount", arguments: newCount)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    channel = FlutterMethodChannel(
      name: "multiple-flutters", binaryMessenger: self.engine!.binaryMessenger)
    channel!.invokeMethod("setCount", arguments: DataModel.shared.count)
    let navController = self.navigationController!
    channel!.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "incrementCount" {
        DataModel.shared.count = DataModel.shared.count + 1
        result(nil)
      } else if call.method == "push" {
          print("原生路由压栈 \(type(of: call.arguments))")
          if  let arguments = call.arguments as? [AnyHashable: Any?],
              let route = arguments["route"] as? String {
              let vc = SingleFlutterViewController(withEntrypoint: "main", route)
              navController.pushViewController(vc, animated: true)
              result("")
          } else {
              result("")
          }
          
          
          
          
      } else if call.method == "pop" {
          print("原生路由弹栈 \(call.arguments ?? "")")
          navController.popViewController(animated: true)
          
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
  }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (!(self.navigationController?.isNavigationBarHidden ?? <#default value#>)) {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
        
    }
    

    
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    if (!self.navigationController.navigationBarHidden) {
//        [self.navigationController setNavigationBarHidden:YES animated:NO];
//    }
//
//    [self.plugin.flutterPagesApi willAppearWithCompletion:^(NSError * _Nullable error) {
//
//     }];
//
//
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
//        // 防止crash隐患
//        // https://github.com/flutter/flutter/issues/57973
//        [self surfaceUpdated:YES];
//    }
//    [super viewDidAppear:animated];
//
//    [self.plugin.flutterPagesApi didAppearWithCompletion:^(NSError * _Nullable error) {}];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [[UIApplication sharedApplication].delegate.window endEditing:YES];
//    [super viewWillDisappear:animated];
//    [self.plugin.flutterPagesApi willDisappearWithCompletion:^(NSError * _Nullable error) {}];
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    if (![self.navigationController.viewControllers containsObject:self] && ![self presentedViewController]) {
//        if (self.yzPageResultBlock) {
//            self.yzPageResultBlock(self.plugin.pageResult);
//        }
//    }
//    [self.plugin.flutterPagesApi didDisappearWithCompletion:^(NSError * _Nullable error) {}];
//}
//
    
}
