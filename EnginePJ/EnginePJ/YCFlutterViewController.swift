//
//  YCFlutterViewController.swift
//  EnginePJ
//
//  Created by 王维一 on 2023/7/4.
//

import Flutter
// import FlutterPluginRegistrant
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
    let options = FlutterEngineGroupOptions.init();
    options.entrypoint = entryPoint;
    options.initialRoute = initRouter;


    let newEngine = appDelegate.enginesGroup.makeEngine(with: options)
    // GeneratedPluginRegistrant.register(with: newEngine)
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
          print("原生路由压栈 \(call.arguments ?? "")")
          if  let arguments = call.arguments as? [AnyHashable: Any?],
              let route = arguments["route"] as? String {
              print("原生路由压栈 \(route)")
              if (route == "/accounts") {
                  let vc = SingleFlutterViewController(withEntrypoint: "main", route)
                  navController.pushViewController(vc, animated: true)
              } else if (route == "/mine") {
                  let vc = SingleFlutterViewController(withEntrypoint: "main", route)
                  navController.pushViewController(vc, animated: true)
                  
              } else {
                  let vc = ViewController()
                  navController.pushViewController(vc, animated: true)
              }
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
        if (!(self.navigationController?.isNavigationBarHidden ?? true)) {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UIApplication.shared.applicationState == .active {
            // 防止crash隐患
            // https://github.com/flutter/flutter/issues/57973
            surfaceUpdated(true)
        }
        super.viewDidAppear(animated)
        
//        plugin.flutterPagesApi.didAppear { error in
//            // 在闭包中进行后续操作
//        }
    }
    
    func destroyFlutterEngine() {
        if(self.engine != nil && self.engine?.viewController != nil) {
            // In case of: The application must have a host view since the keyboard client must be part of the responder chain to function. The host view controller is (null)
            //[engine.textInputChannel invokeMethod:@"TextInput.clearClient" arguments:nil];
            engine?.viewController = nil;
            // 引擎内部的detach有几率不触发，此处尝试主动触发一次，通知flutter侧做清理工作
            engine?.lifecycleChannel.sendMessage("AppLifecycleState.detached");
            let blockEngine: FlutterEngine? = engine
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                // 引擎过早释放有几率导致crash
                // 局部变量引用，延迟释放
                if let blockEngine = blockEngine {
                    print("FlutterContainer engine destroy \(String(describing: Unmanaged.passUnretained(blockEngine).toOpaque()))")
                    blockEngine.destroyContext()
                }
                let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                if let engines = appDelegate.enginesGroup.value(forKeyPath: "engines") {
                    print("FlutterContainer engine remains \(String(describing: engines))")
                }
            }
      
        }
    }
    
    func dealloc() {
        self.destroyFlutterEngine();
    }
    
    override func surfaceUpdated(_ appeared: Bool) {
        if (self.engine != nil && self.engine?.viewController == self) {
            super.surfaceUpdated(appeared);
        }
    }
    
    

//    - (void)surfaceUpdated:(BOOL)appeared {
//        if (self.engine && self.engine.viewController == self) {
//            [super surfaceUpdated:appeared];
//        }
//    }
//
//    - (void)destroyFlutterEngine {
//
//        [self surfaceUpdated:NO];
//        [[GFLEngineFactory shared] destroyContextWith: self.engine];
//    }
//
//    - (void)dealloc {
//
//        // 通过engine group生成的engine默认是headless的，此处需要手动触发释放
//        [self destroyFlutterEngine];
//        NSLog(@"FlutterContainer vc dealloc %@", [self debugDescription]);
//    }
//

    
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
    
//    - (void)setSplashScreenView:(UIView *)splashScreenView {
//        return;
//    }
//
//    - (UIView *)splashScreenView {
//        return nil;
//    }
//
//    - (BOOL)loadDefaultSplashScreenView {
//        return NO;
//    }
//
//    - (GuangFlutterPlugin *)plugin {
//        if (!_plugin) {
//            _plugin = [GuangFlutterPlugin getPlugin:self.engine];
//        }
//        return _plugin;
//    }

    
}
